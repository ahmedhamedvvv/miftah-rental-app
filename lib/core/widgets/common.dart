import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models.dart';
import '../format.dart';
import '../theme.dart';

/// Staggered entrance used for list items and sections across the app.
extension Entrance on Widget {
  Widget entrance(int index, {double dy = 0.06, int baseMs = 40}) =>
      animate(delay: Duration(milliseconds: baseMs + index * 55))
          .fadeIn(duration: 380.ms, curve: Curves.easeOut)
          .slideY(
            begin: dy,
            end: 0,
            duration: 460.ms,
            curve: Curves.easeOutCubic,
          );
}

/// Shrinks slightly while pressed, for anything tappable that is not a
/// standard button.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
    this.haptic = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final bool haptic;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap == null || _down == v) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap == null
          ? MouseCursor.defer
          : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap == null
            ? null
            : () {
                if (widget.haptic) HapticFeedback.selectionClick();
                widget.onTap!();
              },
        child: AnimatedScale(
          scale: _down ? widget.scale : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}

/// A bordered surface. Used by role, not on every block.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Insets.lg),
    this.onTap,
    this.color,
    this.radius = Radii.card,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? p.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? p.line),
      ),
      child: child,
    );
    return onTap == null ? box : Pressable(onTap: onTap, child: box);
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    this.tone,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = tone ?? p.cobalt;
    final enabled = onPressed != null && !busy;
    return Pressable(
      onTap: enabled ? onPressed : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled || busy ? 1 : 0.45,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.control),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [Color.lerp(color, Colors.white, 0.16)!, color],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: busy
                ? const SizedBox(
                    key: ValueKey('busy'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    key: const ValueKey('label'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: Insets.sm),
                      ],
                      Text(
                        label,
                        style: context.text.labelLarge?.copyWith(
                          color: Colors.white,
                          fontFamily: AppTheme.display,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final c = color ?? p.ink;
    return Pressable(
      onTap: onPressed,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.control),
          border: Border.all(color: p.line),
          color: p.surface,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 19, color: c),
              const SizedBox(width: Insets.sm),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelLarge?.copyWith(color: c),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section title with an optional trailing action.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: Row(
        children: [
          Expanded(child: Text(title, style: context.text.titleLarge)),
          if (action != null)
            Pressable(
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  action!,
                  style: context.text.labelMedium?.copyWith(
                    color: context.palette.cobalt,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill(
    this.label, {
    super.key,
    required this.color,
    this.icon,
    this.solid = false,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool solid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: solid ? color : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: solid ? Colors.white : color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: solid ? Colors.white : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.status, {super.key});

  final UnitStatus status;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final label = switch (status) {
      UnitStatus.paid => l.statusPaid,
      UnitStatus.dueSoon => l.statusDueSoon,
      UnitStatus.late => l.statusLate,
      UnitStatus.vacant => l.statusVacant,
    };
    return Pill(label, color: context.palette.status(status));
  }
}

/// Animates a number up to [value] the first time it shows, and between
/// values after that.
class CountUp extends StatelessWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.format,
    this.style,
    this.duration = const Duration(milliseconds: 1100),
  });

  final num value;
  final String Function(num v) format;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutExpo,
      builder: (context, v, _) => Text(
        format(v),
        style: style?.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.tenant, this.size = 44});

  final Tenant tenant;
  final double size;

  static const _tones = [
    Color(0xFF4A6CFF),
    Color(0xFF2DB89A),
    Color(0xFFE29B3A),
    Color(0xFFB56CF0),
    Color(0xFFE2577A),
    Color(0xFF3AA3D9),
  ];

  @override
  Widget build(BuildContext context) {
    final tone = _tones[tenant.id.hashCode.abs() % _tones.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tone.withValues(alpha: 0.16),
        border: Border.all(color: tone.withValues(alpha: 0.4)),
      ),
      alignment: Alignment.center,
      child: Text(
        tenant.initials(context.arabic),
        style: TextStyle(
          fontFamily: AppTheme.display,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.32,
          color: tone,
        ),
      ),
    );
  }
}

