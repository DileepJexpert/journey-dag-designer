@TestOn('vm')
library;

import 'package:dag_core/dag_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Locks dag_core to the SHARED CONTRACT fixtures (`contract/*.journey.json`).
/// If any of these fail after a change, the schema drifted: regenerate with
/// `dart run tool/emit_contract.dart` ONLY as a deliberate, co-locked decision
/// (the engine loader test must move in lockstep) — never to paper over an
/// accidental divergence. Relocated from the Designer app in the dag_core
/// extraction (D16) — the assertions and the fixture bytes are unchanged.
void main() {
  const serializer = ConfigSerializer();
  final file = contractFile(contractPath);

  test('the contract fixture exists', () {
    expect(file.existsSync(), isTrue,
        reason: 'run `dart run tool/emit_contract.dart`');
  });

  test('canonical journey still emits the committed contract (no code drift)', () {
    expect(file.readAsStringSync(), contractContents());
  });

  test('ConfigSerializer round-trips the contract byte-for-byte', () {
    final raw = file.readAsStringSync();
    final dag = serializer.fromJsonString(raw);
    final reEmitted = '${serializer.toJsonString(dag, key: contractKey)}\n';
    expect(reEmitted, raw);
  });

  test('contract carries the real backend capability keys (not the doc typo)', () {
    final raw = file.readAsStringSync();
    expect(raw, contains('"capability": "scoring"'));
    expect(raw, isNot(contains('scoring-decisioning')));
    for (final key in const [
      'customer-party',
      'kyc',
      'bureau',
      'scoring',
      'lending-origination',
    ]) {
      expect(raw, contains('"capability": "$key"'), reason: key);
    }
  });

  test('every companion contract still emits its committed bytes', () {
    expect(contractFile(paymentContractPath).readAsStringSync(),
        paymentContractContents());
    expect(contractFile(autopayContractPath).readAsStringSync(),
        autopayContractContents());
    expect(contractFile(cancelContractPath).readAsStringSync(),
        cancelContractContents());
  });

  // ---- A6: schemaVersion on the wire, checked at load ----------------------

  test('A6: the contract carries schemaVersion on the wire', () {
    expect(file.readAsStringSync(),
        contains('"schemaVersion": ${ConfigSerializer.schemaVersion}'));
  });

  test(
      'A6: a config stamped with an UNKNOWN schemaVersion refuses to load '
      '(fail closed — never half-parse a future grammar)', () {
    final json = serializer.toJson(seedLoanDag(), key: contractKey);
    json['schemaVersion'] = ConfigSerializer.schemaVersion + 1;
    expect(() => serializer.fromJson(json), throwsFormatException);
  });

  test(
      'A6: a config with NO stamp is pre-A6 legacy and loads (published '
      'configs already in registries keep running)', () {
    final json = serializer.toJson(seedLoanDag(), key: contractKey)
      ..remove('schemaVersion');
    expect(serializer.fromJson(json).nodeOrNull('n_customer'), isNotNull);
  });
}
