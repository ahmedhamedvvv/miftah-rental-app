import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart' show immutable, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models.dart';
import '../data/seed.dart';
import '../domain/ledger.dart';

/// Overridden in `main()` once preferences have loaded.
final prefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('prefsProvider must be overridden'),
);

/// Lets tests pin "now" to a fixed moment.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

enum UserRole { tenant, owner }

@immutable
class AppSettings {
  const AppSettings({required this.locale, required this.themeMode, this.role});

  final Locale locale;
  final ThemeMode themeMode;
  final UserRole? role;

  bool get isArabic => locale.languageCode == 'ar';

  AppSettings copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    UserRole? Function()? role,
  }) => AppSettings(
    locale: locale ?? this.locale,
    themeMode: themeMode ?? this.themeMode,
    role: role != null ? role() : this.role,
  );
}

class SettingsController extends Notifier<AppSettings> {
  SharedPreferences get _prefs => ref.read(prefsProvider);

  /// `?lang=en` on the web sets the starting language without touching the
  /// saved choice.
  static String? get _urlLang {
    final lang = kIsWeb ? Uri.base.queryParameters['lang'] : null;
    return lang == 'ar' || lang == 'en' ? lang : null;
  }

  @override
  AppSettings build() {
    final prefs = ref.watch(prefsProvider);
    final role = prefs.getString('settings.role');
    return AppSettings(
      locale: Locale(_urlLang ?? prefs.getString('settings.locale') ?? 'ar'),
      themeMode: ThemeMode.values.byName(
        prefs.getString('settings.theme') ?? ThemeMode.dark.name,
      ),
      role: role == null ? null : UserRole.values.byName(role),
    );
  }

  void setLocale(Locale locale) {
    _prefs.setString('settings.locale', locale.languageCode);
    state = state.copyWith(locale: locale);
  }

  void toggleLocale() => setLocale(Locale(state.isArabic ? 'en' : 'ar'));

  void setThemeMode(ThemeMode mode) {
    _prefs.setString('settings.theme', mode.name);
    state = state.copyWith(themeMode: mode);
  }

  void toggleTheme() => setThemeMode(
    state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
  );

  void enter(UserRole role) {
    _prefs.setString('settings.role', role.name);
    state = state.copyWith(role: () => role);
  }

