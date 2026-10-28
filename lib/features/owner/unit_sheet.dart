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
import '../../domain/ledger.dart';
import '../../state/providers.dart';

/// Facade cells for one property.
List<FacadeCell> facadeCells(Ledger ledger, String propertyId) => [
  for (final u in ledger.unitsOf(propertyId))
    FacadeCell(
      unitId: u.id,
      label: u.number,
      floor: u.floor,
      status: ledger.statusOf(u.id),
    ),
];

/// Quick look at a unit after tapping its window.
void showUnitSheet(BuildContext context, String unitId) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _UnitSheet(unitId: unitId),
  );
}

class _UnitSheet extends ConsumerWidget {
  const _UnitSheet({required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final unit = ledger.unit(unitId);
    final property = ledger.property(unit.propertyId);
    final status = ledger.statusOf(unitId);
    final contract = ledger.activeContract(unitId);
    final tenant = contract == null ? null : ledger.tenant(contract.tenantId);
    final next = contract == null ? null : ledger.nextDue(contract.id);

    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Photo(unit.photos.first, radius: 16),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${unitKindLabel(l, unit.kind)} ${unit.number}',
                      style: context.text.headlineSmall,
                    ),
                    Text(property.name.of(ar), style: context.text.bodySmall),
                  ],
                ),
              ),
              StatusPill(status),
            ],
          ),
          const SizedBox(height: Insets.lg),
          if (tenant != null && contract != null) ...[
            Panel(
              color: p.raised,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Avatar(tenant: tenant, size: 40),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant.name.of(ar),
                          style: context.text.titleSmall,
                        ),
                        Text(
                          Fmt.phone(tenant.phone),
                          textDirection: TextDirection.ltr,
                          style: context.text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Insets.sm),
            if (next != null)
              LabelValue(
                ledger.isLate(next) ? l.overdueSince : l.nextInstallment,
                '${Fmt.sar(context, next.amount)} · ${Fmt.shortDate(context, next.due)}',
                valueColor: ledger.isLate(next) ? p.late : null,
              ),
            LabelValue(l.paymentPlan, frequencyLabel(l, contract.frequency)),
          ] else
            Text(
              l.vacantSince,
              style: context.text.bodyMedium?.copyWith(color: p.muted),
            ),
          const SizedBox(height: Insets.lg),
          Row(
            children: [
              Expanded(
                child: GhostButton(
                  label: l.openUnit,
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(Routes.unit(unitId));
                  },
                ),
              ),
              if (status == UnitStatus.vacant) ...[
                const SizedBox(width: Insets.md),
                Expanded(
                  child: PrimaryButton(
                    label: l.leaseIt,
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(Routes.lease(unitId));
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
