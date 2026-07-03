/// Journey + version aggregate (build doc §5).
///
/// A [Journey] holds an immutable list of published [JourneyVersion]s plus at
/// most one editable draft. Scoping fields (businessLine/product/partner) are
/// optional: null = a global template, refined by [Binding]s. There is NO
/// tenant field.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dag_core/dag_core.dart';

part 'journey.freezed.dart';

/// Maker-checker lifecycle (build doc §8): draft -> pendingApproval ->
/// (approved -> published) | rejected.
enum ApprovalStatus { draft, pendingApproval, approved, published, rejected }

@freezed
class JourneyVersion with _$JourneyVersion {
  const factory JourneyVersion({
    required int version,
    required ApprovalStatus status,
    required Dag dag,
    required String authorId,

    /// Set once a checker acts. Maker != checker: [approverId] must differ from
    /// [authorId] — enforced in UI (RoleGate) AND backend (403).
    String? approverId,
    required DateTime updatedAt,
    String? note,
  }) = _JourneyVersion;
}

@freezed
class Journey with _$Journey {
  const Journey._();

  const factory Journey({
    required String id,
    required String key,
    required String name,

    // Scoping (build doc §0) — null = global template. NO tenant.
    String? businessLine,
    String? product,
    String? partner,
    @Default(<JourneyVersion>[]) List<JourneyVersion> versions,

    /// The currently published version number serving new runs, if any.
    int? activeVersion,
  }) = _Journey;

  JourneyVersion? get draft {
    for (final v in versions) {
      if (v.status == ApprovalStatus.draft ||
          v.status == ApprovalStatus.pendingApproval) {
        return v;
      }
    }
    return null;
  }

  JourneyVersion? get active {
    if (activeVersion == null) return null;
    for (final v in versions) {
      if (v.version == activeVersion) return v;
    }
    return null;
  }
}
