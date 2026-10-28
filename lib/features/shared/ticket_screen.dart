import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/photo.dart';
import '../../data/models.dart';
import '../../data/seed.dart';
import '../../state/providers.dart';

/// One maintenance request. Tenants follow it and rate it; owners assign a
/// technician and move it along.
class TicketScreen extends ConsumerWidget {
  const TicketScreen({
    super.key,
    required this.ticketId,
    this.ownerView = false,
  });

  final String ticketId;
  final bool ownerView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final t = ledger.data.tickets.firstWhere((t) => t.id == ticketId);
    final unit = ledger.unit(t.unitId);
    final property = ledger.property(unit.propertyId);
    final contract = ledger.activeContract(unit.id);
    final tenant = contract == null ? null : ledger.tenant(contract.tenantId);
    final store = ref.read(portfolioProvider.notifier);
    final at = {for (final e in t.events) e.status: e.at};

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            leading: const Padding(
              padding: EdgeInsets.all(6),
              child: RoundBack(),
            ),
            leadingWidth: 60,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Photo(ticketCategoryPhoto(t.category), scrim: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Insets.page,
                      0,
                      Insets.page,
                      Insets.lg,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '#${t.number}',
                              style: const TextStyle(
                                fontFamily: AppTheme.mono,
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            if (t.urgent) ...[
                              const SizedBox(width: 8),
                              Pill(l.urgent, color: p.late, solid: true),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticketCategoryLabel(l, t.category),
                          style: context.text.displaySmall?.copyWith(
                            color: Colors.white,
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
                Panel(
                  child: Column(
                    children: [
                      for (final s in TicketStatus.values)
                        _Step(
                          label: ticketStatusLabel(l, s),
                          at: at[s],
                          done: s.index <= t.status.index,
                          current: s == t.status,
                          last: s == TicketStatus.done,
                          index: s.index,
                        ),
                    ],
                  ),
                ).entrance(0),
                const SizedBox(height: Insets.lg),
                if (t.technician != null)
                  Panel(
                    child: Row(
                      children: [
                        IconTile(
                          icon: Icons.engineering_rounded,
                          color: p.glow,
                        ),
                        const SizedBox(width: Insets.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.technician, style: context.text.bodySmall),
                              Text(
                                technicians[t.technician]!.of(ar),
                                style: context.text.titleSmall,
                              ),
                            ],
                          ),
                        ),
                        if (ownerView && t.status != TicketStatus.done)
                          GhostButton(
                            label: l.change,
                            onPressed: () => _assignSheet(context, ref, t),
                          ),
                      ],
                    ),
                  ).entrance(1),
                if (t.technician != null) const SizedBox(height: Insets.lg),
                Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.details, style: context.text.bodySmall),
                      const SizedBox(height: 4),
                      Text(t.description.of(ar), style: context.text.bodyLarge),
                      const SizedBox(height: Insets.md),
                      const Divider(),
                      LabelValue(
                        l.unit,
                        '${unitKindLabel(l, unit.kind)} ${unit.number} · ${property.name.of(ar)}',
                      ),
                      if (ownerView && tenant != null)
                        LabelValue(l.tenant, tenant.name.of(ar)),
                      LabelValue(
                        l.preferredTime,
                        slotLabel(l, t.preferredSlot),
                      ),
                      if (t.cost != null)
                        LabelValue(l.cost, Fmt.sar(context, t.cost!)),
                    ],
                  ),
                ).entrance(2),
                const SizedBox(height: Insets.xl),
                if (!ownerView && t.status == TicketStatus.done)
                  _Rating(
                    value: t.rating,
                    onRate: (r) {
                      store.rateTicket(t.id, r);
                      showToast(context, l.thanksRating);
                    },
                  ).entrance(3),
                if (ownerView && t.status != TicketStatus.done) ...[
                  if (t.status == TicketStatus.open)
                    PrimaryButton(
                      label: l.assignTechnician,
                      icon: Icons.engineering_rounded,
                      onPressed: () => _assignSheet(context, ref, t),
                    )
                  else if (t.status == TicketStatus.assigned)
                    PrimaryButton(
                      label: l.startWork,
                      icon: Icons.play_arrow_rounded,
                      onPressed: () =>
                          store.moveTicket(t.id, TicketStatus.inProgress),
                    )
                  else
                    PrimaryButton(
                      label: l.markDone,
                      icon: Icons.check_rounded,
                      tone: p.paid,
                      onPressed: () => _doneSheet(context, ref, t),
                    ),
                ],
                if (ownerView &&
                    t.status == TicketStatus.done &&
                    t.rating != null)
                  Panel(
                    child: Row(
                      children: [
                        Text(l.tenantRating, style: context.text.titleSmall),
                        const Spacer(),
                        for (var i = 0; i < 5; i++)
                          Icon(
                            i < t.rating!
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: p.glow,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _assignSheet(BuildContext context, WidgetRef ref, Ticket t) {
    final l = context.l10n;
    final ar = context.arabic;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheet) => Padding(
        padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.assignTechnician, style: sheet.text.headlineSmall),
            const SizedBox(height: Insets.lg),
            for (final e in technicians.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: Panel(
                  onTap: () {
                    ref.read(portfolioProvider.notifier).assign(t.id, e.key);
                    Navigator.pop(sheet);
                    showToast(context, l.assigned);
                  },
                  borderColor: t.technician == e.key
                      ? sheet.palette.cobalt
                      : null,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const IconTile(icon: Icons.engineering_rounded, size: 38),
                      const SizedBox(width: Insets.md),
                      Expanded(
                        child: Text(
                          e.value.of(ar),
                          style: sheet.text.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _doneSheet(BuildContext context, WidgetRef ref, Ticket t) {
    final l = context.l10n;
    final cost = TextEditingController(text: '250');
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => Padding(
        padding: EdgeInsets.fromLTRB(
          Insets.xl,
          0,
          Insets.xl,
          Insets.xl + MediaQuery.viewInsetsOf(sheet).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.markDone, style: sheet.text.headlineSmall),
            const SizedBox(height: Insets.lg),
            TextField(
              controller: cost,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l.costSar),
            ),
            const SizedBox(height: Insets.lg),
            PrimaryButton(
              label: l.confirm,
              onPressed: () {
                ref
                    .read(portfolioProvider.notifier)
                    .moveTicket(
                      t.id,
                      TicketStatus.done,
                      cost: int.tryParse(cost.text.trim()),
                    );
                Navigator.pop(sheet);
                showToast(context, l.ticketClosed);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.label,
    required this.at,
    required this.done,
    required this.current,
    required this.last,
    required this.index,
  });

  final String label;
  final DateTime? at;
  final bool done;
  final bool current;
  final bool last;
  final int index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = done ? (last ? p.paid : p.cobalt) : p.line;
    Widget dot = Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? color : p.surface,
        border: Border.all(color: color, width: 2),
      ),
      child: done
          ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
          : null,
    );
    if (current && !last) {
      dot = dot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .boxShadow(
            begin: BoxShadow(color: color.withValues(alpha: 0), blurRadius: 0),
            end: BoxShadow(
              color: color.withValues(alpha: 0.6),
              blurRadius: 14,
              spreadRadius: 2,
            ),
            duration: 900.ms,
            borderRadius: BorderRadius.circular(11),
          );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              dot
                  .animate(delay: (index * 140).ms)
                  .scaleXY(
                    begin: 0.5,
                    curve: Curves.easeOutBack,
                    duration: 350.ms,
                  ),
              if (!last)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: done ? color : p.line,
                  ),
                ),
            ],
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : Insets.lg, top: 1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: context.text.titleSmall?.copyWith(
                        color: done ? p.ink : p.muted,
                      ),
                    ),
                  ),
                  if (at != null)
                    Text(
                      Fmt.dateTime(context, at!),
                      style: context.text.labelSmall,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.value, required this.onRate});

  final int? value;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    return Panel(
      child: Column(
        children: [
          Text(
            value == null ? l.rateService : l.yourRating,
            style: context.text.titleMedium,
          ),
          const SizedBox(height: Insets.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                Pressable(
                  onTap: () => onRate(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedScale(
                      scale: (value ?? 0) >= i ? 1.15 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        (value ?? 0) >= i
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 38,
                        color: p.glow,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
