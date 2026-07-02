/// The two async races the review flagged — invisible against the synchronous
/// mock, ARMED the moment the repository is real HTTP (A3):
///
/// 1. DIRTY-FLAG race: an edit made while a save is in flight must keep the
///    draft dirty — clearing it would silently lose the "unsaved" marker and a
///    later Submit could skip persisting the edit.
/// 2. LAST-RESPONSE-WINS race: rapid version switches fire overlapping loads;
///    the SLOWEST response must never overwrite the user's latest selection.
///
/// Both tests drive the real [EditorController] with a gate-controlled async
/// repository so the interleavings are deterministic, not timing-dependent.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/app/providers.dart';
import 'package:journey_dag_designer/data/repositories/mock_journey_repository.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/journey.dart';
import 'package:journey_dag_designer/domain/models/validation.dart';
import 'package:journey_dag_designer/domain/repositories/journey_repository.dart';
import 'package:journey_dag_designer/features/editor/editor_controller.dart';

import '../domain/fixtures.dart';

/// Delegates to the in-memory mock, but lets a test HOLD individual calls open
/// (completer gates) to force the exact interleavings the races need.
class _GatedRepository implements JourneyRepository {
  _GatedRepository(this.inner);

  final JourneyRepository inner;

  /// When set, the NEXT saveDraft parks on this gate before executing.
  Completer<void>? saveGate;

  /// getJourney call index -> gate; calls without a gate pass straight through.
  final Map<int, Completer<void>> getJourneyGates = {};
  int _getJourneyCalls = 0;

  /// The index the NEXT [getJourney] call will get (for precise gating).
  int get nextGetJourneyCall => _getJourneyCalls;

  @override
  Future<Journey> getJourney(String id) async {
    final gate = getJourneyGates[_getJourneyCalls++];
    if (gate != null) {
      await gate.future;
    }
    return inner.getJourney(id);
  }

  @override
  Future<JourneyVersion> saveDraft(String journeyId, int version, Dag dag,
      {String? note}) async {
    final gate = saveGate;
    if (gate != null) {
      saveGate = null;
      await gate.future;
    }
    return inner.saveDraft(journeyId, version, dag, note: note);
  }

  // -- straight delegation ----------------------------------------------------
  @override
  Future<List<Journey>> listJourneys(
          {String? businessLine, String? product, String? partner}) =>
      inner.listJourneys(
          businessLine: businessLine, product: product, partner: partner);

  @override
  Future<Journey> createJourney(
          {required String key,
          required String name,
          String? businessLine,
          String? product,
          String? partner}) =>
      inner.createJourney(
          key: key,
          name: name,
          businessLine: businessLine,
          product: product,
          partner: partner);

  @override
  Future<Dag> getVersionDag(String journeyId, int version) =>
      inner.getVersionDag(journeyId, version);

  @override
  Future<JourneyVersion> createDraft(String journeyId, Dag dag, {String? note}) =>
      inner.createDraft(journeyId, dag, note: note);

  @override
  Future<ValidationResult> validateOnServer(String journeyId, int version) =>
      inner.validateOnServer(journeyId, version);

  @override
  Future<JourneyVersion> submitForApproval(String journeyId, int version) =>
      inner.submitForApproval(journeyId, version);

  @override
  Future<JourneyVersion> approve(String journeyId, int version) =>
      inner.approve(journeyId, version);

  @override
  Future<JourneyVersion> reject(String journeyId, int version, String comment) =>
      inner.reject(journeyId, version, comment);
}

Future<EditorState> _settled(
  ProviderContainer container,
  AutoDisposeStateNotifierProvider<EditorController, EditorState> provider,
) async {
  while (container.read(provider).loading || container.read(provider).busy) {
    await Future<void>.delayed(const Duration(milliseconds: 2));
  }
  return container.read(provider);
}

/// Yields to let queued microtasks/futures run without settling everything.
Future<void> _pump([int times = 3]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  // The mock reads the actor at CALL time — flipping this var switches the
  // acting user mid-test (maker authors, checker approves).
  var actor = 'maker-asha';
  late _GatedRepository repo;
  late ProviderContainer container;

  setUp(() async {
    actor = 'maker-asha';
    repo = _GatedRepository(MockJourneyRepository(actor: () => actor));
    container = ProviderContainer(overrides: [
      journeyRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);
  });

  test('an edit made while a save is in flight keeps the draft dirty', () async {
    final journey =
        await repo.createJourney(key: 'race-dirty', name: 'Race Dirty');
    await repo.createDraft(journey.id, canonicalLoanDag(), note: 'draft');

    final provider = editorControllerProvider(journey.id);
    final controller = container.read(provider.notifier);
    await _settled(container, provider);

    controller.addTask('kyc'); // dirty edit #1
    expect(container.read(provider).dirty, isTrue);

    // Save parks server-side (the gate); the maker keeps editing meanwhile.
    final gate = Completer<void>();
    repo.saveGate = gate;
    final saving = controller.save();
    await _pump();
    controller.addTask('bureau'); // edit #2 — made DURING the in-flight save

    gate.complete();
    await saving;

    expect(container.read(provider).dirty, isTrue,
        reason: 'the in-flight save did not persist edit #2 — clearing dirty'
            ' would silently lose the unsaved-edit marker');

    // And once a QUIET save completes (no mid-flight edits), dirty clears.
    await controller.save();
    expect(container.read(provider).dirty, isFalse);
  });

  test('the slowest of two overlapping version loads never wins', () async {
    // v1 authored + published (checker approves), then a v2 draft — two real,
    // distinct versions to switch between.
    final journey =
        await repo.createJourney(key: 'race-switch', name: 'Race Switch');
    await repo.createDraft(journey.id, canonicalLoanDag());
    await repo.submitForApproval(journey.id, 1);
    actor = 'checker-vikram';
    await repo.approve(journey.id, 1);
    actor = 'maker-asha';
    await repo.createDraft(journey.id, canonicalLoanDag(), note: 'v2');

    final provider = editorControllerProvider(journey.id);
    final controller = container.read(provider.notifier);
    await _settled(container, provider); // initial load lands on the v2 draft
    expect(container.read(provider).workingVersion, 2);

    // The STALE switch (to v1) is held open server-side; the user then switches
    // back to v2, which completes immediately.
    final staleGate = Completer<void>();
    repo.getJourneyGates[repo.nextGetJourneyCall] = staleGate;
    final stale = controller.load(selectVersion: 1);
    await _pump();
    final fresh = controller.load(selectVersion: 2); // the user's LATEST choice
    await fresh;
    expect(container.read(provider).workingVersion, 2);

    staleGate.complete(); // the slow v1 response lands LAST...
    await stale;

    expect(container.read(provider).workingVersion, 2,
        reason: 'the stale (slowest) load must be dropped, not applied over'
            " the user's latest selection");
    expect(container.read(provider).loading, isFalse);
  });
}
