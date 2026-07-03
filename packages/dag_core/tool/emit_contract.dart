/// Emits the SHARED CONTRACT fixtures: the canonical journeys, serialized by
/// the real [ConfigSerializer], written to `contract/` (build doc §2, Schema
/// Lock). Regenerate after an intentional, co-locked schema change ONLY:
///
///   cd packages/dag_core && dart run tool/emit_contract.dart
///
/// A change here is a contract change: it turns the lock test red here and the
/// engine's loader test red until both sides re-lock — never regenerate to
/// paper over an accidental divergence.
library;

import 'dart:io';

import 'package:dag_core/fixtures/contract_fixtures.dart';

void main() {
  _write(contractPath, contractContents());
  _write(paymentContractPath, paymentContractContents());
  _write(autopayContractPath, autopayContractContents());
  _write(cancelContractPath, cancelContractContents());
}

void _write(String path, String contents) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(contents);
  stdout.writeln('Wrote $path');
}
