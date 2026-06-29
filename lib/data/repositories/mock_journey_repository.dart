/// In-memory, seeded [JourneyRepository] (build doc §9, §11.1). Lets the app run
/// end-to-end before the registry backend exists; also backs widget tests. Swap
/// for HttpJourneyRepository via a Riverpod override / --dart-define flag.
library;

import '../../domain/models/dag.dart';
import '../../domain/models/journey.dart';
import '../../domain/models/validation.dart';
import '../../domain/repositories/journey_repository.dart';
import '../../domain/services/dag_validator.dart';
import '../seed_data.dart';

class MockJourneyRepository implements JourneyRepository {
  MockJourneyRepository({DateTime? now, DagValidator? validator})
      : _validator = validator ?? const DagValidator() {
    final ts = now ?? DateTime.fromMillisecondsSinceEpoch(0);
    final loan = seedLoanJourney(ts);
    _journeys[loan.id] = loan;
    // The payments journey — third channel, shown as config (config-not-code).
    final payment = seedPaymentJourney(ts);
    _journeys[payment.id] = payment;
  }

  final DagValidator _validator;
  final Map<String, Journey> _journeys = {};
  int _seq = 1;

  @override
  Future<List<Journey>> listJourneys({
    String? businessLine,
    String? product,
    String? partner,
  }) async {
    return _journeys.values.where((j) {
      if (businessLine != null && j.businessLine != businessLine) return false;
      if (product != null && j.product != product) return false;
      if (partner != null && j.partner != partner) return false;
      return true;
    }).toList();
  }

  @override
  Future<Journey> getJourney(String id) async {
    final j = _journeys[id];
    if (j == null) throw StateError('No journey "$id"');
    return j;
  }

  @override
  Future<Journey> createJourney({
    required String key,
    required String name,
    String? businessLine,
    String? product,
    String? partner,
  }) async {
    final id = 'jr_${_seq++}';
    final journey = Journey(
      id: id,
      key: key,
      name: name,
      businessLine: businessLine,
      product: product,
      partner: partner,
    );
    _journeys[id] = journey;
    return journey;
  }

  @override
  Future<Dag> getVersionDag(String journeyId, int version) async {
    final j = await getJourney(journeyId);
    final v = j.versions.firstWhere((v) => v.version == version,
        orElse: () => throw StateError('No version $version'));
    return v.dag;
  }

  @override
  Future<JourneyVersion> createDraft(String journeyId, Dag dag,
      {String? note}) async {
    final j = await getJourney(journeyId);
    final nextVersion =
        j.versions.isEmpty ? 1 : j.versions.map((v) => v.version).reduce((a, b) => a > b ? a : b) + 1;
    final draft = JourneyVersion(
      version: nextVersion,
      status: ApprovalStatus.draft,
      dag: dag,
      authorId: 'maker-1',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      note: note,
    );
    _journeys[journeyId] = j.copyWith(versions: [...j.versions, draft]);
    return draft;
  }

  @override
  Future<JourneyVersion> saveDraft(String journeyId, int version, Dag dag,
      {String? note}) async {
    return _mutateVersion(journeyId, version, (v) => v.copyWith(dag: dag, note: note ?? v.note));
  }

  @override
  Future<ValidationResult> validateOnServer(String journeyId, int version) async {
    final dag = await getVersionDag(journeyId, version);
    // The mock mirrors the client validator (the real backend is authoritative).
    return _validator.validate(dag, capabilities: seedCapabilities);
  }

  @override
  Future<JourneyVersion> submitForApproval(String journeyId, int version) =>
      _mutateVersion(journeyId, version,
          (v) => v.copyWith(status: ApprovalStatus.pendingApproval));

  @override
  Future<JourneyVersion> approve(String journeyId, int version) =>
      _mutateVersion(journeyId, version, (v) {
        // Maker != checker (enforced by backend with 403). Mock approver differs.
        return v.copyWith(
          status: ApprovalStatus.published,
          approverId: 'checker-1',
        );
      }, publish: true);

  @override
  Future<JourneyVersion> reject(String journeyId, int version, String comment) =>
      _mutateVersion(journeyId, version,
          (v) => v.copyWith(status: ApprovalStatus.rejected, note: comment));

  Future<JourneyVersion> _mutateVersion(
    String journeyId,
    int version,
    JourneyVersion Function(JourneyVersion) f, {
    bool publish = false,
  }) async {
    final j = await getJourney(journeyId);
    final versions = [
      for (final v in j.versions) if (v.version == version) f(v) else v,
    ];
    final updated = versions.firstWhere((v) => v.version == version);
    _journeys[journeyId] = j.copyWith(
      versions: versions,
      activeVersion: publish ? version : j.activeVersion,
    );
    return updated;
  }
}
