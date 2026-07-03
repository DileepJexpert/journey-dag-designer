/// In-memory, seeded [JourneyRepository] (build doc §9, §11.1). Lets the app run
/// end-to-end without the registry; also backs widget tests. MIRRORS the
/// registry's server-side rules — the real actor identity stamps every
/// mutation, the author may not approve/reject their own version
/// ([ForbiddenFailure], the 403), one editable draft per journey
/// ([ConflictFailure], the 409), and submit is validation-gated
/// ([ValidationFailure] with issues, the 422) — so switching
/// `Env.useMockBackend` changes transport, never the rules.
library;

import 'package:dag_core/dag_core.dart';
import '../../domain/models/journey.dart';
import '../../domain/repositories/journey_repository.dart';
import '../../domain/services/dag_validator.dart';
import '../demo_seed_data.dart';
import '../seed_data.dart';

class MockJourneyRepository implements JourneyRepository {
  MockJourneyRepository(
      {DateTime? now, DagValidator? validator, String Function()? actor})
      : _validator = validator ?? const DagValidator(),
        _actor = actor ?? (() => 'maker-1') {
    final ts = now ?? DateTime.fromMillisecondsSinceEpoch(0);
    final loan = seedLoanJourney(ts);
    _journeys[loan.id] = loan;
    // The payments journey — third channel, shown as config (config-not-code).
    final payment = seedPaymentJourney(ts);
    _journeys[payment.id] = payment;
    // The two e-mandate journeys (BRD §8) — emandate-management consolidated into
    // the Mandate capability + journey JSON.
    final autopay = seedAutopaySetupJourney(ts);
    _journeys[autopay.id] = autopay;
    final cancel = seedCancelJourney(ts);
    _journeys[cancel.id] = cancel;
    // Legacy-patterns demo: two runnable demo journeys (brand-as-config,
    // per-record LWD) + two REFERENCE drafts (drawn, not built — honesty
    // slide; the file/SFTP edge and foreach execution are census-gated).
    for (final demo in [
      seedDeviceFinancingJourney(ts),
      seedEmployeeLwdJourney(ts),
      seedReferenceFileBatchJourney(ts),
      seedReferenceSyncReadJourney(ts),
    ]) {
      _journeys[demo.id] = demo;
    }
  }

  final DagValidator _validator;
  final String Function() _actor;
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
    if (j == null) throw const NotFoundFailure('No such journey');
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
        orElse: () => throw const NotFoundFailure('No such version'));
    return v.dag;
  }

  @override
  Future<JourneyVersion> createDraft(String journeyId, Dag dag,
      {String? note}) async {
    final j = await getJourney(journeyId);
    // Server rule: at most ONE editable (draft/pending) version per journey.
    if (j.draft != null) {
      throw ConflictFailure(
          'journey already has an editable version (v${j.draft!.version})');
    }
    final nextVersion =
        j.versions.isEmpty ? 1 : j.versions.map((v) => v.version).reduce((a, b) => a > b ? a : b) + 1;
    final draft = JourneyVersion(
      version: nextVersion,
      status: ApprovalStatus.draft,
      dag: dag,
      authorId: _actor(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      note: note,
    );
    _journeys[journeyId] = j.copyWith(versions: [...j.versions, draft]);
    return draft;
  }

  @override
  Future<JourneyVersion> saveDraft(String journeyId, int version, Dag dag,
      {String? note}) async {
    return _mutateVersion(journeyId, version, requireStatus: ApprovalStatus.draft,
        (v) => v.copyWith(dag: dag, note: note ?? v.note));
  }

  @override
  Future<ValidationResult> validateOnServer(String journeyId, int version) async {
    final dag = await getVersionDag(journeyId, version);
    // The mock mirrors the client validator (the real backend is authoritative).
    return _validator.validate(dag, capabilities: seedCapabilities);
  }

  @override
  Future<JourneyVersion> submitForApproval(String journeyId, int version) async {
    // Server rule: submit is validation-gated (the registry's 422).
    final result = await validateOnServer(journeyId, version);
    if (!result.isValid) {
      throw ValidationFailure('journey fails validation', issues: result.issues);
    }
    return _mutateVersion(journeyId, version, requireStatus: ApprovalStatus.draft,
        (v) => v.copyWith(status: ApprovalStatus.pendingApproval));
  }

  @override
  Future<JourneyVersion> approve(String journeyId, int version) =>
      _checkerAction(journeyId, version, (v) => v.copyWith(
            status: ApprovalStatus.published,
            approverId: _actor(),
          ), publish: true);

  @override
  Future<JourneyVersion> reject(String journeyId, int version, String comment) =>
      _checkerAction(journeyId, version, (v) => v.copyWith(
            status: ApprovalStatus.rejected,
            approverId: _actor(),
            note: comment,
          ));

  /// Server rule (the 403): PENDING only, and the author may not check their
  /// own work — the same guard the registry's checkerAction applies.
  Future<JourneyVersion> _checkerAction(
    String journeyId,
    int version,
    JourneyVersion Function(JourneyVersion) f, {
    bool publish = false,
  }) async {
    final j = await getJourney(journeyId);
    final current = j.versions.firstWhere((v) => v.version == version,
        orElse: () => throw const NotFoundFailure('No such version'));
    if (current.status != ApprovalStatus.pendingApproval) {
      throw ConflictFailure(
          'only a pendingApproval version can be approved/rejected'
          ' (v$version is ${current.status.name})');
    }
    if (_actor() == current.authorId) {
      throw ForbiddenFailure(
          "maker-checker: author '${current.authorId}' may not approve/reject"
          ' their own version');
    }
    return _mutateVersion(journeyId, version, f, publish: publish);
  }

  Future<JourneyVersion> _mutateVersion(
    String journeyId,
    int version,
    JourneyVersion Function(JourneyVersion) f, {
    ApprovalStatus? requireStatus,
    bool publish = false,
  }) async {
    final j = await getJourney(journeyId);
    final current = j.versions.firstWhere((v) => v.version == version,
        orElse: () => throw const NotFoundFailure('No such version'));
    if (requireStatus != null && current.status != requireStatus) {
      throw ConflictFailure('version $version is ${current.status.name},'
          ' expected ${requireStatus.name}');
    }
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
