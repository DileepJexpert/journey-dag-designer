/// A registered capability — a palette item (build doc §5, §13.1). Fetched from
/// the backend registry (`GET /capabilities`); the editor palette is populated
/// ONLY from this list, so a capability that is not registered cannot be placed
/// on the canvas (the config-vs-code boundary made physical).
///
/// `key` MUST equal the backend capability module name (e.g. "kyc", "bureau",
/// "scoring", "customer-party", "lending-origination"). The DAG config's
/// `capabilityKey` references this.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'capability.freezed.dart';

@freezed
class CapabilityPort with _$CapabilityPort {
  const factory CapabilityPort({
    required String name,
    String? description,
  }) = _CapabilityPort;
}

@freezed
class Capability with _$Capability {
  const Capability._();

  const factory Capability({
    required String key,
    required String name,

    /// Business area that OWNS this capability — an ownership label only, NOT a
    /// scope axis (build doc §0): e.g. "Lending", "KYC", "Payments".
    String? domain,
    @Default(<CapabilityPort>[]) List<CapabilityPort> ports,

    /// Money/booking nodes (e.g. lending-origination) MUST declare a
    /// compensation in any DAG that uses them — enforced by [DagValidator].
    @Default(false) bool isMoneyOrBookingNode,
  }) = _Capability;
}
