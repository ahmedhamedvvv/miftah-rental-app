import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import 'common.dart';

/// One window on the facade.
class FacadeCell {
  const FacadeCell({
    required this.unitId,
    required this.label,
    required this.floor,
    required this.status,
  });

  final String unitId;
  final String label;
  final int floor;
  final UnitStatus status;
}

/// The signature view: a building drawn as an elevation where every window
/// is a unit lit by its rent status. Windows light up floor by floor when the
/// view first appears; late units pulse.
class FacadeView extends StatefulWidget {
  const FacadeView({
    super.key,
    required this.cells,
    required this.columns,
    this.kind = PropertyKind.tower,
    this.onTap,
    this.selectedId,
    this.compact = false,
    this.showFloors = true,
  });

  final List<FacadeCell> cells;
  final int columns;
  final PropertyKind kind;
  final ValueChanged<FacadeCell>? onTap;
  final String? selectedId;
  final bool compact;
  final bool showFloors;

  @override
  State<FacadeView> createState() => _FacadeViewState();
}

class _FacadeViewState extends State<FacadeView> with TickerProviderStateMixin {
  late final AnimationController _lightUp = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500 + widget.cells.length * 28),
  )..forward();

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void didUpdateWidget(FacadeView old) {
    super.didUpdateWidget(old);
    if (old.cells.length != widget.cells.length ||
        old.cells.first.unitId != widget.cells.first.unitId) {
      _lightUp
        ..duration = Duration(milliseconds: 500 + widget.cells.length * 28)
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _lightUp.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final floors = <int, List<FacadeCell>>{};
    for (final c in widget.cells) {
      floors.putIfAbsent(c.floor, () => []).add(c);
    }
    final order = floors.keys.toList()..sort((a, b) => b.compareTo(a));
    final gap = widget.compact ? 5.0 : 7.0;
    final villa = widget.kind == PropertyKind.compound;
    final total = widget.cells.length;

    // Windows light from the ground floor up, left to right.
    double startOf(FacadeCell c) {
      final i = widget.cells.indexOf(c);
      final fromBottom = total - 1 - i;
      return (fromBottom / max(total, 1)) * 0.75;
    }

    Widget window(FacadeCell c) {
      return AnimatedBuilder(
        animation: Listenable.merge([_lightUp, _pulse]),
        builder: (context, _) {
          final s = startOf(c);
          final t = Curves.easeOut.transform(
            ((_lightUp.value - s) / 0.25).clamp(0.0, 1.0),
          );
          return _Window(
            cell: c,
            lit: t,
            pulse: c.status == UnitStatus.late ? _pulse.value : 0,
            selected: c.unitId == widget.selectedId,
            compact: widget.compact,
            villa: villa,
            palette: p,
          );
        },
      );
    }

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final f in order)
          Padding(
            padding: EdgeInsets.only(bottom: gap),
            child: Row(
              children: [
                if (widget.showFloors && !widget.compact)
                  SizedBox(
                    width: 22,
                    child: Text(
                      villa ? '' : '$f',
                      style: TextStyle(
                        fontFamily: AppTheme.mono,
                        fontSize: 10,
                        color: p.muted.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                for (var i = 0; i < widget.columns; i++) ...[
                  if (i > 0) SizedBox(width: gap),
                  Expanded(
                    child: i < floors[f]!.length
                        ? Pressable(
                            scale: 0.92,
                            onTap: widget.onTap == null
                                ? null
                                : () => widget.onTap!(floors[f]![i]),
                            child: window(floors[f]![i]),
                          )
                        : const SizedBox(),
                  ),
                ],
              ],
            ),
          ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.compact ? 16 : 22),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: context.isDark
              ? const [Color(0xFF131C33), Color(0xFF0D1426)]
              : const [Color(0xFF1C2848), Color(0xFF111A33)],
        ),
        border: Border.all(color: p.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Faint stars over the roofline.
          Positioned.fill(child: CustomPaint(painter: _SkyPainter())),
          Padding(
            padding: EdgeInsets.fromLTRB(
              widget.compact ? 12 : 14,
              widget.compact ? 14 : 22,
              widget.compact ? 12 : 14,
              0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!villa) _Crown(compact: widget.compact),
                Container(
                  padding: EdgeInsets.fromLTRB(gap + 2, gap + 4, gap + 2, 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2440),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    border: Border.all(color: const Color(0xFF2A3658)),
                  ),
                  child: body,
                ),
                _Ground(compact: widget.compact, villa: villa),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Window extends StatelessWidget {
  const _Window({
    required this.cell,
    required this.lit,
    required this.pulse,
    required this.selected,
    required this.compact,
    required this.villa,
    required this.palette,
  });

  final FacadeCell cell;
  final double lit;
  final double pulse;
  final bool selected;
  final bool compact;
  final bool villa;
  final Palette palette;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final (Color fill, double glow, Color? edge) = switch (cell.status) {
      UnitStatus.paid => (p.glow, 0.55, null),
      UnitStatus.dueSoon => (p.glow.withValues(alpha: 0.32), 0.12, p.soon),
      UnitStatus.late => (p.late, 0.45 + pulse * 0.35, null),
      UnitStatus.vacant => (p.glass, 0.0, null),
    };
    final color = Color.lerp(p.glass, fill, lit)!;
    final ratio = villa ? 1.7 : 1.55;
    return AspectRatio(
      aspectRatio: ratio,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(villa ? 6 : 3),
          border: Border.all(
            color: selected
                ? Colors.white
                : (edge ?? Colors.transparent).withValues(
                    alpha: edge == null ? 0 : lit,
                  ),
            width: selected ? 2 : 1.4,
          ),
          boxShadow: [
            if (glow > 0 && lit > 0)
              BoxShadow(
                color: fill.withValues(alpha: glow * lit),
                blurRadius: compact ? 8 : 14,
              ),
          ],
        ),
        child: Stack(
          children: [
            // Mullion and a soft reflection, so it reads as glass.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(villa ? 6 : 3),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.16),
                      Colors.white.withValues(alpha: 0),
                    ],
                    stops: const [0, 0.5],
                  ),
                ),
              ),
            ),
            if (!compact)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    cell.label,
                    style: TextStyle(
                      fontFamily: AppTheme.mono,
                      fontSize: 8.5,
                      color:
                          cell.status == UnitStatus.vacant ||
                              cell.status == UnitStatus.dueSoon
                          ? Colors.white.withValues(alpha: 0.55)
                          : const Color(0xFF1A1305).withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Crown extends StatelessWidget {
  const _Crown({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 2,
          height: compact ? 10 : 18,
          color: const Color(0xFF2A3658),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: context.palette.late,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.palette.late.withValues(alpha: 0.7),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        FractionallySizedBox(
          widthFactor: 0.55,
          child: Container(
            height: compact ? 6 : 10,
            decoration: const BoxDecoration(
              color: Color(0xFF1A2440),
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }
}

class _Ground extends StatelessWidget {
  const _Ground({required this.compact, required this.villa});

  final bool compact;
  final bool villa;

  @override
  Widget build(BuildContext context) {
    final glow = context.palette.glow;
    return SizedBox(
      height: compact ? 14 : 26,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(height: 3, color: const Color(0xFF2A3658)),
          if (!villa)
            Container(
              width: compact ? 26 : 44,
              height: compact ? 11 : 22,
              decoration: BoxDecoration(
                color: glow.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
                boxShadow: [
                  BoxShadow(color: glow.withValues(alpha: 0.5), blurRadius: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(7);
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.35);
    for (var i = 0; i < 26; i++) {
      final o = Offset(
        rnd.nextDouble() * size.width,
        rnd.nextDouble() * size.height * 0.5,
      );
      canvas.drawCircle(o, rnd.nextDouble() * 0.9 + 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) => false;
}

/// Small legend explaining window colors.
class FacadeLegend extends StatelessWidget {
  const FacadeLegend({super.key, required this.labels});

  final ({String paid, String soon, String late, String vacant}) labels;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget item(Color c, String t, {bool outline = false}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 13,
          decoration: BoxDecoration(
            color: outline ? c.withValues(alpha: 0.3) : c,
            borderRadius: BorderRadius.circular(2),
            border: outline ? Border.all(color: c, width: 1.4) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(t, style: context.text.labelSmall),
      ],
    );
    return Wrap(
      spacing: 14,
      runSpacing: 8,
      children: [
        item(p.glow, labels.paid),
        item(p.soon, labels.soon, outline: true),
        item(p.late, labels.late),
        item(p.glass, labels.vacant),
      ],
    );
  }
}
