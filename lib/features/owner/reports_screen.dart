import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String? _property;
  bool _grown = false;

  @override
  void initState() {
    super.initState();
    // Bars grow from zero once the screen is on.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _grown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final months = ledger.monthlyIncome(propertyId: _property);
    final year = months.fold(0, (a, m) => a + m.amount);
    final best = months.reduce((a, b) => a.amount >= b.amount ? a : b);
    final maxY = (best.amount * 1.18).clamp(1000, double.infinity).toDouble();
    final allYear = ledger.monthlyIncome().fold(0, (a, m) => a + m.amount);

    return PageScaffold(
      title: l.navReports,
      subtitle: l.reportsSubtitle,
      actions: [
        RoundIconButton(
          icon: Icons.tune_rounded,
          tooltip: l.settings,
          onTap: () => context.push(Routes.settings),
        ),
      ],
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final id in <String?>[
                null,
                ...ledger.data.properties.map((x) => x.id),
              ]) ...[
                Pressable(
                  onTap: () => setState(() => _property = id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _property == id ? p.ink : p.surface,
                      borderRadius: BorderRadius.circular(Radii.pill),
                      border: Border.all(
                        color: _property == id ? p.ink : p.line,
                      ),
                    ),
                    child: Text(
                      id == null
                          ? l.allProperties
                          : ledger.property(id).name.of(ar),
                      style: context.text.labelMedium?.copyWith(
                        color: _property == id ? p.bg : p.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Insets.sm),
              ],
            ],
          ),
        ),
        const SizedBox(height: Insets.lg),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.income12m, style: context.text.bodySmall),
              const SizedBox(height: 2),
              CountUp(
                key: ValueKey(_property),
                value: year,
                format: (v) => Fmt.sar(context, v.round()),
                style: context.text.displaySmall,
              ),
              Text(
                l.bestMonth(Fmt.month(context, best.month)),
                style: context.text.bodySmall?.copyWith(color: p.paid),
              ),
              const SizedBox(height: Insets.xl),
              SizedBox(
                height: 200,
                child: BarChart(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  BarChartData(
                    maxY: maxY,
                    alignment: BarChartAlignment.spaceBetween,
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 4,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: p.line,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 26,
                          getTitlesWidget: (v, meta) {
                            final i = v.toInt();
                            if ((months.length - 1 - i) % 2 != 0) {
                              return const SizedBox();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                Fmt.monthShort(context, months[i].month),
                                style: context.text.labelSmall?.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => p.raised,
                        tooltipBorderRadius: BorderRadius.circular(10),
                        getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                          '${Fmt.month(context, months[group.x].month)}\n',
                          context.text.labelSmall!,
                          children: [
                            TextSpan(
                              text: Fmt.sar(context, rod.toY.round()),
                              style: context.text.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    barGroups: [
                      for (final (i, m) in months.indexed)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: _grown ? m.amount.toDouble() : 0,
                              width: 14,
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: i == months.length - 1
                                    ? [p.glow.withValues(alpha: 0.7), p.glow]
                                    : [
                                        p.cobalt.withValues(alpha: 0.55),
                                        p.cobalt,
                                      ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).entrance(0),
        const SizedBox(height: Insets.xl),
        SectionTitle(l.byProperty),
        Panel(
          child: Column(
            children: [
              for (final (i, prop) in ledger.data.properties.indexed) ...[
                if (i > 0) const SizedBox(height: Insets.lg),
                _Share(
                  label: prop.name.of(ar),
                  amount: ledger
                      .monthlyIncome(propertyId: prop.id)
                      .fold(0, (a, m) => a + m.amount),
                  total: allYear,
                  color: [p.cobalt, p.glow, p.paid][i % 3],
                ),
              ],
            ],
          ),
        ).entrance(1),
        const SizedBox(height: Insets.xl),
        SectionTitle(l.occupancyByProperty),
        Row(
          children: [
            for (final (i, prop) in ledger.data.properties.indexed) ...[
              if (i > 0) const SizedBox(width: Insets.sm),
              Expanded(
                child: Panel(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: ledger.occupancy(prop.id),
                          ),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (context, v, _) => CircularProgressIndicator(
                            value: v,
                            strokeWidth: 6,
                            strokeCap: StrokeCap.round,
                            backgroundColor: p.raised,
                            color: p.paid,
                          ),
                        ),
                      ),
                      const SizedBox(height: Insets.sm),
                      Text(
                        '${(ledger.occupancy(prop.id) * 100).round()}%',
                        style: context.text.titleLarge,
                      ),
                      Text(
                        prop.name.of(ar),
                        style: context.text.labelSmall,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ).entrance(2),
        const SizedBox(height: Insets.xl),
        SectionTitle(l.methodsMix),
        _MethodsMix(
          installments: ledger.data.installments
              .where((i) => i.isPaid)
              .toList(),
        ).entrance(3),
      ],
    );
  }
}

class _Share extends StatelessWidget {
  const _Share({
    required this.label,
    required this.amount,
    required this.total,
    required this.color,
  });

  final String label;
  final int amount;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final f = total == 0 ? 0.0 : amount / total;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: context.text.titleSmall)),
            Text(Fmt.compact(context, amount), style: context.text.titleSmall),
            const SizedBox(width: Insets.sm),
            SizedBox(
              width: 42,
              child: Text(
                '${(f * 100).round()}%',
                textAlign: TextAlign.end,
                style: context.text.labelSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: f),
            duration: const Duration(milliseconds: 1100),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => LinearProgressIndicator(
              value: v,
              minHeight: 8,
              color: color,
              backgroundColor: p.raised,
            ),
          ),
        ),
      ],
    );
  }
}

class _MethodsMix extends StatelessWidget {
  const _MethodsMix({required this.installments});

  final List<Installment> installments;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final counts = <PayMethod, int>{};
    for (final i in installments) {
      counts[i.method!] = (counts[i.method!] ?? 0) + i.amount;
    }
    final total = counts.values.fold(0, (a, b) => a + b);
    final colors = [p.cobalt, p.glow, p.paid, const Color(0xFFB56CF0), p.muted];
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    String name(PayMethod m) => switch (m) {
      PayMethod.mada => l.methodMada,
      PayMethod.applePay => 'Apple Pay',
      PayMethod.stcPay => 'STC Pay',
      PayMethod.bankTransfer => l.methodBank,
      PayMethod.cash => l.methodCash,
    };
    return Panel(
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 34,
                sections: [
                  for (final (i, e) in entries.indexed)
                    PieChartSectionData(
                      value: e.value.toDouble(),
                      color: colors[i % colors.length],
                      radius: 22,
                      showTitle: false,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Insets.lg),
          Expanded(
            child: Column(
              children: [
                for (final (i, e) in entries.indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: colors[i % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            name(e.key),
                            style: context.text.labelMedium,
                          ),
                        ),
                        Text(
                          '${(e.value / total * 100).round()}%',
                          style: context.text.labelMedium,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
