import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme.dart';

/// The tenant's digital key: a wallet-style card that flips in 3D to show
/// the lease on its back.
class KeyCard extends StatefulWidget {
  const KeyCard({super.key, required this.front, required this.back});

  final Widget front;
  final Widget back;

  @override
  State<KeyCard> createState() => _KeyCardState();
}

class _KeyCardState extends State<KeyCard> with SingleTickerProviderStateMixin {
  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );

  Offset _tilt = Offset.zero;

  void _toggle() {
    HapticFeedback.lightImpact();
    if (_flip.status == AnimationStatus.completed ||
        _flip.status == AnimationStatus.forward) {
      _flip.reverse();
    } else {
      _flip.forward();
    }
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (e) {
        final box = context.size;
        if (box == null) return;
        setState(() {
          _tilt = Offset(
            (e.localPosition.dx / box.width - 0.5) * 2,
            (e.localPosition.dy / box.height - 0.5) * 2,
          );
        });
      },
      onExit: (_) => setState(() => _tilt = Offset.zero),
      child: GestureDetector(
        onTap: _toggle,
        child: AspectRatio(
          aspectRatio: 1.62,
          child: AnimatedBuilder(
            animation: _flip,
            builder: (context, _) {
              final t = Curves.easeInOutBack.transform(_flip.value);
              final angle = t * pi;
              final showBack = angle > pi / 2;
              final m = Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateX(-_tilt.dy * 0.06)
                ..rotateY(angle + _tilt.dx * 0.08);
              return Transform(
                alignment: Alignment.center,
                transform: m,
                child: showBack
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: _Face(child: widget.back),
                      )
                    : _Face(shine: true, child: widget.front),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({required this.child, this.shine = false});

  final Widget child;
  final bool shine;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget face = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: RadialGradient(
          center: AlignmentDirectional.topEnd.resolve(
            Directionality.of(context),
          ),
          radius: 1.5,
          colors: p.keyGradient,
          stops: const [0, 0.42, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: p.cobalt.withValues(alpha: 0.38),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GuillochePainter())),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
    if (shine) {
      face = face
          .animate(onPlay: (c) => c.repeat())
          .shimmer(
            delay: 2600.ms,
            duration: 1500.ms,
            color: Colors.white.withValues(alpha: 0.22),
            angle: 0.9,
          );
    }
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white),
      child: IconTheme.merge(
        data: const IconThemeData(color: Colors.white),
        child: face,
      ),
    );
  }
}

/// Fine engraved lines, like the security pattern on a bank card.
class _GuillochePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.07);
    final c = Offset(size.width * 0.92, size.height * 1.1);
    for (var r = 40.0; r < size.width * 1.4; r += 11) {
      canvas.drawCircle(c, r, paint);
    }
  }

  @override
  bool shouldRepaint(_GuillochePainter oldDelegate) => false;
}

/// The Miftah mark: a key whose bow is a ring.
class KeyMark extends StatelessWidget {
  const KeyMark({super.key, this.size = 28, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _KeyMarkPainter(color));
  }
}

class _KeyMarkPainter extends CustomPainter {
  _KeyMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 44;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(15 * s, 22 * s), 8 * s, paint);
    canvas.drawLine(Offset(23 * s, 22 * s), Offset(38 * s, 22 * s), paint);
    canvas.drawLine(Offset(33 * s, 22 * s), Offset(33 * s, 29 * s), paint);
    canvas.drawLine(Offset(38 * s, 22 * s), Offset(38 * s, 27 * s), paint);
  }

  @override
  bool shouldRepaint(_KeyMarkPainter old) => old.color != color;
}

/// App icon tile with the key mark.
class AppMark extends StatelessWidget {
  const AppMark({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.keyGradient[0], p.keyGradient[1], p.keyGradient[2]],
        ),
        boxShadow: [
          BoxShadow(
            color: p.cobalt.withValues(alpha: 0.4),
            blurRadius: size * 0.45,
            offset: Offset(0, size * 0.14),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: KeyMark(size: size * 0.62),
    );
  }
}

/// Circle that closes as rent day approaches, with the days left inside.
class RentRing extends StatelessWidget {
  const RentRing({
    super.key,
    required this.progress,
    required this.center,
    this.caption,
    this.size = 64,
    this.color,
    this.track,
  });

  /// 0 right after a payment, 1 on the due date.
  final double progress;
  final String center;
  final String? caption;
  final double size;
  final Color? color;
  final Color? track;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.palette.glow;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0, 1)),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(
            v,
            c,
            track ?? Colors.white.withValues(alpha: 0.18),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  center,
                  style: TextStyle(
                    fontFamily: AppTheme.display,
                    fontWeight: FontWeight.w800,
                    fontSize: size * 0.3,
                    height: 1,
                    color: DefaultTextStyle.of(context).style.color,
                  ),
                ),
                if (caption != null)
                  Text(
                    caption!,
                    style: TextStyle(
                      fontSize: size * 0.14,
                      height: 1.3,
                      color: DefaultTextStyle.of(context).style.color
                          ?.withValues(alpha: 0.7),
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

class _RingPainter extends CustomPainter {
  _RingPainter(this.v, this.color, this.track);

  final double v;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.085;
    final rect =
        Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    canvas.drawArc(
      rect,
      0,
      2 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * v,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.v != v || old.color != color;
}
