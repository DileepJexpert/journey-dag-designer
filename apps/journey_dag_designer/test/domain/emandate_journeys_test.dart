@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/data/seed_data.dart';
import 'package:dag_core/dag_core.dart';
import 'package:journey_dag_designer/domain/services/dag_validator.dart';

/// The two e-mandate journeys (BRD §8) authored as §7 config over the registered
/// Mandate capability: both must be VALID DAGs and round-trip byte-for-byte like
/// the loan/payment contracts (the schema lock with the engine).
void main() {
  const validator = DagValidator();
  const serializer = ConfigSerializer();

  test('autopay-setup journey validates against the registry', () {
    final r = validator.validate(seedAutopaySetupDag(), capabilities: seedCapabilities);
    expect(r.isValid, isTrue, reason: r.errors.toString());
  });

  test('cancel journey validates (branch + mandatory default)', () {
    final r = validator.validate(seedCancelDag(), capabilities: seedCapabilities);
    expect(r.isValid, isTrue, reason: r.errors.toString());
  });

  test('both reference the mandate capability + real operations', () {
    final json = serializer.toJson(seedCancelDag(), key: 'emandate-cancel');
    final cancel = (json['nodes'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((n) => n['id'] == 'n_cancel');
    expect(cancel['capability'], 'mandate');
    expect(cancel['operation'], 'cancel');
  });

  test('committed e-mandate contracts round-trip byte-for-byte', () {
    for (final entry in {
      autopayContractPath: autopayContractKey,
      cancelContractPath: cancelContractKey,
    }.entries) {
      final raw = contractFile(entry.key).readAsStringSync(); // dag_core owns contract/
      final dag = serializer.fromJsonString(raw);
      expect('${serializer.toJsonString(dag, key: entry.value)}\n', raw,
          reason: entry.key);
    }
  });
}
