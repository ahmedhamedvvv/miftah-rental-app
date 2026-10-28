import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/key_card.dart';
import '../../core/widgets/photo.dart';
import '../../state/providers.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF060A14),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Slow push-in on the night photo.
          const Photo(
            'buildings/night.jpg',
            alignment: Alignment(0, -0.3),
          ).animate().scale(
            begin: const Offset(1.12, 1.12),
            end: const Offset(1, 1),
            duration: 9.seconds,
            curve: Curves.easeOutCubic,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.35, 0.62, 1],
                colors: [
                  Color(0x99060A14),
                  Color(0x22060A14),
                  Color(0xDD060A14),
                  Color(0xFF060A14),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.xl,
                Insets.md,
                Insets.xl,
                Insets.xl,
              ),
              child: Theme(
                data: AppTheme.build(Brightness.dark),
                child: Builder(
                  builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const AppMark(size: 40),
                          const SizedBox(width: Insets.md),
                          Text(
                            l.appName,
                            style: context.text.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Pressable(
                            onTap: ctrl.toggleLocale,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(Radii.pill),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Text(
                                settings.isArabic ? 'English' : 'العربية',
                                style: context.text.labelMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 500.ms),
                      const Spacer(),
                      Text(
                        l.welcomeEyebrow,
                        style: context.text.labelMedium?.copyWith(
                          color: context.palette.glow,
                          letterSpacing: 0.6,
                        ),
                      ).entrance(0, baseMs: 250),
                      const SizedBox(height: Insets.sm),
                      Text(
                        l.welcomeTitle,
                        style: context.text.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ).entrance(1, baseMs: 250),
                      const SizedBox(height: Insets.md),
                      Text(
                        l.welcomeSubtitle,
                        style: context.text.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ).entrance(2, baseMs: 250),
                      const SizedBox(height: Insets.xl),
                      _RoleCard(
                        icon: Icons.key_rounded,
                        title: l.roleTenant,
                        subtitle: l.roleTenantDesc,
                        accent: context.palette.cobalt,
                        onTap: () => ctrl.enter(UserRole.tenant),
                      ).entrance(3, baseMs: 250),
                      const SizedBox(height: Insets.md),
                      _RoleCard(
                        icon: Icons.apartment_rounded,
                        title: l.roleOwner,
                        subtitle: l.roleOwnerDesc,
                        accent: context.palette.glow,
                        onTap: () => ctrl.enter(UserRole.owner),
                      ).entrance(4, baseMs: 250),
                      const SizedBox(height: Insets.lg),
                      Center(
                        child: Text(
                          l.demoNote,
                          style: context.text.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ).entrance(5, baseMs: 250),
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Radii.card),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.text.titleMedium?.copyWith(
                      color: Colors.white,
                      fontFamily: AppTheme.display,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: context.text.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              rtl ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