  void leave() {
    _prefs.remove('settings.role');
    state = state.copyWith(role: () => null);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

/// The whole demo portfolio with every action the screens can take on it.
/// Changes are saved to the device immediately.
class PortfolioStore extends Notifier<Portfolio> {
  static const _key = 'portfolio.v1';

  SharedPreferences get _prefs => ref.read(prefsProvider);
  DateTime get _now => ref.read(clockProvider)();
  final _rnd = Random();

  @override
  Portfolio build() {
    final saved = ref.watch(prefsProvider).getString(_key);
    if (saved != null) {
      try {
        return Portfolio.fromJson(jsonDecode(saved) as Map<String, dynamic>);
      } catch (_) {
        // Fall through to a fresh seed if the saved shape is outdated.
      }
    }
    return buildSeed(ref.read(clockProvider)());
  }

  void _save(Portfolio next) {
    state = next;
    _prefs.setString(_key, jsonEncode(next.toJson()));
  }

  void reset() {
    _prefs.remove(_key);
    state = buildSeed(_now);
  }

  String _reference() => 'MF${100000 + _rnd.nextInt(899999)}';

  /// Records a tenant payment and returns the receipt reference.
  String pay(String installmentId, PayMethod method) {
    final ref = _reference();
    final now = _now;
    late Installment paid;
    final items = [
      for (final i in state.installments)
        if (i.id == installmentId) paid = i.pay(now, method, ref) else i,
    ];
    final notice = Notice(
      id: 'n_${now.microsecondsSinceEpoch}',
      kind: NoticeKind.payment,
      title: const Bi('تم استلام دفعتك', 'Payment received'),
      body: Bi(
        'وصلتنا ${paid.amount} ر.س. رقم الإيصال $ref.',
        'We received SAR ${paid.amount}. Receipt $ref.',
      ),
      at: now,
    );
    _save(
      state.copyWith(installments: items, notices: [notice, ...state.notices]),
    );
    return ref;
  }

  void markCashPaid(String installmentId) {
    final now = _now;
    _save(
      state.copyWith(
        installments: [
          for (final i in state.installments)
            i.id == installmentId
                ? i.pay(now, PayMethod.cash, _reference())
                : i,
        ],
      ),
    );
  }

  Ticket createTicket({
    required String unitId,
    required TicketCategory category,
    required String description,
    required int slot,
    required bool urgent,
  }) {
    final now = _now;
    final number = state.tickets.map((t) => t.number).fold(1000, max) + 1;
    final ticket = Ticket(
      id: 'k_${now.microsecondsSinceEpoch}',
      number: number,
      unitId: unitId,
      category: category,
      description: Bi(description, description),
      preferredSlot: slot,
      urgent: urgent,
      events: [TicketEvent(TicketStatus.open, now)],
    );
    final notice = Notice(
      id: 'n_${now.microsecondsSinceEpoch}',
      kind: NoticeKind.maintenance,
      title: const Bi('استلمنا طلب الصيانة', 'Maintenance request received'),
      body: Bi(
        'طلبك #$number وصل للمالك وهيتعيّن له فني قريب.',
        'Request #$number reached the owner and will be assigned soon.',
      ),
      at: now,
    );
    _save(
      state.copyWith(
        tickets: [ticket, ...state.tickets],
        notices: [notice, ...state.notices],
      ),
    );
    return ticket;
  }

  void moveTicket(String id, TicketStatus to, {String? technician, int? cost}) {
    final now = _now;
    _save(
      state.copyWith(
        tickets: [
          for (final t in state.tickets)
            if (t.id != id || t.status == to)
              t
            else
              t.copyWith(
                events: [...t.events, TicketEvent(to, now)],
                technician:
                    technician ??
                    t.technician ??
                    (to != TicketStatus.open ? _techFor(t.category) : null),
                cost: cost,
              ),
        ],
      ),
    );
  }

  void assign(String id, String technician) {
    final t = state.tickets.firstWhere((t) => t.id == id);
    if (t.status == TicketStatus.open) {
      moveTicket(id, TicketStatus.assigned, technician: technician);
    } else {
      _save(
        state.copyWith(
          tickets: [
            for (final x in state.tickets)
              x.id == id ? x.copyWith(technician: technician) : x,
          ],
        ),
      );
    }
  }

  void rateTicket(String id, int rating) {
    _save(
      state.copyWith(
        tickets: [
          for (final t in state.tickets)
            t.id == id ? t.copyWith(rating: rating) : t,
        ],
      ),
    );
  }

  void requestRenewal(String contractId) {
    _save(
      state.copyWith(
        contracts: [
          for (final c in state.contracts)
            c.id == contractId ? c.copyWith(renewalRequested: true) : c,
        ],
      ),
    );
  }

  void markNoticesRead() {
    _save(
      state.copyWith(notices: [for (final n in state.notices) n.markRead()]),
    );
  }

  /// Leases a vacant unit to a new tenant. The first installment is due on
  /// the start date.
  void lease({
    required String unitId,
    required String name,
    required String phone,
    required String nationalId,
    required DateTime start,
    required PayFrequency frequency,
    required int annualRent,
  }) {
    final stamp = _now.microsecondsSinceEpoch;
    final tenant = Tenant(
      id: 't_$stamp',
      name: Bi(name, name),
      phone: phone,
      nationalId: nationalId.padRight(10, '0'),
    );
    final contract = Contract(
      id: 'c_$stamp',
      unitId: unitId,
      tenantId: tenant.id,
      ejarNumber: '2026${(1000000 + _rnd.nextInt(8999999))}',
      start: start,
      end: DateTime(start.year + 1, start.month, start.day),
      frequency: frequency,
      annualRent: annualRent,
    );
    final installments = [
      for (var k = 0; k < frequency.perYear; k++)
        Installment(
          id: '${contract.id}_$k',
          contractId: contract.id,
          index: k,
          due: DateTime(
            start.year,
            start.month + k * frequency.monthsApart,
            start.day,
          ),
          amount: annualRent ~/ frequency.perYear,
        ),
    ];
    _save(
      state.copyWith(
        tenants: [...state.tenants, tenant],
        contracts: [...state.contracts, contract],
        installments: [...state.installments, ...installments],
      ),
    );
  }

  static String _techFor(TicketCategory c) => switch (c) {
    TicketCategory.ac => 'tech_ac',
    TicketCategory.plumbing => 'tech_plumb',
    TicketCategory.electrical => 'tech_elec',
    _ => 'tech_gen',
  };
}

final portfolioProvider = NotifierProvider<PortfolioStore, Portfolio>(
  PortfolioStore.new,
);

final ledgerProvider = Provider<Ledger>(
  (ref) => Ledger(ref.watch(portfolioProvider), ref.watch(clockProvider)()),
);

/// The signed-in tenant's lease, for the tenant side.
@immutable
class MyLease {
  const MyLease({
    required this.tenant,
    required this.unit,
    required this.property,
    required this.contract,
    required this.installments,
    required this.next,
  });

  final Tenant tenant;
  final Unit unit;
  final Property property;
  final Contract contract;
  final List<Installment> installments;
  final Installment? next;
}

final myLeaseProvider = Provider<MyLease>((ref) {
  final ledger = ref.watch(ledgerProvider);
  final tenant = ledger.tenant(ledger.data.meTenantId);
  final contract = ledger.contractOfTenant(tenant.id)!;
  final unit = ledger.unit(contract.unitId);
  return MyLease(
    tenant: tenant,
    unit: unit,
    property: ledger.property(unit.propertyId),
    contract: contract,
    installments: ledger.installmentsOf(contract.id),
    next: ledger.nextDue(contract.id),
  );
});

/// Units the owner already sent a reminder to in this session.
class RemindedController extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void add(String installmentId) => state = {...state, installmentId};
}

final remindedProvider = NotifierProvider<RemindedController, Set<String>>(
  RemindedController.new,
);
