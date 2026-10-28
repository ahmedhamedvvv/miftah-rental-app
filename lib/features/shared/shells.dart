import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

class TenantShell extends ConsumerWidget {
  const TenantShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final open = ref.watch(
      ledgerProvider.select(
        (x) => x
            .ticketsOfUnit(ref.read(myLeaseProvider).unit.id)
            .where((t) => t.status != TicketStatus.done)
            .length,
      ),
    );
    return _Shell(
      shell: shell,
      items: [
        (Icons.key_rounded, l.navHome, 0),
        (Icons.receipt_long_rounded, l.navPayments, 0),
        (Icons.build_rounded, l.navMaintenance, open),
        (Icons.description_rounded, l.navLease, 0),
      ],
    );
  }
}

class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final late = ref.watch(ledgerProvider.select((x) => x.overdue().length));
    final open = ref.watch(
      ledgerProvider.select(
        (x) =>
            x.data.tickets.where((t) => t.status == TicketStatus.open).length,
      ),
    );
    return _Shell(
      shell: shell,
      items: [
        (Icons.apartment_rounded, l.navFacade, 0),
        (Icons.domain_rounded, l.navProperties, 0),
        (Icons.payments_rounded, l.navCollections, late),
        (Icons.handyman_rounded, l.navMaintenance, open),
        (Icons.insights_rounded, l.navReports, 0),
      ],
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.shell, required this.items});

  final StatefulNavigationShell shell;
  final List<(IconData, String, int)> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: _FloatingNav(
        index: shell.currentIndex,
        items: items,
        onTap: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}

/// Frosted bar floating over content, with a pill that slides to the
/// selected tab.
class _FloatingNav extends StatelessWidget {
  const _FloatingNav({
    required this.index,
    required this.items,
    required this.onTap,
  });

  final int index;
  final List<(IconData, String, int)> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(14, 0, 14, bottom > 0 ? bottom : 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 68,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: p.surface.withValues(alpha: context.isDark ? 0.78 : 0.86),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: p.line),
            ),
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth / items.length;
                final rtl = Directionality.of(context) == TextDirection.rtl;
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutBack,
                      top: 0,
                      bottom: 0,
                      left: rtl ? null : w * index,
                      right: rtl ? w * index : null,
                      width: w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: p.cobalt.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (final (i, it) in items.indexed)
                          Expanded(
                            child: Semantics(
                              button: true,
                              selected: i == index,
                              label: it.$2,
                              child: Pressable(
                                scale: 0.9,
                                onTap: () => onTap(i),
                                child: _NavItem(
                                  icon: it.$1,
                                  label: it.$2,
                                  badge: it.$3,
                                  selected: i == index,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.badge,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final int badge;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = selected ? p.cobalt : p.muted;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedScale(
              scale: selected ? 1.1 : 1,
              duration: const Duration(milliseconds: 250),
              child: Icon(icon, size: 23, color: color),
            ),
            if (badge > 0)
              PositionedDirectional(
                top: -4,
                end: -9,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: p.late,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: context.text.labelSmall!.copyWith(
            color: color,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 10.5,
          ),
          child: Text(label, maxLines: 1, overflow: TextOverflow.fade),
        ),
      ],
    );
  }
}
