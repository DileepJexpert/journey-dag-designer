/// A scoping binding (build doc §8 "bindings", §0): which journey/version is
/// active for a given (businessLine x product x partner) tuple.
///
/// Onboarding a new partner or product = a new binding row -> NO new service.
/// That is the governance message this whole tool exists to demonstrate. There
/// is NO tenant and NO cell dimension here.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'binding.freezed.dart';

@freezed
class Binding with _$Binding {
  const factory Binding({
    required String businessLine,
    required String product,

    /// Partner code, or null for the unscoped/assisted (no-partner) default.
    String? partner,
    required String journeyId,
    required int version,
  }) = _Binding;
}
