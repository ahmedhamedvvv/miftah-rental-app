import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Mark read after the unread dots had a moment on screen.
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) ref.read(portfolioProvider.notifier).markNoticesRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final notices = [...ref.watch(portfolioProvider).notices]
      ..sort((a, b) => b.at.compareTo(a.at));

    (IconData, Color) look(NoticeKind k) => switch (k) {
      NoticeKind.payment => (Icons.verified_rounded, p.paid),
      NoticeKind.maintenance => (Icons.build_rounded, p.cobalt),
      NoticeKind.contract => (Icons.description_rounded, p.glow),
      NoticeKind.reminder => (Icons.alarm_rounded, p.soon),
    };

    return PageScaffold(
      title: l.notifications,
      padding: const EdgeInsets.fromLTRB(
        Insets.page,
        0,
        Insets.page,
        Insets.xl,
      ),
      children: [
        for (final (i, n) in notices.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.sm),
            child: Panel(
              color: n.read ? p.surface : p.cobaltSoft,
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconTile(
                    icon: look(n.kind).$1,
                    color: look(n.kind).$2,
                    size: 40,
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.title.of(ar), style: context.text.titleSmall),
                        const SizedBox(height: 2),
                        Text(n.body.of(ar), style: context.text.bodySmall),
                        const SizedBox(height: 6),
                        Text(
                          Fmt.dateTime(context, n.at),
                          style: context.text.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  if (!n.read)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: p.cobalt,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ).entrance(i),
          ),
      ],
    );
  }
}
