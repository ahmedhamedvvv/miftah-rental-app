import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// A bundled photo from `assets/photos/`. If the file is missing (a fresh
/// clone before `tool/fetch_photos.py` ran) a drawn night facade stands in, so
/// layouts never collapse.
class Photo extends StatelessWidget {
  const Photo(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.scrim = false,
    this.alignment = Alignment.center,
  });

  final String path;
  final BoxFit fit;
  final double radius;

  /// Darkens the lower half so text on top stays readable.
  final bool scrim;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    Widget img = LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth.isFinite ? c.maxWidth : 400.0;
        return Image.asset(
          'assets/photos/$path',
          fit: fit,
          alignment: alignment,
          width: double.infinity,
          height: double.infinity,
          cacheWidth: (w * dpr).round().clamp(200, 1400),
          gaplessPlayback: true,
          frameBuilder: (context, child, frame, sync) {
            if (sync) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOut,
              child: child,
            );
          },
          errorBuilder: (context, _, _) => CustomPaint(
            painter: _FallbackPainter(
              seed: path.hashCode,
              palette: context.palette,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
    if (scrim) {
      img = Stack(
        fit: StackFit.expand,
        children: [
          img,
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.35, 1],
                colors: [Color(0x00000000), Color(0xCC050812)],
              ),
            ),
          ),
        ],
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(color: context.palette.raised, child: img),
    );
  }
}

class _FallbackPainter extends CustomPainter {
  _FallbackPainter({required this.seed, required this.palette});

  final int seed;
  final Palette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF16224A), Color(0xFF0A0F1C)],
        ).createShader(rect),
    );
    final rnd = Random(seed);
    final w = size.width * (0.42 + rnd.nextDouble() * 0.2);
    final h = size.height * 0.78;
    final left = (size.width - w) / 2;
    final top = size.height - h;
    canvas.drawRect(
      Rect.fromLTWH(left, top, w, h),
      Paint()..color = const Color(0xFF141C33),
    );
    const cols = 5;
    final cell = w / (cols + 1);
    final rows = (h / (cell * 1.2)).floor();
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final lit = rnd.nextDouble() > 0.35;
        final x = left + cell * 0.6 + c * cell;
        final y = top + cell * 0.6 + r * cell * 1.2;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, cell * 0.62, cell * 0.8),
            const Radius.circular(2),
          ),
          Paint()
            ..color = lit
                ? palette.glow.withValues(alpha: 0.55 + rnd.nextDouble() * 0.4)
                : const Color(0xFF233056),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FallbackPainter old) => old.seed != seed;
}
