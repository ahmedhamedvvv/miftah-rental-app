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

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lease = ref.watch(myLeaseProvider);
    final tickets = ref.watch(ledgerProvider).ticketsOfUnit(lease.unit.id);
    final active = tickets.where((t) => t.status != TicketStatus.done).toList();
    final past = tickets.where((t) => t.status == TicketStatus.done).toList();

    return PageScaffold(
      title: l.navMaintenance,
      subtitle: l.maintenanceSubtitle,
      children: [
        Pressable(
          onTap: () => context.push(Routes.newRequest),
          child: SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Photo(
                  'maintenance/ac.jpg',
                  radius: Radii.card,
                  scrim: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(Insets.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        l.newRequest,
                        style: context.text.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.newRequestHint,
                        style: context.text.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: Insets.lg,
                  end: Insets.lg,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.palette.cobalt,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ).entrance(0),
        const SizedBox(height: Insets.xl),
        if (active.isNotEmpty) ...[
          SectionTitle(l.activeRequests),
          for (final (i, t) in active.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.md),
              child: TicketCard(
                ticket: t,
                onTap: () => context.push(Routes.tenantTicket(t.id)),
              ).entrance(1 + i),
            ),
          const SizedBox(height: Insets.md),
        ],
        SectionTitle(l.pastRequests),
        if (past.isEmpty)
          EmptyNote(icon: Icons.history_rounded, text: l.noPastRequests)
        else
          for (final (i, t) in past.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.md),
              child: TicketCard(
                ticket: t,
                onTap: () => context.push(Routes.tenantTicket(t.id)),
              ).entrance(3 + i),
            ),
      ],
    );
  }
}

/// Compact ticket summary with a four-step progress bar.
class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
    this.subtitle,
  });

  final Ticket ticket;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final step = ticket.status.index;
    final color = ticket.status == TicketStatus.done
        ? p.paid
        : (ticket.urgent ? p.late : p.cobalt);
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 58,
                height: 58,
                child: Photo(ticketCategoryPhoto(ticket.category), radius: 14),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ticketCategoryLabel(l, ticket.category),
                            style: context.text.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '#${ticket.number}',
                          style: const TextStyle(
                            fontFamily: AppTheme.mono,
                            fontSize: 11.5,
                          ),
                        ),
                        if (ticket.urgent) ...[
                          const SizedBox(width: 6),
                          Pill(l.urgent, color: p.late),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle ?? ticket.description.of(context.arabic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Insets.sm),
              Pill(ticketStatusLabel(l, ticket.status), color: color),
            ],
          ),
          const SizedBox(height: Insets.md),
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300 + i * 120),
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= step ? color : p.raised,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                Fmt.dateTime(context, ticket.updatedAt),
                style: context.text.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
