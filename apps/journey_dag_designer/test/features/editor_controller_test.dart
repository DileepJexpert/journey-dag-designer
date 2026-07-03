/// Editor authoring lifecycle (build doc §5–§8) exercised through the real
/// [EditorController] + seeded [MockJourneyRepository]: fork a draft, author
/// nodes from the palette, wire edges, watch validation gate Submit, then run
/// the maker→checker approval. This is the behavioural lock for "the maker can
/// configure a new workflow" — the gap this feature closed.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/app/providers.dart';
import 'package:dag_core/dag_core.dart';
import 'package:journey_dag_designer/domain/models/journey.dart';
import 'package:journey_dag_designer/features/editor/editor_controller.dart';

Future<EditorState> _settled(
  ProviderContainer container,
  AutoDisposeStateNotifierProvider<EditorController, EditorState> provider,
) async {
  // The controller loads asynchronously in its constructor.
  while (container.read(provider).loading) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  return container.read(provider);
}

void main() {
  test('maker forks a draft, authors a node, and submits a valid journey',
      () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final provider = editorControllerProvider('jr_loan');
    final controller = container.read(provider.notifier);

    var state = await _settled(container, provider);
    // Seeded journey opens on its published (read-only) version.
    expect(state.isEditable, isFalse);
    expect(state.version?.status, ApprovalStatus.published);

    // Fork an editable draft from it.
    await controller.editAsNewDraft();
    state = await _settled(container, provider);
    expect(state.isEditable, isTrue);
    expect(state.version?.status, ApprovalStatus.draft);
    // The forked draft carries the loan DAG and validates clean.
    expect(state.validation.isValid, isTrue);

    // Authoring a dangling node makes the draft invalid (dead-end path) and
    // blocks Submit — the validation gate works.
    controller.addTask('kyc');
    final newId = container.read(provider).selectedNodeId!;
    controller.connect('n_score', newId);
    state = container.read(provider);
    expect(state.dag.nodeOrNull(newId), isNotNull);
    expect(state.dirty, isTrue);
    expect(state.validation.isValid, isFalse);
    await controller.submit();
    expect(container.read(provider).version?.status, ApprovalStatus.draft);

    // Remove the dangling node -> valid again -> Submit advances to pending.
    controller.deleteNode(newId);
    expect(container.read(provider).validation.isValid, isTrue);
    await controller.submit();
    state = await _settled(container, provider);
    expect(state.version?.status, ApprovalStatus.pendingApproval);
  });

  test('a freshly created empty draft fails validation, then accepts authoring',
      () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Same path the New Journey dialog uses: create journey + empty draft.
    final repo = container.read(journeyRepositoryProvider);
    final journey = await repo.createJourney(key: 'k', name: 'K');
    await repo.createDraft(journey.id,
        const Dag(startNodeId: '', nodes: []), note: 'Initial draft');

    final provider = editorControllerProvider(journey.id);
    final controller = container.read(provider.notifier);
    var state = await _settled(container, provider);

    expect(state.isEditable, isTrue);
    expect(state.validation.isValid, isFalse);
    expect(state.validation.errors.map((e) => e.code),
        contains(ValidationCode.emptyDag));

    // Adding the first node makes it the start node automatically.
    controller.addTask('customer-party');
    state = container.read(provider);
    expect(state.dag.startNodeId, isNotEmpty);
    expect(state.dag.nodes, hasLength(1));
  });
}
