import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

enum _Tab { late, upcoming, paid }

class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({super.key});

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  _Tab _tab = _Tab.late;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final ledger = ref.watch(ledgerProvider);
    final today = ledger.today;
    final late = ledger.overdue();
    final upcoming = ledger.upcoming();
    final paid = ledger.paidIn(today.year, today.month);
    final collected = ledger.sum(paid);
    final expected =
        collected +
        ledger.sum(upcoming.where((i) => i.due.month == today.month)) +
        ledger.sum(late);
    final items = switch (_tab) {
      _Tab.late => late,
      _Tab.upcoming => upcoming,
      _Tab.paid => paid,
    };

    return PageScaffold(
      title: l.navCollections,
      subtitle: Fmt.month(context, today),
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.collectionRate, style: context.text.bodySmall),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CountUp(
                    value: expected == 0 ? 100 : collected / expected * 100,
                    format: (v) => '${v.round()}%',
                    style: context.text.displayMedium,
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        l.collectedOf(
                          Fmt.sar(context, collected),
                          Fmt.sar(context, expected),
                        ),
                        style: context.text.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.md),
              // Stacked bar: collected, still due, overdue.
              LayoutBuilder(
                builder: (context, box) {
                  final total = expected == 0 ? 1 : expected;
                  final dueSoon = ledger.sum(
                    upcoming.where((i) => i.due.month == today.month),
                  );
                  Widget seg(int v, Color c) => TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: box.maxWidth * v / total),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    builder: (_, w, _) =>
                        Container(width: w, height: 10, color: c),
                  );
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: p.raised,
                      child: Row(
                        children: [
                          seg(collected, p.paid),
                          seg(dueSoon, p.soon),
                          seg(ledger.sum(late), p.late),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: Insets.md),
              Wrap(
                spacing: Insets.lg,
                runSpacing: 6,
                children: [
                  _Dot(p.paid, l.collected),
                  _Dot(p.soon, l.dueThisMonth),
                  _Dot(p.late, l.overdue),
                ],
              ),
            ],
          ),
        ).entrance(0),
        const SizedBox(height: Insets.xl),
        Segmented<_Tab>(
          options: [
            (_Tab.late, '${l.statusLate} ${late.length}'),
            (_Tab.upcoming, '${l.upcoming} ${upcoming.length}'),
            (_Tab.paid, '${l.statusPaid} ${paid.length}'),
          ],
          selected: _tab,
          onChanged: (t) => setState(() => _tab = t),
        ),
        const SizedBox(height: Insets.lg),
        if (items.isEmpty)
          EmptyNote(icon: Icons.task_alt_rounded, text: l.nothingHere)
        else
          for (final (i, inst) in items.indexed)
            Padding(
              key: ValueKey('${_tab}_${inst.id}'),
              padding: const EdgeInsets.only(bottom: Insets.sm),
              child: CollectionRow(inst: inst).entrance(i.clamp(0, 10)),
            ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color, this.label);

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: context.text.labelSmall),
      ],
    );
  }
}

/// One installment with the owner's actions: remind or record cash.
class CollectionRow extends ConsumerWidget {
  const CollectionRow({super.key, required this.inst, this.showTenant = true});

  final Installment inst;
  final bool showTenant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final unit = ledger.unitOfInstallment(inst);
    final tenant = ledger.tenantOfInstallment(inst);
    final late = ledger.isLate(inst);
    final reminded = ref.watch(remindedProvider).contains(inst.id);
    final days = ledger.daysUntil(inst.due);
    final color = inst.isPaid ? p.paid : (late ? p.late : p.soon);

    return Panel(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              if (showTenant) ...[
                Avatar(tenant: tenant, size: 40),
                const SizedBox(width: Insets.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showTenant
                          ? tenant.name.of(ar)
                          : Fmt.date(context, inst.due),
                      style: context.text.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      [
                        if (showTenant)
                          '${unit.number} · ${ledger.property(unit.propertyId).name.of(ar)}',
                        if (inst.isPaid)
                          '${methodLabel(l, inst.method!)} · ${Fmt.shortDate(context, inst.paidAt!)}'
                        else if (late)
                          l.daysLate(-days)
                        else
                          l.inDays(days),
                      ].join(' · '),
                      style: context.text.bodySmall?.copyWith(
                        color: late && !inst.isPaid ? p.late : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Insets.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Fmt.sar(context, inst.amount),
                    style: context.text.titleSmall,
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: 30,
                    height: 3,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (!inst.isPaid) ...[
            const SizedBox(height: Insets.md),
            Row(
              children: [
                Expanded(
                  child: _SmallAction(
                    icon: reminded
                        ? Icons.done_all_rounded
                        : Icons.chat_rounded,
                    label: reminded ? l.reminderSent : l.sendReminder,
                    color: reminded ? p.paid : p.cobalt,
                    onTap: reminded
                        ? null
                        : () => _remind(context, ref, tenant, unit),
                  ),
                ),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: _SmallAction(
                    icon: Icons.payments_rounded,
                    label: l.recordCash,
                    color: p.ink,
                    onTap: () {
                      ref
                          .read(portfolioProvider.notifier)
                          .markCashPaid(inst.id);
                      showToast(context, l.paymentRecorded);
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _remind(BuildContext context, WidgetRef ref, Tenant tenant, Unit unit) {
    final l = context.l10n;
    final ar = context.arabic;
    final ledger = ref.read(ledgerProvider);
    final late = ledger.isLate(inst);
    final msg = late
        ? l.reminderLateMsg(
            tenant.name.of(ar).split(' ').first,
            unit.number,
            Fmt.sar(context, inst.amount),
            Fmt.date(context, inst.due),
          )
        : l.reminderSoonMsg(
            tenant.name.of(ar).split(' ').first,
            unit.number,
            Fmt.sar(context, inst.amount),
            Fmt.date(context, inst.due),
          );
    showModalBottomSheet<void>(
      context: context,
      builder: (sheet) {
        final p = sheet.palette;
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            Insets.xl,
            0,
            Insets.xl,
            Insets.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.sendReminder, style: sheet.text.headlineSmall),
              Text(
                l.viaWhatsApp(Fmt.phone(tenant.phone)),
                style: sheet.text.bodySmall,
              ),
              const SizedBox(height: Insets.lg),
              Container(
                padding: const EdgeInsets.all(Insets.lg),
                decoration: BoxDecoration(
                  color: sheet.isDark
                      ? const Color(0xFF0B1A16)
                      : const Color(0xFFE7F3EC),
                  borderRadius: BorderRadius.circular(Radii.card),
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                    decoration: BoxDecoration(
                      color: sheet.isDark
                          ? const Color(0xFF15463A)
                          : const Color(0xFFD5F5C9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(msg, style: sheet.text.bodyMedium),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Fmt.time(sheet, ledger.today),
                              style: sheet.text.labelSmall,
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.done_all_rounded,
                              size: 14,
                              color: p.cobalt,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Insets.lg),
              PrimaryButton(
                label: l.send,
                icon: Icons.send_rounded,
                tone: const Color(0xFF1FA855),
                onPressed: () {
                  ref.read(remindedProvider.notifier).add(inst.id);
                  Navigator.pop(sheet);
                  showToast(context, l.reminderSentTo(tenant.name.of(ar)));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: p.raised,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
