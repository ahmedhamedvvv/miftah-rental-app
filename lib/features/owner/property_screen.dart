import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/facade.dart';
import '../../core/widgets/photo.dart';
import '../../data/models.dart';
import '../../state/providers.dart';
import 'unit_sheet.dart';

class PropertyScreen extends ConsumerStatefulWidget {
  const PropertyScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends ConsumerState<PropertyScreen> {
  UnitStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final prop = ledger.property(widget.propertyId);
    final units = ledger.unitsOf(prop.id);
    final counts = ledger.statusCounts(prop.id);
    final shown = _filter == null
        ? units
        : units.where((u) => ledger.statusOf(u.id) == _filter).toList();
    final income = ledger
        .monthlyIncome(propertyId: prop.id)
        .fold(0, (a, m) => a + m.amount);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            leading: const Padding(
              padding: EdgeInsets.all(6),
              child: RoundBack(),
            ),
            leadingWidth: 60,
            title: Text(prop.name.of(ar)),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Hero(
                tag: 'property-${prop.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Photo(prop.photo, scrim: true),
                    PositionedDirectional(
                      start: Insets.page,
                      end: Insets.page,
                      bottom: Insets.lg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prop.name.of(ar),
                            style: context.text.displaySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${prop.district.of(ar)} · ${prop.city.of(ar)} · ${l.builtIn('${prop.builtYear}')}',
                            style: context.text.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Insets.page,
              Insets.lg,
              Insets.page,
              Insets.xxl,
            ),
            sliver: SliverList.list(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Box(
                        l.occupancy,
                        '${(ledger.occupancy(prop.id) * 100).round()}%',
                        p.paid,
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: _Box(
                        l.yearIncome,
                        Fmt.compact(context, income),
                        p.glow,
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: _Box(
                        l.statusLate,
                        '${counts[UnitStatus.late]}',
                        p.late,
                      ),
                    ),
                  ],
                ).entrance(0),
                const SizedBox(height: Insets.xl),
                SectionTitle(l.liveFacade),
                FacadeView(
                  cells: facadeCells(ledger, prop.id),
                  columns: prop.unitsPerFloor,
                  kind: prop.kind,
                  onTap: (c) => showUnitSheet(context, c.unitId),
                ).entrance(1),
                const SizedBox(height: Insets.xl),
                SectionTitle(l.units),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final f in <UnitStatus?>[
                        null,
                        ...UnitStatus.values,
                      ]) ...[
                        Pressable(
                          onTap: () => setState(() => _filter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _filter == f ? p.ink : p.surface,
                              borderRadius: BorderRadius.circular(Radii.pill),
                              border: Border.all(
                                color: _filter == f ? p.ink : p.line,
                              ),
                            ),
                            child: Text(
                              f == null
                                  ? '${l.all} ${units.length}'
                                  : '${_statusName(f)} ${counts[f]}',
                              style: context.text.labelMedium?.copyWith(
                                color: _filter == f ? p.bg : p.ink,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Insets.sm),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: Insets.md),
                for (final (i, u) in shown.indexed)
                  Padding(
                    key: ValueKey('${_filter}_${u.id}'),
                    padding: const EdgeInsets.only(bottom: Insets.sm),
                    child: _UnitRow(unit: u).entrance(i.clamp(0, 10)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusName(UnitStatus s) {
    final l = context.l10n;
    return switch (s) {
      UnitStatus.paid => l.statusPaid,
      UnitStatus.dueSoon => l.statusDueSoon,
      UnitStatus.late => l.statusLate,
      UnitStatus.vacant => l.statusVacant,
    };
  }
}

class _Box extends StatelessWidget {
  const _Box(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              maxLines: 1,
              style: context.text.headlineSmall?.copyWith(color: color),
            ),
          ),
          Text(
            label,
            style: context.text.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _UnitRow extends ConsumerWidget {
  const _UnitRow({required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final c = ledger.activeContract(unit.id);
    final tenant = c == null ? null : ledger.tenant(c.tenantId);
    return Panel(
      onTap: () => context.push(Routes.unit(unit.id)),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Photo(unit.photos.first, radius: 14),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${unitKindLabel(l, unit.kind)} ${unit.number}',
                  style: context.text.titleSmall,
                ),
                Text(
                  tenant?.name.of(ar) ??
                      '${l.areaSqm(unit.area)} · ${Fmt.sar(context, unit.annualRent)}',
                  style: context.text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          StatusPill(ledger.statusOf(unit.id)),
        ],
      ),
    );
  }
}
