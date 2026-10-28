import '../data/models.dart';

/// Read-only questions the screens ask about a [Portfolio] on a given day.
/// Kept free of Flutter so it can be unit tested.
class Ledger {
  Ledger(this.data, this.today)
    : _unitById = {for (final u in data.units) u.id: u},
      _tenantById = {for (final t in data.tenants) t.id: t},
      _propertyById = {for (final p in data.properties) p.id: p};

  final Portfolio data;
  final DateTime today;

  final Map<String, Unit> _unitById;
  final Map<String, Tenant> _tenantById;
  final Map<String, Property> _propertyById;

  /// An unpaid installment due within this many days counts as "due soon".
  static const dueSoonDays = 30;

  Unit unit(String id) => _unitById[id]!;
  Tenant tenant(String id) => _tenantById[id]!;
  Property property(String id) => _propertyById[id]!;

  List<Unit> unitsOf(String propertyId) =>
      data.units.where((u) => u.propertyId == propertyId).toList()
        ..sort((a, b) {
          final f = b.floor.compareTo(a.floor);
          return f != 0 ? f : a.number.compareTo(b.number);
        });

  Contract? activeContract(String unitId) {
    for (final c in data.contracts) {
      if (c.unitId == unitId && c.isActiveOn(today)) return c;
    }
    return null;
  }

  Contract? contractOfTenant(String tenantId) {
    for (final c in data.contracts) {
      if (c.tenantId == tenantId && c.isActiveOn(today)) return c;
    }
    return null;
  }

  List<Installment> installmentsOf(String contractId) =>
      data.installments.where((i) => i.contractId == contractId).toList()
        ..sort((a, b) => a.due.compareTo(b.due));

  /// The earliest unpaid installment, overdue or not.
  Installment? nextDue(String contractId) {
    for (final i in installmentsOf(contractId)) {
      if (!i.isPaid) return i;
    }
    return null;
  }

  bool isLate(Installment i) => !i.isPaid && i.due.isBefore(_day(today));

  int daysUntil(DateTime d) => _day(d).difference(_day(today)).inDays;

  UnitStatus statusOf(String unitId) {
    final c = activeContract(unitId);
    if (c == null) return UnitStatus.vacant;
    final next = nextDue(c.id);
    if (next == null) return UnitStatus.paid;
    if (isLate(next)) return UnitStatus.late;
    if (daysUntil(next.due) <= dueSoonDays) return UnitStatus.dueSoon;
    return UnitStatus.paid;
  }

  Map<UnitStatus, int> statusCounts([String? propertyId]) {
    final counts = {for (final s in UnitStatus.values) s: 0};
    for (final u in data.units) {
      if (propertyId != null && u.propertyId != propertyId) continue;
      counts[statusOf(u.id)] = counts[statusOf(u.id)]! + 1;
    }
    return counts;
  }

  double occupancy([String? propertyId]) {
    final c = statusCounts(propertyId);
    final total = c.values.fold(0, (a, b) => a + b);
    if (total == 0) return 0;
    return (total - c[UnitStatus.vacant]!) / total;
  }

  /// Unpaid installments past their due date, oldest first.
  List<Installment> overdue() =>
      data.installments.where(isLate).toList()
        ..sort((a, b) => a.due.compareTo(b.due));

  /// Unpaid installments due in the next [dueSoonDays] days.
  List<Installment> upcoming() => data.installments.where((i) {
    if (i.isPaid || isLate(i)) return false;
    return daysUntil(i.due) <= dueSoonDays;
  }).toList()..sort((a, b) => a.due.compareTo(b.due));

  List<Installment> paidIn(int year, int month) => data.installments.where((i) {
    final p = i.paidAt;
    return p != null && p.year == year && p.month == month;
  }).toList()..sort((a, b) => b.paidAt!.compareTo(a.paidAt!));

  int sum(Iterable<Installment> items) => items.fold(0, (a, i) => a + i.amount);

  /// Money collected in each of the last [months] months, oldest first.
  List<({DateTime month, int amount})> monthlyIncome({
    int months = 12,
    String? propertyId,
  }) {
    final out = <({DateTime month, int amount})>[];
    for (var k = months - 1; k >= 0; k--) {
      final m = DateTime(today.year, today.month - k);
      final items = paidIn(m.year, m.month).where(
        (i) =>
            propertyId == null ||
            unit(contract(i.contractId).unitId).propertyId == propertyId,
      );
      out.add((month: m, amount: sum(items)));
    }
    return out;
  }

  Contract contract(String id) => data.contracts.firstWhere((c) => c.id == id);

  Unit unitOfInstallment(Installment i) => unit(contract(i.contractId).unitId);

  Tenant tenantOfInstallment(Installment i) =>
      tenant(contract(i.contractId).tenantId);

  List<Ticket> ticketsOfUnit(String unitId) =>
      data.tickets.where((t) => t.unitId == unitId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Ticket> openTickets() =>
      data.tickets.where((t) => t.status != TicketStatus.done).toList();

  /// Contracts that end within the next 60 days.
  List<Contract> expiringSoon() => data.contracts.where((c) {
    if (!c.isActiveOn(today)) return false;
    return daysUntil(c.end) <= 60;
  }).toList()..sort((a, b) => a.end.compareTo(b.end));

  List<Unit> vacantUnits() =>
      data.units.where((u) => statusOf(u.id) == UnitStatus.vacant).toList();

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
}
