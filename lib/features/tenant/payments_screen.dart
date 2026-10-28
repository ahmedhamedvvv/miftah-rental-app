import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  bool _history = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final ledger = ref.watch(ledgerProvider);
    final lease = ref.watch(myLeaseProvider);
    final all = [
      for (final c in ledger.data.contracts.where(
        (c) => c.tenantId == lease.tenant.id,
      ))
        ...ledger.installmentsOf(c.id),
    ];
    final upcoming = all.where((i) => !i.isPaid).toList()
      ..sort((a, b) => a.due.compareTo(b.due));
    final paid = all.where((i) => i.isPaid).toList()
      ..sort((a, b) => b.paidAt!.compareTo(a.paidAt!));
    final paidThisLease = ledger.sum(lease.installments.where((i) => i.isPaid));
    final left = lease.contract.annualRent - paidThisLease;
    final items = _history ? paid : upcoming;

    return PageScaffold(
      title: l.navPayments,
      subtitle: l.paymentsSubtitle,
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Figure(
                      label: l.paidThisLease,
                      value: paidThisLease,
                      color: p.paid,
                    ),
                  ),
                  Container(width: 1, height: 44, color: p.line),
                  const SizedBox(width: Insets.lg),
                  Expanded(
                    child: _Figure(
                      label: l.remaining,
                      value: left,
                      color: p.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: paidThisLease / lease.contract.annualRent,
                  ),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => LinearProgressIndicator(
                    value: v,
                    minHeight: 8,
                    backgroundColor: p.raised,
                    color: p.paid,
                  ),
                ),
              ),
            ],
          ),
        ).entrance(0),
        const SizedBox(height: Insets.xl),
        Segmented<bool>(
          options: [(false, l.upcoming), (true, l.paidHistory)],
          selected: _history,
          onChanged: (v) => setState(() => _history = v),
        ),
        const SizedBox(height: Insets.lg),
        if (items.isEmpty)
          EmptyNote(icon: Icons.celebration_rounded, text: l.nothingDue)
        else
          for (final (i, inst) in items.indexed)
            Padding(
              key: ValueKey('${_history}_${inst.id}'),
              padding: const EdgeInsets.only(bottom: Insets.sm),
              child: _InstallmentRow(
                inst: inst,
                late: ledger.isLate(inst),
                frequency: ledger.contract(inst.contractId).frequency,
                onTap: () => inst.isPaid
                    ? context.push(Routes.receipt(inst.id))
                    : context.push(Routes.pay(inst.id)),
              ).entrance(i),
            ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.bodySmall),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: CountUp(
            value: value,
            format: (v) => Fmt.sar(context, v.round()),
            style: context.text.headlineSmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _InstallmentRow extends StatelessWidget {
  const _InstallmentRow({
    required this.inst,
    required this.late,
    required this.frequency,
    required this.onTap,
  });

  final Installment inst;
  final bool late;
  final PayFrequency frequency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final color = inst.isPaid ? p.paid : (late ? p.late : p.soon);
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  '${(inst.paidAt ?? inst.due).day}',
                  style: context.text.titleLarge?.copyWith(
                    color: color,
                    height: 1,
                  ),
                ),
                Text(
                  Fmt.monthShort(context, inst.paidAt ?? inst.due),
                  style: context.text.labelSmall?.copyWith(color: color),
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.installmentOf(inst.index + 1, frequency.perYear),
                  style: context.text.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  inst.isPaid
                      ? '${methodLabel(l, inst.method!)} · ${inst.reference}'
                      : (late
                            ? l.wasDue(Fmt.date(context, inst.due))
                            : l.dueOn(Fmt.date(context, inst.due))),
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Fmt.sar(context, inst.amount),
                style: context.text.titleSmall,
              ),
              const SizedBox(height: 4),
              Pill(
                inst.isPaid
                    ? l.statusPaid
                    : (late ? l.statusLate : l.statusUnpaid),
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
