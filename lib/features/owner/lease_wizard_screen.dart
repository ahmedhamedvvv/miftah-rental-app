import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/photo.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

/// Lease a vacant unit in three steps: unit, tenant, terms.
class LeaseWizardScreen extends ConsumerStatefulWidget {
  const LeaseWizardScreen({super.key, this.unitId});

  final String? unitId;

  @override
  ConsumerState<LeaseWizardScreen> createState() => _LeaseWizardScreenState();
}

class _LeaseWizardScreenState extends ConsumerState<LeaseWizardScreen> {
  late int _step = widget.unitId == null ? 0 : 1;
  late String? _unitId = widget.unitId;
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _id = TextEditingController();
  final _rent = TextEditingController();
  PayFrequency _freq = PayFrequency.semiAnnual;
  int _startChoice = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _phone, _id, _rent]) {
      c.addListener(() => setState(() {}));
    }
    if (_unitId != null) _setUnit(_unitId!);
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _id, _rent]) {
      c.dispose();
    }
    super.dispose();
  }

  void _setUnit(String id) {
    _unitId = id;
    _rent.text = '${ref.read(ledgerProvider).unit(id).annualRent}';
  }

  DateTime get _start {
    final t = ref.read(clockProvider)();
    return _startChoice == 0
        ? DateTime(t.year, t.month, t.day)
        : DateTime(t.year, t.month + 1, 1);
  }

  bool get _phoneOk =>
      RegExp(r'^5\d{8}$').hasMatch(_phone.text.replaceAll(' ', ''));

  bool get _canNext => switch (_step) {
    0 => _unitId != null,
    1 =>
      _name.text.trim().length >= 3 && _phoneOk && _id.text.trim().length == 10,
    _ => (int.tryParse(_rent.text) ?? 0) > 0,
  };

  void _fillSample() {
    final ar = context.arabic;
    _name.text = ar ? 'سلمان العتيبي' : 'Salman Al-Otaibi';
    _phone.text = '541234567';
    _id.text = '1093847561';
  }

  Future<void> _confirm() async {
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    ref
        .read(portfolioProvider.notifier)
        .lease(
          unitId: _unitId!,
          name: _name.text.trim(),
          phone: '+966${_phone.text.replaceAll(' ', '')}',
          nationalId: _id.text.trim(),
          start: _start,
          frequency: _freq,
          annualRent: int.parse(_rent.text),
        );
    showToast(context, context.l10n.leaseCreated, icon: Icons.key_rounded);
    context.pushReplacement(Routes.unit(_unitId!));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final titles = [l.chooseUnit, l.tenantDetails, l.leaseTerms];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.page,
                Insets.md,
                Insets.page,
                0,
              ),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: Icons.close_rounded,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: Insets.lg),
                  Expanded(
                    child: Row(
                      children: [
                        for (var i = 0; i < 3; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              height: 5,
                              decoration: BoxDecoration(
                                color: i <= _step ? p.glow : p.line,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: Insets.lg),
                  Text('${_step + 1}/3', style: context.text.labelMedium),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 340),
                child: ListView(
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(
                    Insets.page,
                    Insets.xl,
                    Insets.page,
                    Insets.xl,
                  ),
                  children: [
                    Text(
                      l.newLease,
                      style: context.text.labelMedium?.copyWith(color: p.glow),
                    ),
                    const SizedBox(height: 4),
                    Text(titles[_step], style: context.text.displaySmall),
                    const SizedBox(height: Insets.xl),
                    ...switch (_step) {
                      0 => _units(),
                      1 => _tenant(),
                      _ => _terms(),
                    },
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.page,
                0,
                Insets.page,
                Insets.lg,
              ),
              child: Row(
                children: [
                  if (_step > 0 && !(widget.unitId != null && _step == 1)) ...[
                    SizedBox(
                      width: 110,
                      child: GhostButton(
                        label: l.back,
                        onPressed: () => setState(() => _step--),
                      ),
                    ),
                    const SizedBox(width: Insets.md),
                  ],
                  Expanded(
                    child: PrimaryButton(
                      label: _step < 2 ? l.next : l.createLease,
                      icon: _step < 2 ? null : Icons.key_rounded,
                      busy: _busy,
                      onPressed: !_canNext
                          ? null
                          : (_step < 2
                                ? () => setState(() => _step++)
                                : _confirm),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _units() {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final vacant = ledger.vacantUnits();
    return [
      Text(l.vacantUnitsCount(vacant.length), style: context.text.bodySmall),
      const SizedBox(height: Insets.md),
      for (final (i, u) in vacant.indexed)
        Padding(
          padding: const EdgeInsets.only(bottom: Insets.sm),
          child: Pressable(
            onTap: () => setState(() => _setUnit(u.id)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _unitId == u.id ? p.cobaltSoft : p.surface,
                borderRadius: BorderRadius.circular(Radii.card),
                border: Border.all(
                  color: _unitId == u.id ? p.cobalt : p.line,
                  width: _unitId == u.id ? 1.6 : 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Photo(u.photos.first, radius: 14),
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${unitKindLabel(l, u.kind)} ${u.number}',
                          style: context.text.titleSmall,
                        ),
                        Text(
                          ledger.property(u.propertyId).name.of(ar),
                          style: context.text.bodySmall,
                        ),
                        Text(
                          '${u.bedrooms > 0 ? '${l.bedrooms(u.bedrooms)} · ' : ''}${l.areaSqm(u.area)}',
                          style: context.text.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    Fmt.compact(context, u.annualRent),
                    style: context.text.titleMedium?.copyWith(color: p.glow),
                  ),
                ],
              ),
            ),
          ).entrance(i),
        ),
    ];
  }

  List<Widget> _tenant() {
    final l = context.l10n;
    return [
      TextField(
        controller: _name,
        decoration: InputDecoration(labelText: l.fullName),
      ),
      const SizedBox(height: Insets.md),
      TextField(
        controller: _phone,
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        decoration: InputDecoration(
          labelText: l.mobile,
          hintText: '5x xxx xxxx',
          prefixText: '+966 ',
          errorText: _phone.text.isNotEmpty && !_phoneOk
              ? l.phoneInvalid
              : null,
        ),
      ),
      const SizedBox(height: Insets.md),
      TextField(
        controller: _id,
        keyboardType: TextInputType.number,
        maxLength: 10,
        textDirection: TextDirection.ltr,
        decoration: InputDecoration(
          labelText: l.nationalIdOrIqama,
          counterText: '',
        ),
      ),
      const SizedBox(height: Insets.lg),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: GhostButton(
          label: l.fillSample,
          icon: Icons.auto_awesome_rounded,
          onPressed: _fillSample,
        ),
      ),
    ];
  }

  List<Widget> _terms() {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final unit = ledger.unit(_unitId!);
    final rent = int.tryParse(_rent.text) ?? 0;
    return [
      Text(l.startDate, style: context.text.titleSmall),
      const SizedBox(height: Insets.sm),
      Segmented<int>(
        options: [(0, l.today), (1, l.firstOfNextMonth)],
        selected: _startChoice,
        onChanged: (v) => setState(() => _startChoice = v),
      ),
      const SizedBox(height: Insets.lg),
      Text(l.paymentPlan, style: context.text.titleSmall),
      const SizedBox(height: Insets.sm),
      Wrap(
        spacing: Insets.sm,
        runSpacing: Insets.sm,
        children: [
          for (final f in PayFrequency.values)
            Pressable(
              onTap: () => setState(() => _freq = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _freq == f ? p.cobalt : p.surface,
                  borderRadius: BorderRadius.circular(Radii.pill),
                  border: Border.all(color: _freq == f ? p.cobalt : p.line),
                ),
                child: Text(
                  frequencyLabel(l, f),
                  style: context.text.labelMedium?.copyWith(
                    color: _freq == f ? Colors.white : p.ink,
                  ),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: Insets.lg),
      TextField(
        controller: _rent,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: l.annualRentSar),
      ),
      const SizedBox(height: Insets.xl),
      Panel(
        color: p.raised,
        child: Column(
          children: [
            LabelValue(
              l.unit,
              '${unit.number} · ${ledger.property(unit.propertyId).name.of(ar)}',
            ),
            LabelValue(l.tenant, _name.text.trim()),
            LabelValue(
              l.leasePeriod,
              '${Fmt.date(context, _start)} – ${Fmt.date(context, DateTime(_start.year + 1, _start.month, _start.day))}',
            ),
            LabelValue(
              l.installment,
              '${_freq.perYear} × ${Fmt.sar(context, rent ~/ _freq.perYear)}',
            ),
            LabelValue(l.vat, unit.isCommercial ? l.vat15 : l.vatExempt),
            const SizedBox(height: Insets.sm),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 15, color: p.muted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(l.ejarNote, style: context.text.bodySmall),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
