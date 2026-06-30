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

/// The payments showcase journey (third channel; shown as config, not run live).
const paymentContractKey = 'payment-execution';
const paymentContractPath = 'contract/payment-execution.journey.json';

/// The two e-mandate journeys (BRD §8) over the Mandate capability.
const autopayContractKey = 'emandate-autopay-setup';
const autopayContractPath = 'contract/emandate-autopay-setup.journey.json';
const cancelContractKey = 'emandate-cancel';
const cancelContractPath = 'contract/emandate-cancel.journey.json';

/// The exact bytes (string) of the loan contract: serializer output + trailing LF.
String contractContents() {
  const serializer = ConfigSerializer();
  return '${serializer.toJsonString(seedLoanDag(), key: contractKey)}\n';
}

/// The exact bytes (string) of the payment contract.
String paymentContractContents() {
  const serializer = ConfigSerializer();
  return '${serializer.toJsonString(seedPaymentDag(), key: paymentContractKey)}\n';
}

String autopayContractContents() {
  const serializer = ConfigSerializer();
  return '${serializer.toJsonString(seedAutopaySetupDag(), key: autopayContractKey)}\n';
}

String cancelContractContents() {
  const serializer = ConfigSerializer();
  return '${serializer.toJsonString(seedCancelDag(), key: cancelContractKey)}\n';
}

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
