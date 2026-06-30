@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/domain/services/config_serializer.dart';

import '../../tool/emit_contract.dart';

/// Locks the frontend to the SHARED CONTRACT fixture
/// (`contract/loan-origination.journey.json`). If any of these fail after a
/// change, the schema drifted: regenerate with `dart run tool/emit_contract.dart`
/// ONLY as a deliberate, co-locked decision (the engine loader test must move in
/// lockstep) — never to paper over an accidental divergence.
void main() {
  const serializer = ConfigSerializer();
  final file = File(contractPath);

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
}
