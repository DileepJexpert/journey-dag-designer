/// The mock mirrors the registry's SERVER rules (A3): real actor identity on
/// every mutation, author != approver (403), one editable draft (409), and a
/// validation-gated submit (422 with issues) — so mock mode and live mode
/// disagree on transport, never on the rules.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/core/error/failure.dart';
import 'package:journey_dag_designer/data/repositories/mock_journey_repository.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/dag_node.dart';
import 'package:journey_dag_designer/domain/models/journey.dart';

import '../domain/fixtures.dart';

void main() {
  var actor = 'maker-asha';
  late MockJourneyRepository repo;

  setUp(() {
    actor = 'maker-asha';
    repo = MockJourneyRepository(actor: () => actor);
  });

  test('mutations stamp the REAL logged-in actor, not a hardcoded id', () async {
    final journey = await repo.createJourney(key: 'k', name: 'K');
    final draft = await repo.createDraft(journey.id, canonicalLoanDag());

    expect(draft.authorId, 'maker-asha');
  });

  test('the author may not approve or reject their own version (the 403)',
      () async {
    final journey = await repo.createJourney(key: 'k', name: 'K');
    await repo.createDraft(journey.id, canonicalLoanDag());
    await repo.submitForApproval(journey.id, 1);

    await expectLater(
        repo.approve(journey.id, 1), throwsA(isA<ForbiddenFailure>()));
    await expectLater(
        repo.reject(journey.id, 1, 'mine'), throwsA(isA<ForbiddenFailure>()));

    // A DIFFERENT actor approves — published, pointer moved, approver stamped.
    actor = 'checker-vikram';
    final published = await repo.approve(journey.id, 1);
    expect(published.status, ApprovalStatus.published);
    expect(published.approverId, 'checker-vikram');
    expect((await repo.getJourney(journey.id)).activeVersion, 1);
  });

  test('at most one editable draft per journey (the 409)', () async {
    final journey = await repo.createJourney(key: 'k', name: 'K');
    await repo.createDraft(journey.id, canonicalLoanDag());

    await expectLater(repo.createDraft(journey.id, canonicalLoanDag()),
        throwsA(isA<ConflictFailure>()));
  });

  test('submit is validation-gated with issues (the 422)', () async {
    final journey = await repo.createJourney(key: 'k', name: 'K');
    const broken = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['ghost']),
    ]);
    await repo.createDraft(journey.id, broken);

    await expectLater(
      repo.submitForApproval(journey.id, 1),
      throwsA(isA<ValidationFailure>()
          .having((f) => f.issues, 'issues', isNotEmpty)),
    );
    // Refused — still an editable draft, fixable in place.
    expect((await repo.getJourney(journey.id)).draft?.status,
        ApprovalStatus.draft);
  });

  test('checker actions require a pending version (lifecycle 409)', () async {
    final journey = await repo.createJourney(key: 'k', name: 'K');
    await repo.createDraft(journey.id, canonicalLoanDag());

    actor = 'checker-vikram';
    await expectLater(
        repo.approve(journey.id, 1), throwsA(isA<ConflictFailure>()));
  });
}
