import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/key_card.dart';
import '../../data/models.dart';
import '../../state/providers.dart';
import 'pay_screen.dart';

class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({
    super.key,
    required this.installmentId,
    this.justPaid = false,
  });

  final String installmentId;
  final bool justPaid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = context.palette;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final inst = ledger.data.installments.firstWhere(
      (i) => i.id == installmentId,
    );
    final unit = ledger.unitOfInstallment(inst);
    final property = ledger.property(unit.propertyId);
    final contract = ledger.contract(inst.contractId);
    final tenant = ledger.tenant(contract.tenantId);
    final vat = unit.isCommercial ? (inst.amount * vatRate).round() : 0;
    final d = justPaid ? 900 : 0;

    final receipt = [
      LabelValue(l.receiptNo, inst.reference ?? '-', mono: true),
      LabelValue(
        l.paidOn,
        inst.paidAt == null ? '-' : Fmt.dateTime(context, inst.paidAt!),
      ),
      LabelValue(
        l.method,
        inst.method == null ? '-' : methodLabel(l, inst.method!),
      ),
      LabelValue(l.tenant, tenant.name.of(ar)),
      LabelValue(l.unit, '${unit.number} · ${property.name.of(ar)}'),
      LabelValue(l.ejarContract, Fmt.ejar(contract.ejarNumber), mono: true),
      LabelValue(
        l.installmentLabel,
        l.installmentOf(inst.index + 1, contract.frequency.perYear),
      ),
      LabelValue(l.rent, Fmt.sar(context, inst.amount)),
      LabelValue(
        l.vat,
        unit.isCommercial ? Fmt.sar(context, vat) : l.vatExempt,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Insets.page,
            Insets.md,
            Insets.page,
            Insets.xl,
          ),
          children: [
            Row(children: [if (!justPaid) const RoundBack(), const Spacer()]),
            const SizedBox(height: Insets.md),
            Center(
              child: justPaid
                  ? const _UnlockBurst()
                  : IconTile(
                      icon: Icons.receipt_long_rounded,
                      size: 72,
                      color: p.paid,
                    ),
            ),
            const SizedBox(height: Insets.lg),
            Text(
              justPaid ? l.paymentDone : l.receipt,
              textAlign: TextAlign.center,
              style: context.text.headlineMedium,
            ).animate(delay: d.ms).fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 6),
            Text(
              justPaid ? l.paymentDoneBody : l.receiptBody,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(color: p.muted),
            ).animate(delay: (d + 100).ms).fadeIn(),
            const SizedBox(height: Insets.xl),
            _Ticket(
                  total: Fmt.sar(context, inst.amount + vat),
                  totalLabel: l.totalPaid,
                  children: receipt,
                )
                .animate(delay: (d + 200).ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.12, curve: Curves.easeOutCubic),
            const SizedBox(height: Insets.xl),
            PrimaryButton(
              label: l.backHome,
              onPressed: () => context.go(Routes.tenantHome),
            ).animate(delay: (d + 350).ms).fadeIn(),
            const SizedBox(height: Insets.md),
            GhostButton(
              label: l.copyReceipt,
              icon: Icons.copy_rounded,
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text:
                        '${l.appName} · ${l.receiptNo} ${inst.reference}\n'
                        '${Fmt.sar(context, inst.amount + vat)} · ${unit.number} ${property.name.of(ar)}',
                  ),
                );
                showToast(context, l.copied);
              },
            ).animate(delay: (d + 420).ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}

/// The key turns in a ring of light when a payment goes through.
class _UnlockBurst extends StatelessWidget {
  const _UnlockBurst();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 12; i++)
            Transform.rotate(
                  angle: i * pi / 6,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 4,
                      height: 14,
                      decoration: BoxDecoration(
                        color: p.glow,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                )
                .animate(delay: 650.ms)
                .fadeIn(duration: 150.ms)
                .scaleXY(
                  begin: 0.4,
                  end: 1,
                  duration: 450.ms,
                  curve: Curves.easeOutBack,
                )
                .then()
                .fadeOut(duration: 600.ms),
          Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [p.keyGradient[0], p.keyGradient[1]],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: p.cobalt.withValues(alpha: 0.5),
                      blurRadius: 40,
                    ),
                  ],
                ),
              )
              .animate()
              .scaleXY(
                begin: 0.3,
                end: 1,
                duration: 500.ms,
                curve: Curves.easeOutBack,
              )
              .then(delay: 150.ms)
              .tint(color: p.paid, end: 0.85, duration: 350.ms),
          const KeyMark(size: 54)
              .animate(delay: 250.ms)
              .fadeIn(duration: 200.ms)
              .rotate(
                begin: 0,
                end: 0.25,
                duration: 450.ms,
                curve: Curves.easeInOutBack,
              )
              .then()
              .swap(
                builder: (_, _) =>
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 54,
                    ).animate().scaleXY(
                      begin: 0.4,
                      end: 1,
                      duration: 300.ms,
                      curve: Curves.easeOutBack,
                    ),
              ),
        ],
      ),
    );
  }
}

/// Receipt card with a perforated tear line above the total.
class _Ticket extends StatelessWidget {
  const _Ticket({
    required this.children,
    required this.total,
    required this.totalLabel,
  });

  final List<Widget> children;
  final String total;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: p.line),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.lg,
              Insets.md,
              Insets.lg,
              Insets.sm,
            ),
            child: Column(children: children),
          ),
          SizedBox(
            height: 24,
            child: Row(
              children: [
                _Notch(p.bg, start: true),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (c.maxWidth / 10).floor(),
                        (_) => Container(width: 5, height: 1.5, color: p.line),
                      ),
                    ),
                  ),
                ),
                _Notch(p.bg, start: false),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.lg,
              Insets.sm,
              Insets.lg,
              Insets.lg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(totalLabel, style: context.text.titleMedium),
                ),
                Text(
                  total,
                  style: context.text.headlineSmall?.copyWith(color: p.paid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch(this.color, {required this.start});

  final Color color;
  final bool start;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadiusDirectional.horizontal(
          end: start ? const Radius.circular(12) : Radius.zero,
          start: start ? Radius.zero : const Radius.circular(12),
        ),
      ),
    );
  }
}