/// Round icon tile used in lists and grids.
class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.icon, this.color, this.size = 42});

  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.palette.cobalt;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(size * 0.34),
      ),
      child: Icon(icon, color: c, size: size * 0.5),
    );
  }
}

class LabelValue extends StatelessWidget {
  const LabelValue(
    this.label,
    this.value, {
    super.key,
    this.mono = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool mono;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.text.bodyMedium?.copyWith(
                color: context.palette.muted,
              ),
            ),
          ),
          const SizedBox(width: Insets.md),
          Flexible(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              textDirection: mono ? TextDirection.ltr : null,
              style:
                  (mono
                          ? const TextStyle(
                              fontFamily: AppTheme.mono,
                              fontSize: 13.5,
                            )
                          : context.text.titleSmall)
                      ?.copyWith(color: valueColor ?? context.palette.ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// A screen with a large title that the content scrolls under.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.actions = const [],
    this.leading,
    this.bottom,
    this.padding = const EdgeInsets.fromLTRB(Insets.page, 0, Insets.page, 120),
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final List<Widget> actions;
  final Widget? leading;
  final Widget? bottom;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      bottomNavigationBar: bottom,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.page,
                  Insets.md,
                  Insets.page,
                  Insets.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (canPop || leading != null || actions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Insets.md),
                        child: Row(
                          children: [
                            ?leading ?? (canPop ? const RoundBack() : null),
                            const Spacer(),
                            ...actions,
                          ],
                        ),
                      ),
                    Text(title, style: context.text.displaySmall)
                        .animate()
                        .fadeIn(duration: 350.ms)
                        .slideX(begin: 0.04, curve: Curves.easeOutCubic),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: context.text.bodyMedium?.copyWith(
                          color: context.palette.muted,
                        ),
                      ).animate().fadeIn(delay: 80.ms, duration: 350.ms),
                    ],
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: padding,
              sliver: SliverList.list(children: children),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.badge = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool badge;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      label: tooltip,
      child: Pressable(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: p.surface,
            border: Border.all(color: p.line),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 21, color: p.ink),
              if (badge)
                PositionedDirectional(
                  top: 10,
                  end: 11,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: p.late,
                      shape: BoxShape.circle,
                      border: Border.all(color: p.surface, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundBack extends StatelessWidget {
  const RoundBack({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundIconButton(
      icon: Directionality.of(context) == TextDirection.rtl
          ? Icons.arrow_forward_rounded
          : Icons.arrow_back_rounded,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onTap: () => Navigator.of(context).maybePop(),
    );
  }
}

/// Segmented control with a sliding thumb.
class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final index = options.indexWhere((o) => o.$1 == selected);
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: p.line),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / options.length;
          final rtl = Directionality.of(context) == TextDirection.rtl;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutBack,
                left: rtl ? null : w * index,
                right: rtl ? w * index : null,
                top: 0,
                bottom: 0,
                width: w,
                child: Container(
                  decoration: BoxDecoration(
                    color: p.cobalt,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final o in options)
                    Expanded(
                      child: Pressable(
                        scale: 1,
                        onTap: () => onChanged(o.$1),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: context.text.labelMedium!.copyWith(
                              color: o.$1 == selected ? Colors.white : p.muted,
                              fontWeight: FontWeight.w600,
                            ),
                            child: Text(o.$2, maxLines: 1),
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
    );
  }
}

class EmptyNote extends StatelessWidget {
  const EmptyNote({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.xxl),
      child: Column(
        children: [
          IconTile(icon: icon, size: 56, color: context.palette.muted),
          const SizedBox(height: Insets.md),
          Text(
            text,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(
              color: context.palette.muted,
            ),
          ),
        ],
      ),
    );
  }
}

void showToast(BuildContext context, String message, {IconData? icon}) {
  final p = context.palette;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon ?? Icons.check_circle_rounded, color: p.paid, size: 20),
            const SizedBox(width: Insets.sm),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
