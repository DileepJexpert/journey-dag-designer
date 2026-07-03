@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/data/seed_data.dart';
import 'package:dag_core/dag_core.dart';
import 'package:journey_dag_designer/domain/services/dag_validator.dart';

/// The payments config showcase (third channel, shown not run): the
/// payment-execution journey authored in the Designer must be a VALID DAG over
/// the registered `payments` capability, and its committed contract must
/// round-trip byte-for-byte like the loan contract.
void main() {
  const validator = DagValidator();
  const serializer = ConfigSerializer();

  test('payment-execution journey validates against the capability registry', () {
    final result = validator.validate(seedPaymentDag(), capabilities: seedCapabilities);
    expect(result.isValid, isTrue, reason: result.errors.toString());
  });

  test('the rail branch routes IMPS / UPI_MANDATE / BILL_PAY', () {
    final dag = seedPaymentDag();
    final route = dag.nodeOrNull('n_route')!;
    final exprs = serializer.toJson(dag, key: 'payment-execution')['nodes']
        .firstWhere((n) => n['id'] == 'n_route')['arms']
        .map((a) => a['when'])
        .toList();
    expect(route, isNotNull);
    expect(exprs, containsAll([
      "context.request.rail == 'IMPS'",
      "context.request.rail == 'UPI_MANDATE'",
      "context.request.rail == 'BILL_PAY'",
    ]));
  });

  test('committed payment contract round-trips byte-for-byte', () {
    final file = contractFile(paymentContractPath); // dag_core owns contract/
    expect(file.existsSync(), isTrue,
        reason: 'run `dart run tool/emit_contract.dart`');
    final raw = file.readAsStringSync();
    final dag = serializer.fromJsonString(raw);
    final reEmitted = '${serializer.toJsonString(dag, key: 'payment-execution')}\n';
    expect(reEmitted, raw);
  });
}
