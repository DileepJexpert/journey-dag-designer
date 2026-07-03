/// The SHARED CONTRACT fixtures (build doc §2, Schema Lock): keys, committed
/// file locations and the canonical serializer output for each contract. A
/// change here is a contract change — the lock test here AND the engine's
/// loader test must re-lock together, never drift apart silently.
library;

import 'dart:io';

import '../domain/services/config_serializer.dart';
import 'canonical_dags.dart';

/// The journey key carried in the canonical config.
const contractKey = 'loan-origination';

/// Committed contract fixture, relative to the dag_core package root.
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

/// Resolve a contract fixture on disk regardless of which PACKAGE the test
/// runs from: dag_core's own tests see `contract/...`; the apps (one directory
/// tree over) see it via the workspace-relative path.
File contractFile(String packageRelativePath) {
  final local = File(packageRelativePath);
  if (local.existsSync()) {
    return local;
  }
  return File('../../packages/dag_core/$packageRelativePath');
}
