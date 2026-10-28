import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../state/providers.dart';
import '../shared/preferences_panel.dart';

class LeaseScreen extends ConsumerWidget {
  const LeaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final lease = ref.watch(myLeaseProvider);
    final ledger = ref.watch(ledgerProvider);
    final c = lease.contract;
    final total = c.end.difference(c.start).inDays;
    final gone = ledger.today.difference(c.start).inDays.clamp(0, total);
    final left = ledger.daysUntil(c.end);

    return PageScaffold(
      title: l.myLease,
      subtitle: l.leaseSubtitle,
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconTile(icon: Icons.verified_user_rounded, color: p.paid),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.ejarRegistered, style: context.text.titleSmall),
                        Text(
                          Fmt.ejar(c.ejarNumber),
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            fontFamily: AppTheme.mono,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.xl),
              Row(
                children: [
                  Text(
                    Fmt.shortDate(context, c.start),
                    style: context.text.labelSmall,
                  ),
                  const Spacer(),
                  Text(
                    l.daysLeftInLease(left),
                    style: context.text.labelMedium?.copyWith(color: p.cobalt),
                  ),
                  const Spacer(),
                  Text(
                    Fmt.shortDate(context, c.end),
                    style: context.text.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: Insets.sm),
              LayoutBuilder(
                builder: (context, box) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: gone / total),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, _) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: p.raised,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          height: 8,
                          width: box.maxWidth * v,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [p.cobalt, p.glow],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ).entrance(0),
        const SizedBox(height: Insets.lg),
        Panel(
          child: Column(
            children: [
              LabelValue(l.tenant, lease.tenant.name.of(ar)),
              LabelValue(l.nationalId, lease.tenant.maskedId, mono: true),
              LabelValue(
                l.unit,
                '${unitKindLabel(l, lease.unit.kind)} ${lease.unit.number}',
              ),
              LabelValue(
                l.property,
                '${lease.property.name.of(ar)} · ${lease.property.district.of(ar)}',
              ),
              LabelValue(
                l.leaseType,
                lease.unit.isCommercial ? l.commercial : l.residential,
              ),
              LabelValue(l.annualRent, Fmt.sar(context, c.annualRent)),
              LabelValue(
                l.paymentPlan,
                '${frequencyLabel(l, c.frequency)} · ${Fmt.sar(context, c.installmentAmount)}',
              ),
              LabelValue(
                l.securityDeposit,
                Fmt.sar(context, (c.annualRent * 0.05).round()),
              ),
            ],
          ),
        ).entrance(1),
        const SizedBox(height: Insets.xl),
        SectionTitle(l.schedule),
        Panel(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.lg,
            vertical: Insets.sm,
          ),
          child: Column(
            children: [
              for (final i in lease.installments)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        i.isPaid
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 20,
                        color: i.isPaid
                            ? p.paid
                            : (ledger.isLate(i) ? p.late : p.muted),
                      ),
                      const SizedBox(width: Insets.md),
                      Expanded(
                        child: Text(
                          Fmt.date(context, i.due),
                          style: context.text.bodyMedium,
                        ),
                      ),
                      Text(
                        Fmt.sar(context, i.amount),
                        style: context.text.titleSmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ).entrance(2),
        const SizedBox(height: Insets.xl),
        Panel(
          color: p.cobaltSoft,
          borderColor: p.cobalt.withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.renewalRequested ? l.renewalSent : l.renewTitle,
                style: context.text.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                c.renewalRequested ? l.renewalSentBody : l.renewBody,
                style: context.text.bodySmall,
              ),
              if (!c.renewalRequested) ...[
                const SizedBox(height: Insets.md),
                PrimaryButton(
                  label: l.requestRenewal,
                  icon: Icons.autorenew_rounded,
                  onPressed: () {
                    ref.read(portfolioProvider.notifier).requestRenewal(c.id);
                    showToast(context, l.renewalSent);
                  },
                ),
              ],
            ],
          ),
        ).entrance(3),
        const SizedBox(height: Insets.xl),
        SectionTitle(l.preferences),
        const PreferencesPanel().entrance(4),
      ],
    );
  }
}
