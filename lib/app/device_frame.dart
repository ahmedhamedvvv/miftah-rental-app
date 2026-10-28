import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../core/widgets/common.dart';
import '../core/widgets/key_card.dart';
import '../state/providers.dart';
import 'router.dart';

/// On a wide browser window the app is shown inside a phone, next to a panel
/// that explains the project and lets visitors switch side, language and
/// theme live. Add `?embed=1` to the URL to drop the frame when the demo is
/// embedded in another page.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({super.key, required this.child});

  final Widget child;

  static const phoneSize = Size(390, 844);
  static final bool _embedded =
      kIsWeb && Uri.base.queryParameters['embed'] == '1';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (!kIsWeb || _embedded || size.width < 900 || size.height < 600) {
      return child;
    }
    return _Showcase(child: child);
  }
}

class _Showcase extends StatelessWidget {
  const _Showcase({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.bg,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.55, -0.1),
                  radius: 1.1,
                  colors: [
                    p.cobalt.withValues(alpha: context.isDark ? 0.22 : 0.12),
                    p.bg,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 24,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: _InfoPanel(),
                        ),
                      ),
                      const SizedBox(width: 56),
                      _Phone(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const size = DeviceFrame.phoneSize;
    const bezel = 12.0;
    final mq = MediaQuery.of(context);
    final isDark = context.isDark;
    const insets = EdgeInsets.only(top: 50, bottom: 24);

    return FittedBox(
          child: Container(
            width: size.width + bezel * 2,
            height: size.height + bezel * 2,
            padding: const EdgeInsets.all(bezel),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0E16),
              borderRadius: BorderRadius.circular(62),
              border: Border.all(color: const Color(0xFF2E3446), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 70,
                  offset: const Offset(0, 34),
                ),
                BoxShadow(
                  color: context.palette.cobalt.withValues(alpha: 0.18),
                  blurRadius: 120,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: MediaQuery(
                data: mq.copyWith(
                  size: size,
                  padding: insets,
                  viewPadding: insets,
                  viewInsets: EdgeInsets.zero,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(child: child),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 50,
                      child: IgnorePointer(child: _StatusBar(dark: isDark)),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Center(
                          child: Container(
                            width: 134,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white70 : Colors.black87,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.05, curve: Curves.easeOutCubic);
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = dark ? Colors.white : Colors.black;
    final style = TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: 15,
      fontFamily: AppTheme.body,
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            Text('9:41', style: style),
            const Spacer(),
            Container(
              width: 120,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const Spacer(),
            Icon(Icons.signal_cellular_alt_rounded, size: 17, color: color),
            const SizedBox(width: 4),
            Icon(Icons.wifi_rounded, size: 17, color: color),
            const SizedBox(width: 4),
            Icon(Icons.battery_full_rounded, size: 19, color: color),
          ],
        ),
      ),
    );
  }
}

class _InfoPanel extends ConsumerWidget {
  const _InfoPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final settings = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);

    void openAs(UserRole role) {
      ctrl.enter(role);
      ref.read(routerProvider).go(Routes.homeFor(role));
    }

    final features = [
      (Icons.apartment_rounded, l.featureFacade),
      (Icons.key_rounded, l.featureKeyCard),
      (Icons.payments_rounded, l.featurePayments),
      (Icons.handyman_rounded, l.featureMaintenance),
      (Icons.translate_rounded, l.featureBilingual),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const AppMark(size: 54),
                const SizedBox(width: Insets.md),
                Text(l.appName, style: context.text.headlineMedium),
              ],
            ).entrance(0),
            const SizedBox(height: Insets.xl),
            Text(
              l.frameTitle,
              style: context.text.displayMedium?.copyWith(height: 1.15),
            ).entrance(1),
            const SizedBox(height: Insets.md),
            Text(
              l.frameSubtitle,
              style: context.text.titleMedium?.copyWith(
                color: p.muted,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ).entrance(2),
            const SizedBox(height: Insets.xl),
            for (final (i, f) in features.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.md),
                child: Row(
                  children: [
                    IconTile(icon: f.$1, size: 38),
                    const SizedBox(width: Insets.md),
                    Expanded(child: Text(f.$2, style: context.text.bodyLarge)),
                  ],
                ),
              ).entrance(3 + i),
            const SizedBox(height: Insets.lg),
            Text(l.frameTryIt, style: context.text.titleSmall),
            const SizedBox(height: Insets.md),
            // Panel controls are pointer-only on purpose: focusable buttons
            // here get swept into the browser's initial focus pass before
            // this panel's first layout and throw.
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                _Pill(
                  icon: Icons.key_rounded,
                  label: l.roleTenant,
                  selected: settings.role == UserRole.tenant,
                  onTap: () => openAs(UserRole.tenant),
                ),
                _Pill(
                  icon: Icons.apartment_rounded,
                  label: l.roleOwner,
                  selected: settings.role == UserRole.owner,
                  onTap: () => openAs(UserRole.owner),
                ),
                _Pill(
                  icon: Icons.translate_rounded,
                  label: settings.isArabic ? 'English' : 'العربية',
                  onTap: ctrl.toggleLocale,
                ),
                _Pill(
                  icon: context.isDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  label: context.isDark ? l.lightMode : l.darkMode,
                  onTap: ctrl.toggleTheme,
                ),
              ],
            ),
            const SizedBox(height: Insets.lg),
            _Pill(
              icon: Icons.android_rounded,
              label: l.downloadApk,
              selected: true,
              accent: p.glow,
              onTap: () => launchUrl(Uri.base.resolve('miftah.apk')),
            ),
            const SizedBox(height: Insets.xl),
            Text(l.builtWith, style: context.text.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.accent,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final c = accent ?? p.cobalt;
    final fg = selected
        ? (accent != null ? const Color(0xFF0A0F1C) : Colors.white)
        : p.ink;
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? c : p.surface,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: selected ? c : p.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 8),
            Text(label, style: context.text.labelLarge?.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}
