import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/photo.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

class PropertiesScreen extends ConsumerWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);

    return PageScaffold(
      title: l.navProperties,
      subtitle: l.propertiesSubtitle(
        ledger.data.properties.length,
        ledger.data.units.length,
      ),
      actions: [
        RoundIconButton(
          icon: Icons.add_rounded,
          tooltip: l.newLease,
          onTap: () => context.push(Routes.lease()),
        ),
      ],
      children: [
        for (final (i, prop) in ledger.data.properties.indexed) ...[
          Pressable(
            onTap: () => context.push(Routes.property(prop.id)),
            child: Container(
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(Radii.card),
                border: Border.all(color: p.line),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 190,
                    child: Hero(
                      tag: 'property-${prop.id}',
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Photo(prop.photo, scrim: true),
                          PositionedDirectional(
                            start: Insets.lg,
                            bottom: Insets.lg,
                            end: Insets.lg,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prop.name.of(ar),
                                  style: context.text.headlineSmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${prop.district.of(ar)} · ${prop.city.of(ar)}',
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
                  Padding(
                    padding: const EdgeInsets.all(Insets.lg),
                    child: Row(
                      children: [
                        _Stat(l.units, '${ledger.unitsOf(prop.id).length}'),
                        _Stat(
                          l.occupancy,
                          '${(ledger.occupancy(prop.id) * 100).round()}%',
                        ),
                        _Stat(
                          l.yearIncome,
                          Fmt.compact(
                            context,
                            ledger
                                .monthlyIncome(propertyId: prop.id)
                                .fold(0, (a, m) => a + m.amount),
                          ),
                        ),
                        _StatusDots(counts: ledger.statusCounts(prop.id)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).entrance(i),
          const SizedBox(height: Insets.lg),
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: context.text.titleLarge),
          Text(label, style: context.text.labelSmall),
        ],
      ),
    );
  }
}

class _StatusDots extends StatelessWidget {
  const _StatusDots({required this.counts});

  final Map<UnitStatus, int> counts;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final s in [UnitStatus.late, UnitStatus.dueSoon])
          if (counts[s]! > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: p.status(s),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${counts[s]}',
                    style: context.text.labelSmall?.copyWith(
                      color: p.status(s),
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
