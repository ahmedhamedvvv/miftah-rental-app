import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/facade.dart';
import '../../core/widgets/key_card.dart';
import '../../data/models.dart';
import '../../state/providers.dart';
import 'unit_sheet.dart';

class OwnerHomeScreen extends ConsumerStatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  ConsumerState<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends ConsumerState<OwnerHomeScreen> {
  int _property = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final today = ledger.today;
    final props = ledger.data.properties;
    final prop = props[_property];
    final collected = ledger.sum(ledger.paidIn(today.year, today.month));
    final overdue = ledger.overdue();
    final occupancy = ledger.occupancy();
    final openTickets = ledger.openTickets();
    final counts = ledger.statusCounts(prop.id);
    final urgent = openTickets
        .where((t) => t.urgent || t.status == TicketStatus.open)
        .toList();
    final expiring = ledger.expiringSoon();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Insets.page,
            Insets.md,
            Insets.page,
            120,
          ),
          children: [
            Row(
              children: [
                const AppMark(size: 42),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.officeNameValue, style: context.text.titleMedium),
                      Text(
                        Fmt.month(context, today),
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                ),
                RoundIconButton(
                  icon: Icons.groups_rounded,
                  tooltip: l.tenants,
                  onTap: () => context.push(Routes.tenants),
                ),
                const SizedBox(width: Insets.sm),
                RoundIconButton(
                  icon: Icons.tune_rounded,
                  tooltip: l.settings,
                  onTap: () => context.push(Routes.settings),
                ),
              ],
            ).entrance(0),
            const SizedBox(height: Insets.xl),
            // Bento of the four numbers an owner checks every morning.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: _Kpi(
                    label: l.collectedThisMonth,
                    value: collected,
                    format: (v) => Fmt.compact(context, v),
                    unit: ar ? 'ر.س' : 'SAR',
                    color: p.glow,
                    big: true,
                    footer: l.paymentsCount(
                      ledger.paidIn(today.year, today.month).length,
                    ),
                  ),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _Kpi(
                        label: l.overdue,
                        value: ledger.sum(overdue),
                        format: (v) => Fmt.compact(context, v),
                        unit: ar ? 'ر.س' : 'SAR',
                        color: p.late,
                        onTap: () =>
                            StatefulNavigationShell.of(context).goBranch(2),
                      ),
                      const SizedBox(height: Insets.md),
                      _Kpi(
                        label: l.openTickets,
                        value: openTickets.length,
                        format: (v) => '${v.round()}',
                        color: p.cobalt,
                        onTap: () =>
                            StatefulNavigationShell.of(context).goBranch(3),
                      ),
                    ],
                  ),
                ),
              ],
            ).entrance(1),
            const SizedBox(height: Insets.md),
            Panel(
              child: Row(
                children: [
                  RentRing(
                    progress: occupancy,
                    center: '${(occupancy * 100).round()}%',
                    size: 66,
                    color: p.paid,
                    track: p.raised,
                  ),
                  const SizedBox(width: Insets.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.occupancy, style: context.text.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          l.occupancyBody(
                            ledger.data.units.length -
                                ledger.vacantUnits().length,
                            ledger.data.units.length,
                          ),
                          style: context.text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).entrance(2),
            const SizedBox(height: Insets.xl),
            SectionTitle(
              l.liveFacade,
              action: l.viewProperty,
              onAction: () => context.push(Routes.property(prop.id)),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: props.length,
                separatorBuilder: (_, _) => const SizedBox(width: Insets.sm),
                itemBuilder: (context, i) {
                  final sel = i == _property;
                  return Pressable(
                    onTap: () => setState(() => _property = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? p.ink : p.surface,
                        borderRadius: BorderRadius.circular(Radii.pill),
                        border: Border.all(color: sel ? p.ink : p.line),
                      ),
                      child: Text(
                        props[i].name.of(ar),
                        style: context.text.labelMedium?.copyWith(
                          color: sel ? p.bg : p.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).entrance(3),
            const SizedBox(height: Insets.md),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 380),
              switchInCurve: Curves.easeOutCubic,
              transitionBuilder: (child, a) => FadeTransition(
                opacity: a,
                child: ScaleTransition(
                  scale: Tween(begin: 0.97, end: 1.0).animate(a),
                  child: child,
                ),
              ),
              child: FacadeView(
                key: ValueKey(prop.id),
                cells: facadeCells(ledger, prop.id),
                columns: prop.unitsPerFloor,
                kind: prop.kind,
                onTap: (c) => showUnitSheet(context, c.unitId),
              ),
            ).entrance(4),
            const SizedBox(height: Insets.md),
            Row(
              children: [
                Expanded(
                  child: FacadeLegend(
                    labels: (
                      paid: '${l.statusPaid} ${counts[UnitStatus.paid]}',
                      soon: '${l.statusDueSoon} ${counts[UnitStatus.dueSoon]}',
                      late: '${l.statusLate} ${counts[UnitStatus.late]}',
                      vacant: '${l.statusVacant} ${counts[UnitStatus.vacant]}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.xl),
            SectionTitle(l.needsAttention),
            for (final (i, inst) in overdue.take(3).indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: _AttentionRow(
                  icon: Icons.warning_amber_rounded,
                  color: p.late,
                  title: l.lateRent(
                    ledger.tenantOfInstallment(inst).name.of(ar),
                  ),
                  subtitle:
                      '${ledger.unitOfInstallment(inst).number} · ${l.daysLate(-ledger.daysUntil(inst.due))}',
                  trailing: Fmt.sar(context, inst.amount),
                  onTap: () => context.push(
                    Routes.unit(ledger.unitOfInstallment(inst).id),
                  ),
                ).entrance(5 + i),
              ),
            for (final (i, t) in urgent.take(2).indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: _AttentionRow(
                  icon: ticketCategoryIcon(t.category),
                  color: p.cobalt,
                  title: l.newTicket(ticketCategoryLabel(l, t.category)),
                  subtitle:
                      '${ledger.unit(t.unitId).number} · ${ledger.property(ledger.unit(t.unitId).propertyId).name.of(ar)}',
                  trailing: t.urgent
                      ? l.urgent
                      : ticketStatusLabel(l, t.status),
                  onTap: () => context.push(Routes.ownerTicket(t.id)),
                ).entrance(8 + i),
              ),
            for (final (i, c) in expiring.take(2).indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: _AttentionRow(
                  icon: Icons.event_busy_rounded,
                  color: p.soon,
                  title: l.leaseEnding(ledger.tenant(c.tenantId).name.of(ar)),
                  subtitle:
                      '${ledger.unit(c.unitId).number} · ${Fmt.date(context, c.end)}',
                  trailing: l.inDays(ledger.daysUntil(c.end)),
                  onTap: () => context.push(Routes.unit(c.unitId)),
                ).entrance(10 + i),
              ),
          ],
        ),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.label,
    required this.value,
    required this.format,
    required this.color,
    this.unit,
    this.big = false,
    this.footer,
    this.onTap,
  });

  final String label;
  final num value;
  final String Function(num) format;
  final Color color;
  final String? unit;
  final bool big;
  final String? footer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Panel(
      onTap: onTap,
      padding: EdgeInsets.all(big ? 18 : 14),
      child: SizedBox(
        height: big ? 160 : 66,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: big
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: context.text.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (big) const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CountUp(
                      value: value,
                      format: format,
                      style:
                          (big
                                  ? context.text.displayMedium
                                  : context.text.headlineMedium)
                              ?.copyWith(height: 1.1),
                    ),
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Text(unit!, style: context.text.labelSmall),
                ],
              ],
            ),
            if (big && footer != null) ...[
              const SizedBox(height: 6),
              Text(
                footer!,
                style: context.text.bodySmall?.copyWith(color: p.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AttentionRow extends StatelessWidget {
  const _AttentionRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IconTile(icon: icon, color: color, size: 40),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.text.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: context.text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          Text(
            trailing,
            style: context.text.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
