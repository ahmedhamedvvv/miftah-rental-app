import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/photo.dart';
import '../../data/models.dart';
import '../../data/seed.dart';
import '../../state/providers.dart';

/// Kanban of maintenance requests. Long-press a card and drop it on another
/// column to move it.
class MaintenanceBoardScreen extends ConsumerWidget {
  const MaintenanceBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ledger = ref.watch(ledgerProvider);
    final tickets = [...ledger.data.tickets]
      ..sort((a, b) {
        if (a.urgent != b.urgent) return a.urgent ? -1 : 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
    final spend = tickets.fold(0, (a, t) => a + (t.cost ?? 0));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.page,
                Insets.md,
                Insets.page,
                Insets.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.navMaintenance, style: context.text.displaySmall),
                  const SizedBox(height: 6),
                  Text(
                    l.boardSubtitle(
                      ledger.openTickets().length,
                      Fmt.sar(context, spend),
                    ),
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(
                  Insets.page,
                  0,
                  Insets.page,
                  110,
                ),
                children: [
                  for (final (i, s) in TicketStatus.values.indexed) ...[
                    _Column(
                      status: s,
                      tickets: tickets.where((t) => t.status == s).toList(),
                    ).entrance(i, dy: 0.03),
                    const SizedBox(width: Insets.md),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Column extends ConsumerWidget {
  const _Column({required this.status, required this.tickets});

  final TicketStatus status;
  final List<Ticket> tickets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final color = switch (status) {
      TicketStatus.open => p.late,
      TicketStatus.assigned => p.soon,
      TicketStatus.inProgress => p.cobalt,
      TicketStatus.done => p.paid,
    };
    return DragTarget<Ticket>(
      onWillAcceptWithDetails: (d) => d.data.status != status,
      onAcceptWithDetails: (d) {
        HapticFeedback.mediumImpact();
        ref.read(portfolioProvider.notifier).moveTicket(d.data.id, status);
        showToast(context, l.movedTo(ticketStatusLabel(l, status)));
      },
      builder: (context, candidates, _) {
        final hover = candidates.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 268,
          padding: const EdgeInsets.all(Insets.md),
          decoration: BoxDecoration(
            color: hover
                ? color.withValues(alpha: 0.12)
                : p.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(Radii.card),
            border: Border.all(
              color: hover ? color : p.line,
              width: hover ? 1.6 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Insets.sm),
                  Expanded(
                    child: Text(
                      ticketStatusLabel(l, status),
                      style: context.text.titleSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: p.raised,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${tickets.length}',
                      style: context.text.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.md),
              Expanded(
                child: tickets.isEmpty
                    ? Center(
                        child: Text(l.dropHere, style: context.text.labelSmall),
                      )
                    : ListView.separated(
                        itemCount: tickets.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: Insets.sm),
                        itemBuilder: (context, i) {
                          final card = _BoardCard(ticket: tickets[i]);
                          return LongPressDraggable<Ticket>(
                            data: tickets[i],
                            hapticFeedbackOnStart: true,
                            feedback: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 244,
                                child: Transform.rotate(
                                  angle: -0.04,
                                  child: card,
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: card,
                            ),
                            child: Pressable(
                              onTap: () => context.push(
                                Routes.ownerTicket(tickets[i].id),
                              ),
                              child: card,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BoardCard extends ConsumerWidget {
  const _BoardCard({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final unit = ledger.unit(ticket.unitId);
    final prop = ledger.property(unit.propertyId);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ticket.urgent ? p.late.withValues(alpha: 0.6) : p.line,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 74,
            child: Photo(ticketCategoryPhoto(ticket.category), radius: 11),
          ),
          const SizedBox(height: Insets.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  ticketCategoryLabel(l, ticket.category),
                  style: context.text.titleSmall,
                ),
              ),
              Text(
                '#${ticket.number}',
                style: const TextStyle(fontFamily: AppTheme.mono, fontSize: 11),
              ),
            ],
          ),
          Text(
            ticket.description.of(ar),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodySmall,
          ),
          const SizedBox(height: Insets.sm),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 13, color: p.muted),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  '${unit.number} · ${prop.name.of(ar)}',
                  style: context.text.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (ticket.urgent) Pill(l.urgent, color: p.late),
            ],
          ),
          if (ticket.technician != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.engineering_rounded, size: 13, color: p.glow),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    technicians[ticket.technician]!.of(ar),
                    style: context.text.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
