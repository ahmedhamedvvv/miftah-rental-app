import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/key_card.dart';
import '../../core/widgets/photo.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

class TenantHomeScreen extends ConsumerWidget {
  const TenantHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final lease = ref.watch(myLeaseProvider);
    final ledger = ref.watch(ledgerProvider);
    final ar = context.arabic;
    final unread = ledger.data.notices.where((n) => !n.read).length;
    final next = lease.next;
    final late = next != null && ledger.isLate(next);
    final tickets = ledger.ticketsOfUnit(lease.unit.id);
    final active = tickets.where((t) => t.status != TicketStatus.done).toList();
    final paidCount = lease.installments.where((i) => i.isPaid).length;
    final hour = ref.watch(clockProvider)().hour;
    final firstName = lease.tenant.name.of(ar).split(' ').first;

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hour < 12
                            ? l.goodMorning(firstName)
                            : l.goodEvening(firstName),
                        style: context.text.headlineMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${unitKindLabel(l, lease.unit.kind)} ${lease.unit.number} · ${lease.property.name.of(ar)}',
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                ),
                RoundIconButton(
                  icon: Icons.notifications_none_rounded,
                  badge: unread > 0,
                  tooltip: l.notifications,
                  onTap: () => context.push(Routes.notifications),
                ),
              ],
            ).entrance(0),
            const SizedBox(height: Insets.xl),
            KeyCard(
                  front: _CardFront(
                    lease: lease,
                    late: late,
                    daysLeft: next == null ? 0 : ledger.daysUntil(next.due),
                  ),
                  back: _CardBack(lease: lease),
                )
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.08, curve: Curves.easeOutCubic),
            const SizedBox(height: Insets.sm),
            Center(child: Text(l.tapCardHint, style: context.text.labelSmall))
                .entrance(1, baseMs: 300),
            const SizedBox(height: Insets.lg),
            if (next != null)
              PrimaryButton(
                label: late ? l.payNowLate : l.payRent,
                icon: Icons.lock_open_rounded,
                tone: late ? p.late : null,
                onPressed: () => context.push(Routes.pay(next.id)),
              ).entrance(2, baseMs: 300),
            const SizedBox(height: Insets.lg),
            Row(
              children: [
                Expanded(
                  child: _MiniTile(
                    icon: Icons.build_rounded,
                    color: active.isEmpty ? p.paid : p.soon,
                    title: active.isEmpty
                        ? l.noOpenRequests
                        : ticketCategoryLabel(l, active.first.category),
                    subtitle: active.isEmpty
                        ? l.allGood
                        : ticketStatusLabel(l, active.first.status),
                    onTap: () => active.isEmpty
                        ? context.push(Routes.newRequest)
                        : context.push(Routes.tenantTicket(active.first.id)),
                  ),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: _MiniTile(
                    icon: Icons.verified_rounded,
                    color: p.cobalt,
                    title: l.paidOfTotal(paidCount, lease.installments.length),
                    subtitle: l.installmentsThisLease,
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(1),
                  ),
                ),
              ],
            ).entrance(3, baseMs: 300),
            const SizedBox(height: Insets.xl),
            SectionTitle(l.myHome),
            _UnitGallery(unit: lease.unit).entrance(4, baseMs: 300),
            const SizedBox(height: Insets.md),
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                if (lease.unit.bedrooms > 0)
                  _Spec(Icons.bed_rounded, l.bedrooms(lease.unit.bedrooms)),
                _Spec(Icons.square_foot_rounded, l.areaSqm(lease.unit.area)),
                _Spec(Icons.stairs_rounded, l.floorN(lease.unit.floor)),
                _Spec(
                  Icons.location_on_rounded,
                  lease.property.district.of(ar),
                ),
              ],
            ).entrance(5, baseMs: 300),
            const SizedBox(height: Insets.xl),
            SectionTitle(l.quickActions),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: Insets.md,
              crossAxisSpacing: Insets.md,
              childAspectRatio: 1.9,
              children:
                  [
                        _Action(
                          Icons.add_circle_rounded,
                          l.newRequest,
                          () => context.push(Routes.newRequest),
                        ),
                        _Action(
                          Icons.receipt_long_rounded,
                          l.navPayments,
                          () => StatefulNavigationShell.of(context).goBranch(1),
                        ),
                        _Action(
                          Icons.description_rounded,
                          l.myLease,
                          () => StatefulNavigationShell.of(context).goBranch(3),
                        ),
                        _Action(
                          Icons.support_agent_rounded,
                          l.contactOwner,
                          () => _contactSheet(context),
                        ),
                      ].indexed
                      .map((e) => e.$2.entrance(6 + e.$1, baseMs: 300))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _contactSheet(BuildContext context) {
    final l = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.contactOwner, style: context.text.headlineSmall),
            const SizedBox(height: Insets.sm),
            Text(l.contactOwnerBody, style: context.text.bodyMedium),
            const SizedBox(height: Insets.lg),
            LabelValue(l.officeName, l.officeNameValue),
            LabelValue(l.phone, Fmt.phone('+966112345678'), mono: true),
            LabelValue(l.workingHours, l.workingHoursValue),
            const SizedBox(height: Insets.lg),
            PrimaryButton(
              label: l.done,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({
    required this.lease,
    required this.late,
    required this.daysLeft,
  });

  final MyLease lease;
  final bool late;
  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final next = lease.next;
    final period = lease.contract.frequency.monthsApart * 30;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const KeyMark(size: 30),
            const Spacer(),
            Text(
              'EJAR ${Fmt.ejar(lease.contract.ejarNumber)}',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: AppTheme.mono,
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          next == null
              ? l.allPaid
              : '${l.nextInstallment} · ${frequencyLabel(l, lease.contract.frequency)}',
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: CountUp(
                  value: next?.amount ?? 0,
                  format: (v) => Fmt.sar(context, v.round()),
                  style: const TextStyle(
                    fontFamily: AppTheme.display,
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    height: 1.1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (next != null)
              RentRing(
                progress: late ? 1 : 1 - daysLeft / period,
                center: late ? '!' : '$daysLeft',
                caption: late ? l.lateShort : l.daysShort,
                size: 62,
                color: late ? context.palette.late : context.palette.glow,
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          next == null
              ? l.leaseEnds(Fmt.date(context, lease.contract.end))
              : late
              ? l.wasDue(Fmt.date(context, next.due))
              : l.dueOn(Fmt.date(context, next.due)),
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({required this.lease});

  final MyLease lease;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ar = context.arabic;
    TextStyle k = TextStyle(
      fontSize: 11.5,
      color: Colors.white.withValues(alpha: 0.65),
    );
    const v = TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    Widget row(String a, String b) => Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Expanded(child: Text(a, style: k)),
          Text(b, style: v),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.leaseDetails,
          style: const TextStyle(
            fontFamily: AppTheme.display,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        row(l.unit, '${lease.unit.number} · ${lease.property.name.of(ar)}'),
        row(
          l.leasePeriod,
          '${Fmt.shortDate(context, lease.contract.start)} – ${Fmt.shortDate(context, lease.contract.end)}',
        ),
        row(l.annualRent, Fmt.sar(context, lease.contract.annualRent)),
        row(l.paymentPlan, frequencyLabel(l, lease.contract.frequency)),
      ],
    );
  }
}

class _MiniTile extends StatelessWidget {
  const _MiniTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          IconTile(icon: icon, color: color, size: 38),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall,
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitGallery extends StatefulWidget {
  const _UnitGallery({required this.unit});

  final Unit unit;

  @override
  State<_UnitGallery> createState() => _UnitGalleryState();
}

class _UnitGalleryState extends State<_UnitGallery> {
  final _page = PageController(viewportFraction: 0.88);
  double _pos = 0;

  @override
  void initState() {
    super.initState();
    _page.addListener(() => setState(() => _pos = _page.page ?? 0));
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.unit.photos;
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _page,
            padEnds: false,
            itemCount: photos.length,
            itemBuilder: (context, i) {
              final d = (i - _pos).abs().clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: Insets.md),
                child: Transform.scale(
                  scale: 1 - d * 0.05,
                  child: Photo(photos[i], radius: Radii.card),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: Insets.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < photos.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: (_pos.round() == i) ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _pos.round() == i
                      ? context.palette.cobalt
                      : context.palette.line,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: p.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: p.muted),
          const SizedBox(width: 6),
          Text(label, style: context.text.labelMedium),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action(this.icon, this.label, this.onTap);

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: context.palette.cobalt),
          Text(label, style: context.text.titleSmall),
        ],
      ),
    );
  }
}
