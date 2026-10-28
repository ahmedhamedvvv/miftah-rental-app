import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/labels.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

/// Commercial leases carry 15% VAT; residential rent is exempt in Saudi Arabia.
const vatRate = 0.15;

class PayScreen extends ConsumerStatefulWidget {
  const PayScreen({super.key, required this.installmentId});

  final String installmentId;

  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends ConsumerState<PayScreen> {
  PayMethod _method = PayMethod.mada;
  bool _busy = false;

  Future<void> _pay() async {
    setState(() => _busy = true);
    HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    ref.read(portfolioProvider.notifier).pay(widget.installmentId, _method);
    context.pushReplacement('${Routes.receipt(widget.installmentId)}?new=1');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final ledger = ref.watch(ledgerProvider);
    final inst = ledger.data.installments.firstWhere(
      (i) => i.id == widget.installmentId,
    );
    final unit = ledger.unitOfInstallment(inst);
    final vat = unit.isCommercial ? (inst.amount * vatRate).round() : 0;
    final total = inst.amount + vat;
    final late = ledger.isLate(inst);

    return PageScaffold(
      title: l.payRent,
      subtitle: l.paySubtitle,
      bottom: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          Insets.page,
          0,
          Insets.page,
          Insets.lg,
        ),
        child: PrimaryButton(
          label: l.payAmount(Fmt.sar(context, total)),
          icon: Icons.lock_rounded,
          busy: _busy,
          onPressed: _pay,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        Insets.page,
        0,
        Insets.page,
        Insets.xl,
      ),
      children: [
        Panel(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.installmentN(inst.index + 1),
                          style: context.text.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        CountUp(
                          value: total,
                          format: (v) => Fmt.sar(context, v.round()),
                          style: context.text.displaySmall,
                        ),
                      ],
                    ),
                  ),
                  Pill(
                    late
                        ? l.statusLate
                        : l.dueOn(Fmt.shortDate(context, inst.due)),
                    color: late ? p.late : p.soon,
                  ),
                ],
              ),
              const SizedBox(height: Insets.md),
              const Divider(),
              const SizedBox(height: Insets.sm),
              LabelValue(l.rent, Fmt.sar(context, inst.amount)),
              LabelValue(
                l.vat,
                unit.isCommercial ? Fmt.sar(context, vat) : l.vatExempt,
                valueColor: unit.isCommercial ? null : p.paid,
              ),
              LabelValue(
                l.unit,
                '${unitKindLabel(l, unit.kind)} ${unit.number}',
              ),
            ],
          ),
        ).entrance(0),
        const SizedBox(height: Insets.xl),
        SectionTitle(l.payWith),
        for (final (i, m) in const [
          PayMethod.mada,
          PayMethod.applePay,
          PayMethod.stcPay,
          PayMethod.bankTransfer,
        ].indexed) ...[
          _MethodTile(
            method: m,
            selected: _method == m,
            onTap: () => setState(() => _method = m),
          ).entrance(1 + i),
          const SizedBox(height: Insets.sm),
        ],
        const SizedBox(height: Insets.md),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(
              key: ValueKey(_method),
              child: _MethodDetails(method: _method),
            ),
          ),
        ),
        const SizedBox(height: Insets.lg),
        Row(
          children: [
            Icon(Icons.shield_rounded, size: 16, color: p.muted),
            const SizedBox(width: 6),
            Expanded(child: Text(l.secureNote, style: context.text.bodySmall)),
          ],
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PayMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: selected ? p.cobaltSoft : p.surface,
          borderRadius: BorderRadius.circular(Radii.control),
          border: Border.all(
            color: selected ? p.cobalt : p.line,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            PayLogo(method),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                methodLabel(l, method),
                style: context.text.titleSmall,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? p.cobalt : Colors.transparent,
                border: Border.all(
                  color: selected ? p.cobalt : p.line,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Typographic marks for each payment method, drawn rather than copied from
/// brand assets.
class PayLogo extends StatelessWidget {
  const PayLogo(this.method, {super.key});

  final PayMethod method;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Widget child) = switch (method) {
      PayMethod.mada => (
        Colors.white,
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'mada',
                style: TextStyle(
                  color: Color(0xFF1B1F3B),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
      PayMethod.applePay => (
        Colors.black,
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.apple, color: Colors.white, size: 16),
            Text(
              'Pay',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      PayMethod.stcPay => (
        const Color(0xFF4F008C),
        const Text(
          'stc pay',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
          ),
        ),
      ),
      PayMethod.bankTransfer => (
        context.palette.raised,
        Icon(
          Icons.account_balance_rounded,
          size: 18,
          color: context.palette.ink,
        ),
      ),
      PayMethod.cash => (
        context.palette.raised,
        Icon(Icons.payments_rounded, size: 18, color: context.palette.ink),
      ),
    };
    return Container(
      width: 58,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: context.palette.line),
      ),
      alignment: Alignment.center,
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }
}

class _MethodDetails extends StatelessWidget {
  const _MethodDetails({required this.method});

  final PayMethod method;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    switch (method) {
      case PayMethod.mada:
        return Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.card),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1F2A44), Color(0xFF0E1424)],
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.sim_card_rounded,
                      color: Color(0xFFE6C77A),
                      size: 28,
                    ),
                    Spacer(),
                    Text(
                      'mada',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.lg),
                const Text(
                  '4847  ••••  ••••  2291',
                  style: TextStyle(
                    fontFamily: AppTheme.mono,
                    fontSize: 18,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: Insets.md),
                Row(
                  children: [
                    Text(
                      'ABDULLAH AL-SHEHRI',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '08/29',
                      style: TextStyle(
                        fontFamily: AppTheme.mono,
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      case PayMethod.applePay:
        return _Note(icon: Icons.fingerprint_rounded, text: l.applePayNote);
      case PayMethod.stcPay:
        return _Note(
          icon: Icons.phone_iphone_rounded,
          text: l.stcPayNote(Fmt.phone('+966551234567')),
        );
      case PayMethod.bankTransfer:
      case PayMethod.cash:
        return Panel(
          color: p.raised,
          child: Column(
            children: [
              LabelValue(l.bankName, l.bankNameValue),
              LabelValue('IBAN', 'SA03 8000 0000 6080 1016 7519', mono: true),
              LabelValue(l.beneficiary, l.officeNameValue),
              const SizedBox(height: Insets.sm),
              Text(l.bankNote, style: context.text.bodySmall),
            ],
          ),
        );
    }
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Panel(
      color: context.palette.raised,
      child: Row(
        children: [
          IconTile(icon: icon),
          const SizedBox(width: Insets.md),
          Expanded(child: Text(text, style: context.text.bodyMedium)),
        ],
      ),
    );
  }
}
