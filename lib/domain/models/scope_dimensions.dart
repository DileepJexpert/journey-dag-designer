/// Config scoping dimensions for the IDFC estate (build doc §0).
///
/// A journey is scoped/bound by (businessLine x product x partner). There is NO
/// `tenant` and NO `cell` in this domain — do not introduce them. `domain` /
/// `businessUnit` is an OWNERSHIP label only (who owns a capability), never a
/// scope axis.
///
/// These are intentionally value types over `String` rather than closed `enum`s:
/// the real set of business lines, products and partners lives in backend config
/// and is fetched at runtime (`GET /business-lines`, `/products`, `/partners`).
/// Hard-coding them would re-introduce the "new partner = code change" coupling
/// this whole tool exists to remove.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'scope_dimensions.freezed.dart';

/// The routing dimension the SFDC ingress edge already uses (backend field
/// `type`): PERSONAL_LOAN, LAP, BUSINESS_LOAN, COMMERCIAL, ...
@freezed
class BusinessLine with _$BusinessLine {
  const factory BusinessLine({
    /// Stable code, equal to the backend `type` value (e.g. "PERSONAL_LOAN").
    required String code,
    required String label,
  }) = _BusinessLine;
}

/// The loan product (e.g. ACEPL, LAS).
@freezed
class Product with _$Product {
  const factory Product({
    required String code,
    required String label,
  }) = _Product;
}

/// External origination source — CONFIG, not a service (CRED, FLIPKART, GROWW,
/// EBC, ASIRVAD, or none/assisted). Onboarding a partner is a config row, never
/// a new service.
@freezed
class Partner with _$Partner {
  const factory Partner({
    required String code,
    required String label,
  }) = _Partner;
}
