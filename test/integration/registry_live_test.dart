/// LIVE end-to-end against a REAL journey-registry (A1) on localhost:8104 —
/// the designer-side proof of the seam: full maker-checker lifecycle over real
/// HTTP, the self-approve 403, and a real 422 whose issues carry the designer
/// vocabulary. SELF-SKIPPING when the registry isn't running, so `flutter test`
/// stays green without infrastructure:
///
///   cd idfc-integration-platform && REGISTRY_AUTH_TOKEN=dev-registry-token \
///     ./gradlew :platform:journey-registry:bootRun     # then rerun this test
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/core/error/failure.dart';
import 'package:journey_dag_designer/core/network/dio_client.dart';
import 'package:journey_dag_designer/data/repositories/http_journey_repository.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/dag_node.dart';
import 'package:journey_dag_designer/domain/models/journey.dart';
import 'package:journey_dag_designer/domain/models/validation.dart';

import '../domain/fixtures.dart';

const _baseUrl = 'http://localhost:8104';
const _devToken = 'dev-registry-token';

Future<bool> _registryUp() async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 2);
  try {
    final req = await client
        .getUrl(Uri.parse('$_baseUrl/actuator/health'))
        .timeout(const Duration(seconds: 2));
    final res = await req.close().timeout(const Duration(seconds: 2));
    return res.statusCode == 200;
  } catch (_) {
    return false;
  } finally {
    client.close(force: true);
  }
}

void main() {
  var actor = 'maker-asha';
  late HttpJourneyRepository repo;
  late bool up;

  setUpAll(() async {
    up = await _registryUp();
    repo = HttpJourneyRepository(
      dio: buildDio(
        actorId: () => actor,
        baseUrl: _baseUrl,
        registryToken: _devToken,
      ),
    );
  });

  setUp(() => actor = 'maker-asha');

  test('LIVE: full maker-checker lifecycle over real HTTP', () async {
    if (!up) {
      markTestSkipped('journey-registry not reachable on $_baseUrl — start it'
          ' (local profile) and rerun');
      return;
    }
    // Unique key per run — the registry remembers published journeys.
    final key = 'it-designer-${DateTime.now().millisecondsSinceEpoch}';

    final journey = await repo.createJourney(
        key: key, name: 'Designer IT', businessLine: 'PL');
    expect(journey.id, key);

    // Maker authors + saves a draft; the server stamps identity.
    final draft = await repo.createDraft(journey.id, canonicalLoanDag(),
        note: 'authored in the live IT');
    expect(draft.version, 1);
    expect(draft.status, ApprovalStatus.draft);
    expect(draft.authorId, 'maker-asha');
    await repo.saveDraft(journey.id, 1, canonicalLoanDag(), note: 'saved');

    // A second draft while one is open is the registry's 409.
    await expectLater(repo.createDraft(journey.id, canonicalLoanDag()),
        throwsA(isA<ConflictFailure>()));

    // The server validates the REAL artifact clean, then accepts the submit.
    expect((await repo.validateOnServer(journey.id, 1)).errors, isEmpty);
    final pending = await repo.submitForApproval(journey.id, 1);
    expect(pending.status, ApprovalStatus.pendingApproval);

    // Self-approve is the SERVER's 403 — same actor, real HTTP, real rule.
    await expectLater(
      repo.approve(journey.id, 1),
      throwsA(isA<ForbiddenFailure>()
          .having((f) => f.message, 'message', contains('maker-checker'))),
    );

    // A different checker publishes; the pointer moves; the dag round-trips.
    actor = 'checker-vikram';
    final published = await repo.approve(journey.id, 1);
    expect(published.status, ApprovalStatus.published);
    expect(published.approverId, 'checker-vikram');

    final reloaded = await repo.getJourney(journey.id);
    expect(reloaded.activeVersion, 1);
    expect(reloaded.versions.single.dag.startNodeId, 'n_customer');
    expect(reloaded.versions.single.dag.layout, isNotEmpty,
        reason: 'canvas layout survives the registry round-trip');
  });

  test('LIVE: a real 422 carries designer-vocabulary issues', () async {
    if (!up) {
      markTestSkipped('journey-registry not reachable on $_baseUrl');
      return;
    }
    final key = 'it-broken-${DateTime.now().millisecondsSinceEpoch}';
    await repo.createJourney(key: key, name: 'Broken IT');
    const broken = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['ghost']),
    ]);
    await repo.createDraft(key, broken);

    try {
      await repo.submitForApproval(key, 1);
      fail('expected the registry 422');
    } on ValidationFailure catch (e) {
      expect(e.issues, isNotEmpty);
      final codes = e.issues.map((i) => i.code).toList();
      expect(codes, contains(ValidationCode.danglingEdge));
      expect(e.issues.first.nodeId, 'a',
          reason: 'nodeId drives jump-to-node in the validation panel');
    }
  });
}
