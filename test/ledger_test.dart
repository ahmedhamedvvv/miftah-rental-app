import 'package:flutter_test/flutter_test.dart';
import 'package:miftah/data/models.dart';
import 'package:miftah/data/seed.dart';
import 'package:miftah/domain/ledger.dart';

void main() {
  final today = DateTime(2026, 10, 28, 10);
  final data = buildSeed(today);
  final ledger = Ledger(data, today);

  test('seed builds 72 units across three properties', () {
    expect(data.properties, hasLength(3));
    expect(data.units, hasLength(72));
  });

  test('the demo tenant owes the next semi-annual payment in 34 days', () {
    final c = ledger.contractOfTenant(data.meTenantId)!;
    expect(c.frequency, PayFrequency.semiAnnual);
    final next = ledger.nextDue(c.id)!;
    expect(ledger.daysUntil(next.due), 34);
    expect(next.amount, c.annualRent ~/ 2);
  });

  test('every unit has one status and vacant units match the seed', () {
    final counts = ledger.statusCounts();
    expect(counts.values.fold(0, (a, b) => a + b), 72);
    expect(counts[UnitStatus.vacant], 7);
    expect(counts[UnitStatus.late], 6);
  });

  test('overdue installments are unpaid and past due', () {
    for (final i in ledger.overdue()) {
      expect(i.isPaid, isFalse);
      expect(i.due.isBefore(today), isTrue);
    }
  });

  test('reports cover twelve months with income every month', () {
    final months = ledger.monthlyIncome();
    expect(months, hasLength(12));
    expect(months.where((m) => m.amount > 0), isNotEmpty);
  });

  test('portfolio survives a JSON round trip', () {
    final back = Portfolio.fromJson(data.toJson());
    expect(back.units.length, data.units.length);
    expect(back.installments.length, data.installments.length);
    expect(back.tickets.first.description.en, data.tickets.first.description.en);
  });
}
