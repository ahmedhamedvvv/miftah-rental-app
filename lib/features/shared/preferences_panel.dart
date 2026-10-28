import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../state/providers.dart';

/// Language, theme, switching sides and resetting the demo. Shared by both
/// roles.
class PreferencesPanel extends ConsumerWidget {
  const PreferencesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final settings = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);

    Widget row(
      IconData icon,
      String title,
      Widget trailing, {
      VoidCallback? onTap,
      Color? color,
    }) => Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            IconTile(icon: icon, size: 38, color: color),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                title,
                style: context.text.titleSmall?.copyWith(color: color),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );

    return Panel(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.sm,
      ),
      child: Column(
        children: [
          row(
            Icons.translate_rounded,
            l.language,
            Text(
              settings.isArabic ? 'العربية' : 'English',
              style: context.text.labelMedium?.copyWith(color: p.cobalt),
            ),
            onTap: ctrl.toggleLocale,
          ),
          row(
            Icons.dark_mode_rounded,
            l.darkMode,
            Switch(
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (_) => ctrl.toggleTheme(),
            ),
          ),
          row(
            Icons.swap_horiz_rounded,
            settings.role == UserRole.tenant
                ? l.switchToOwner
                : l.switchToTenant,
            Icon(Icons.chevron_right_rounded, color: p.muted),
            onTap: () => ctrl.enter(
              settings.role == UserRole.tenant
                  ? UserRole.owner
                  : UserRole.tenant,
            ),
          ),
          row(
            Icons.restart_alt_rounded,
            l.resetDemo,
            const SizedBox(),
            color: p.late,
            onTap: () {
              ref.read(portfolioProvider.notifier).reset();
              showToast(context, l.demoReset);
            },
          ),
          row(
            Icons.logout_rounded,
            l.backToWelcome,
            const SizedBox(),
            onTap: ctrl.leave,
          ),
        ],
      ),
    );
  }
}
