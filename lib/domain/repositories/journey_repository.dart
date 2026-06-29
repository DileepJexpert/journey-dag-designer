/// Abstract journey registry repository (build doc §1.3, §9). The app depends on
/// this interface; an `HttpJourneyRepository` (dio) talks to the registry API and
/// a `MockJourneyRepository` (in-memory, seeded) backs tests and lets the app run
/// before the backend exists. Swap via a Riverpod override / --dart-define flag.
library;

import '../models/dag.dart';
import '../models/journey.dart';
import '../models/validation.dart';

abstract interface class JourneyRepository {
  Future<List<Journey>> listJourneys({
    String? businessLine,
    String? product,
    String? partner,
  });

  Future<Journey> getJourney(String id);

  Future<Journey> createJourney({
    required String key,
    required String name,
    String? businessLine,
    String? product,
    String? partner,
  });

  /// Full DAG config + layout for one version.
  Future<Dag> getVersionDag(String journeyId, int version);

  /// Create a new draft version from a DAG (POST .../versions).
  Future<JourneyVersion> createDraft(String journeyId, Dag dag, {String? note});

  /// Update the editable draft (PUT .../versions/{v}).
  Future<JourneyVersion> saveDraft(String journeyId, int version, Dag dag,
      {String? note});

  /// Server-side validation (mirror of [DagValidator]); authoritative.
  Future<ValidationResult> validateOnServer(String journeyId, int version);

  /// Maker submits the draft for approval.
  Future<JourneyVersion> submitForApproval(String journeyId, int version);

  /// Checker approves + publishes. Backend enforces author != approver (403).
  Future<JourneyVersion> approve(String journeyId, int version);

  /// Checker rejects with a comment.
  Future<JourneyVersion> reject(String journeyId, int version, String comment);
}
