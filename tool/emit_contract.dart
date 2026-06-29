/// Emits the SHARED CONTRACT fixture: the canonical loan-origination journey,
/// serialized by the real [ConfigSerializer], written to
/// `contract/loan-origination.journey.json`.
///
/// This file is the authoritative DAG config schema artifact — the EXACT JSON
/// the DAG Designer emits and the orchestration engine must load (build doc §2,
/// Schema Lock). Regenerate after an intentional, co-locked schema change:
///
///   dart run tool/emit_contract.dart
///
/// A change here is a contract change: it will turn the round-trip test red on
/// the frontend and the loader test red on the engine until both sides re-lock.
library;

import 'dart:io';

import 'package:journey_dag_designer/data/seed_data.dart';
import 'package:journey_dag_designer/domain/services/config_serializer.dart';

/// The journey key carried in the canonical config.
const contractKey = 'loan-origination';

/// Path of the committed contract fixture, relative to the repo root.
const contractPath = 'contract/loan-origination.journey.json';

/// The exact bytes (string) of the contract: serializer output + trailing LF.
String contractContents() {
  const serializer = ConfigSerializer();
  return '${serializer.toJsonString(seedLoanDag(), key: contractKey)}\n';
}

void main() {
  final file = File(contractPath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(contractContents());
  stdout.writeln('Wrote $contractPath');
}
