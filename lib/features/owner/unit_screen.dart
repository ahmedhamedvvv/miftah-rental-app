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
import '../tenant/maintenance_screen.dart';
import 'collections_screen.dart';

class UnitScreen extends ConsumerStatefulWidget {
  const UnitScreen({super.key, required this.unitId});

  final String unitId;

  @override
  ConsumerState<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends ConsumerState<UnitScreen> {
  int _photo = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final unit = ledger.unit(widget.unitId);
    final prop = ledger.property(unit.propertyId);
    final status = ledger.statusOf(unit.id);
    final c = ledger.activeContract(unit.id);
    final tenant = c == null ? null : ledger.tenant(c.tenantId);
    final installments = c == null
        ? <Installment>[]
        : ledger.installmentsOf(c.id);
    final tickets = ledger.ticketsOfUnit(unit.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            leading: const Padding(
              padding: EdgeInsets.all(6),
              child: RoundBack(),
            ),
            leadingWidth: 60,
            title: Text('${unitKindLabel(l, unit.kind)} ${unit.number}'),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView(
                    onPageChanged: (i) => setState(() => _photo = i),
                    children: [for (final ph in unit.photos) Photo(ph)],
                  ),
                  const IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x66000000),
                            Color(0x00000000),
                            Color(0x99000000),
                          ],
                          stops: [0, 0.4, 1],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: Insets.md,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < unit.photos.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _photo ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: i == _photo ? 1 : 0.5,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${unitKindLabel(l, unit.kind)} ${unit.number}',
                            style: context.text.headlineMedium,
                          ),
                          Text(
                            '${prop.name.of(ar)} · ${l.floorN(unit.floor)}',
                            style: context.text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    StatusPill(status),
                  ],
                ).entrance(0),
                const SizedBox(height: Insets.lg),
                Panel(
                  child: Column(
                    children: [
                      if (unit.bedrooms > 0)
                        LabelValue(l.rooms, l.bedrooms(unit.bedrooms)),
                      LabelValue(l.area, l.areaSqm(unit.area)),
                      LabelValue(
                        l.annualRent,
                        Fmt.sar(context, c?.annualRent ?? unit.annualRent),
                      ),
                      LabelValue(
                        l.leaseType,
                        unit.isCommercial ? l.commercialVat : l.residential,
                      ),
                    ],
                  ),
                ).entrance(1),
                const SizedBox(height: Insets.xl),
                if (tenant == null || c == null) ...[
                  Panel(
                    color: p.cobaltSoft,
                    borderColor: p.cobalt.withValues(alpha: 0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.unitVacantTitle,
                          style: context.text.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(l.unitVacantBody, style: context.text.bodySmall),
                        const SizedBox(height: Insets.md),
                        PrimaryButton(
                          label: l.leaseIt,
                          icon: Icons.key_rounded,
                          onPressed: () => context.push(Routes.lease(unit.id)),
                        ),
                      ],
                    ),
                  ).entrance(2),
                ] else ...[
                  SectionTitle(l.tenant),
                  Panel(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Avatar(tenant: tenant),
                            const SizedBox(width: Insets.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tenant.name.of(ar),
                                    style: context.text.titleMedium,
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
                        const SizedBox(height: Insets.md),
                        const Divider(),
                        LabelValue(
                          l.ejarContract,
                          Fmt.ejar(c.ejarNumber),
                          mono: true,
                        ),
                        LabelValue(
                          l.leasePeriod,
                          '${Fmt.shortDate(context, c.start)} – ${Fmt.date(context, c.end)}',
                        ),
                        LabelValue(
                          l.paymentPlan,
                          '${frequencyLabel(l, c.frequency)} · ${Fmt.sar(context, c.installmentAmount)}',
                        ),
                        if (c.renewalRequested)
                          LabelValue(
                            l.renewal,
                            l.renewalRequested,
                            valueColor: p.cobalt,
                          ),
                      ],
                    ),
                  ).entrance(2),
                  const SizedBox(height: Insets.xl),
                  SectionTitle(l.schedule),
                  for (final (i, inst) in installments.indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Insets.sm),
                      child: CollectionRow(
                        inst: inst,
                        showTenant: false,
                      ).entrance(3 + i),
                    ),
                ],
                if (tickets.isNotEmpty) ...[
                  const SizedBox(height: Insets.xl),
                  SectionTitle(l.maintenanceHistory),
                  for (final t in tickets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Insets.sm),
                      child: TicketCard(
                        ticket: t,
                        onTap: () => context.push(Routes.ownerTicket(t.id)),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
