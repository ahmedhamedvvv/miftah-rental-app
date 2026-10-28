import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

/// Three steps: what is broken, describe it, pick a visit time.
class NewRequestScreen extends ConsumerStatefulWidget {
  const NewRequestScreen({super.key});

  @override
  ConsumerState<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends ConsumerState<NewRequestScreen> {
  int _step = 0;
  TicketCategory? _category;
  final _text = TextEditingController();
  bool _urgent = false;
  int _slot = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _canNext => switch (_step) {
    0 => _category != null,
    1 => _text.text.trim().length >= 6,
    _ => true,
  };

  Future<void> _submit() async {
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final lease = ref.read(myLeaseProvider);
    final t = ref
        .read(portfolioProvider.notifier)
        .createTicket(
          unitId: lease.unit.id,
          category: _category!,
          description: _text.text.trim(),
          slot: _slot,
          urgent: _urgent,
        );
    showToast(context, context.l10n.requestSent(t.number));
    context.pushReplacement(Routes.tenantTicket(t.id));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final titles = [l.stepWhat, l.stepDescribe, l.stepWhen];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.page,
                Insets.md,
                Insets.page,
                0,
              ),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: _step == 0
                        ? Icons.close_rounded
                        : (Directionality.of(context) == TextDirection.rtl
                              ? Icons.arrow_forward_rounded
                              : Icons.arrow_back_rounded),
                    onTap: () =>
                        _step == 0 ? context.pop() : setState(() => _step--),
                  ),
                  const SizedBox(width: Insets.lg),
                  Expanded(
                    child: Row(
                      children: [
                        for (var i = 0; i < 3; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                              height: 5,
                              decoration: BoxDecoration(
                                color: i <= _step ? p.cobalt : p.line,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: Insets.lg),
                  Text('${_step + 1}/3', style: context.text.labelMedium),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position:
                        Tween(
                          begin: const Offset(0.06, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: a,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  ),
                ),
                child: ListView(
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(
                    Insets.page,
                    Insets.xl,
                    Insets.page,
                    Insets.xl,
                  ),
                  children: [
                    Text(titles[_step], style: context.text.displaySmall),
                    const SizedBox(height: Insets.xl),
                    ...switch (_step) {
                      0 => _categories(),
                      1 => _describe(),
                      _ => _when(),
                    },
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.page,
                0,
                Insets.page,
                Insets.lg,
              ),
              child: PrimaryButton(
                label: _step < 2 ? l.next : l.sendRequest,
                icon: _step < 2 ? null : Icons.send_rounded,
                busy: _busy,
                onPressed: !_canNext
                    ? null
                    : (_step < 2 ? () => setState(() => _step++) : _submit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _categories() {
    final l = context.l10n;
    final p = context.palette;
    return [
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: Insets.md,
        crossAxisSpacing: Insets.md,
        childAspectRatio: 1.05,
        children: [
          for (final (i, c) in TicketCategory.values.indexed)
            Pressable(
              onTap: () => setState(() => _category = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Radii.card),
                  border: Border.all(
                    color: _category == c ? p.cobalt : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                padding: const EdgeInsets.all(2),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Photo(
                      ticketCategoryPhoto(c),
                      radius: Radii.card - 3,
                      scrim: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Insets.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(ticketCategoryIcon(c), color: Colors.white),
                          const Spacer(),
                          Text(
                            ticketCategoryLabel(l, c),
                            style: context.text.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_category == c)
                      PositionedDirectional(
                        top: 10,
                        end: 10,
                        child:
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: p.cobalt,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ).animate().scaleXY(
                              begin: 0.3,
                              curve: Curves.easeOutBack,
                              duration: 300.ms,
                            ),
                      ),
                  ],
                ),
              ),
            ).entrance(i),
        ],
      ),
    ];
  }

  List<Widget> _describe() {
    final l = context.l10n;
    final p = context.palette;
    final presets = switch (_category!) {
      TicketCategory.ac => [l.presetAc1, l.presetAc2, l.presetAc3],
      TicketCategory.plumbing => [l.presetPl1, l.presetPl2, l.presetPl3],
      TicketCategory.electrical => [l.presetEl1, l.presetEl2, l.presetEl3],
      TicketCategory.appliances => [l.presetAp1, l.presetAp2],
      TicketCategory.other => [l.presetOt1, l.presetOt2],
    };
    return [
      Wrap(
        spacing: Insets.sm,
        runSpacing: Insets.sm,
        children: [
          for (final s in presets)
            Pressable(
              onTap: () => _text.text = s,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _text.text == s ? p.cobaltSoft : p.surface,
                  borderRadius: BorderRadius.circular(Radii.pill),
                  border: Border.all(
                    color: _text.text == s ? p.cobalt : p.line,
                  ),
                ),
                child: Text(s, style: context.text.labelMedium),
              ),
            ),
        ],
      ),
      const SizedBox(height: Insets.lg),
      TextField(
        controller: _text,
        maxLines: 5,
        minLines: 4,
        decoration: InputDecoration(hintText: l.describeHint),
      ),
      const SizedBox(height: Insets.lg),
      Panel(
        child: Row(
          children: [
            IconTile(icon: Icons.priority_high_rounded, color: p.late),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.urgentTitle, style: context.text.titleSmall),
                  Text(l.urgentBody, style: context.text.bodySmall),
                ],
              ),
            ),
            Switch(
              value: _urgent,
              onChanged: (v) => setState(() => _urgent = v),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _when() {
    final l = context.l10n;
    final p = context.palette;
    final tomorrow = ref.read(clockProvider)().add(const Duration(days: 1));
    final slots = [
      (Icons.wb_sunny_rounded, l.slotMorning, '8:00 – 12:00'),
      (Icons.wb_twilight_rounded, l.slotAfternoon, '12:00 – 5:00'),
      (Icons.nights_stay_rounded, l.slotEvening, '5:00 – 9:00'),
    ];
    return [
      Text(
        l.visitDay(Fmt.date(context, tomorrow)),
        style: context.text.bodyMedium?.copyWith(color: p.muted),
      ),
      const SizedBox(height: Insets.md),
      for (final (i, s) in slots.indexed) ...[
        Pressable(
          onTap: () => setState(() => _slot = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(Insets.lg),
            decoration: BoxDecoration(
              color: _slot == i ? p.cobaltSoft : p.surface,
              borderRadius: BorderRadius.circular(Radii.control),
              border: Border.all(
                color: _slot == i ? p.cobalt : p.line,
                width: _slot == i ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(s.$1, color: _slot == i ? p.cobalt : p.muted),
                const SizedBox(width: Insets.md),
                Expanded(child: Text(s.$2, style: context.text.titleSmall)),
                Text(
                  s.$3,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontFamily: AppTheme.mono,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ).entrance(i),
        const SizedBox(height: Insets.sm),
      ],
      const SizedBox(height: Insets.lg),
      Panel(
        color: p.raised,
        child: Column(
          children: [
            LabelValue(l.category, ticketCategoryLabel(l, _category!)),
            LabelValue(
              l.priority,
              _urgent ? l.urgent : l.normal,
              valueColor: _urgent ? p.late : null,
            ),
            LabelValue(l.details, _text.text.trim()),
          ],
        ),
      ),
    ];
  }
}
