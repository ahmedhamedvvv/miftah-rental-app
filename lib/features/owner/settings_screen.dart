import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/key_card.dart';
import '../shared/preferences_panel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PageScaffold(
      title: l.settings,
      padding: const EdgeInsets.fromLTRB(
        Insets.page,
        0,
        Insets.page,
        Insets.xl,
      ),
      children: [
        Panel(
          child: Row(
            children: [
              const AppMark(size: 52),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.officeNameValue, style: context.text.titleMedium),
                    Text(l.officeLicense, style: context.text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ).entrance(0),
        const SizedBox(height: Insets.lg),
        Panel(
          child: Column(
            children: [
              LabelValue(l.phone, Fmt.phone('+966112345678'), mono: true),
              LabelValue(l.city, l.riyadh),
              LabelValue(l.vatNumber, '310 1234 5678 0003', mono: true),
            ],
          ),
        ).entrance(1),
        const SizedBox(height: Insets.xl),
        SectionTitle(l.preferences),
        const PreferencesPanel().entrance(2),
        const SizedBox(height: Insets.xl),
        Center(
          child: Text(
            l.builtWith,
            style: context.text.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
