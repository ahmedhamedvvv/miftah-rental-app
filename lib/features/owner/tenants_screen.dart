import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../state/providers.dart';

class TenantsScreen extends ConsumerStatefulWidget {
  const TenantsScreen({super.key});

  @override
  ConsumerState<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends ConsumerState<TenantsScreen> {
  final _q = TextEditingController();

  @override
  void initState() {
    super.initState();
    _q.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ar = context.arabic;
    final ledger = ref.watch(ledgerProvider);
    final rows = <(Tenant, Unit, UnitStatus)>[];
    for (final c in ledger.data.contracts.where(
      (c) => c.isActiveOn(ledger.today),
    )) {
      rows.add((
        ledger.tenant(c.tenantId),
        ledger.unit(c.unitId),
        ledger.statusOf(c.unitId),
      ));
    }
    final q = _q.text.trim().toLowerCase();
    final shown =
        rows.where((r) {
          if (q.isEmpty) return true;
          return r.$1.name.ar.contains(q) ||
              r.$1.name.en.toLowerCase().contains(q) ||
              r.$2.number.toLowerCase().contains(q);
        }).toList()..sort(
          (a, b) => a.$3.index == b.$3.index
              ? a.$2.number.compareTo(b.$2.number)
              : b.$3.index.compareTo(a.$3.index),
        );

    return PageScaffold(
      title: l.tenants,
      subtitle: l.tenantsSubtitle(rows.length),
      padding: const EdgeInsets.fromLTRB(
        Insets.page,
        0,
        Insets.page,
        Insets.xl,
      ),
      children: [
        TextField(
          controller: _q,
          decoration: InputDecoration(
            hintText: l.searchTenants,
            prefixIcon: const Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: Insets.lg),
        for (final (i, r) in shown.indexed)
          Padding(
            key: ValueKey(r.$1.id),
            padding: const EdgeInsets.only(bottom: Insets.sm),
            child: Panel(
              onTap: () => context.push(Routes.unit(r.$2.id)),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Avatar(tenant: r.$1, size: 42),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.$1.name.of(ar), style: context.text.titleSmall),
                        Text(
                          '${r.$2.number} · ${ledger.property(r.$2.propertyId).name.of(ar)}',
                          style: context.text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  StatusPill(r.$3),
                ],
              ),
            ).entrance(i.clamp(0, 12)),
          ),
      ],
    );
  }
}
