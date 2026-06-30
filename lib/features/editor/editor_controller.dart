/// The DAG editor's working state + mutations (build doc §5–§8). Holds a single
/// editable copy of a [Dag] for one journey version and exposes pure, undo-free
/// edits (add/connect/move/delete nodes, edit branch arms) plus the maker-checker
/// persistence actions (save draft, submit, approve, reject) against the
/// [JourneyRepository].
///
/// Editability rule (build doc §8): only a `draft`/`pendingApproval` version is
/// mutable. A published/rejected version is read-only; "Edit as new draft" forks
/// a fresh draft from its DAG. Every structural edit re-runs the pure
/// [DagValidator] so the canvas, validation panel, and Submit gate stay live.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models/branch_arm.dart';
import '../../domain/models/capability.dart';
import '../../domain/models/dag.dart';
import '../../domain/models/dag_node.dart';
import '../../domain/models/journey.dart';
import '../../domain/models/node_layout.dart';
import '../../domain/models/validation.dart';

class EditorState {
  const EditorState({
    this.loading = true,
    this.busy = false,
    this.error,
    this.journey,
    this.workingVersion,
    this.dag = const Dag(startNodeId: '', nodes: []),
    this.capabilities = const <Capability>[],
    this.selectedNodeId,
    this.dirty = false,
    this.validation = const ValidationResult(),
  });

  final bool loading;
  final bool busy;
  final String? error;
  final Journey? journey;
  final int? workingVersion;
  final Dag dag;
  final List<Capability> capabilities;
  final String? selectedNodeId;
  final bool dirty;
  final ValidationResult validation;

  JourneyVersion? get version {
    final j = journey;
    if (j == null || workingVersion == null) return null;
    for (final v in j.versions) {
      if (v.version == workingVersion) return v;
    }
    return null;
  }

  /// The working version is editable only while it is a draft.
  bool get isEditable => version?.status == ApprovalStatus.draft;

  bool get isPendingApproval =>
      version?.status == ApprovalStatus.pendingApproval;

  DagNode? get selectedNode =>
      selectedNodeId == null ? null : dag.nodeOrNull(selectedNodeId!);

  EditorState copyWith({
    bool? loading,
    bool? busy,
    Object? error = _noChange,
    Journey? journey,
    int? workingVersion,
    Dag? dag,
    List<Capability>? capabilities,
    Object? selectedNodeId = _noChange,
    bool? dirty,
    ValidationResult? validation,
  }) {
    return EditorState(
      loading: loading ?? this.loading,
      busy: busy ?? this.busy,
      error: error == _noChange ? this.error : error as String?,
      journey: journey ?? this.journey,
      workingVersion: workingVersion ?? this.workingVersion,
      dag: dag ?? this.dag,
      capabilities: capabilities ?? this.capabilities,
      selectedNodeId: selectedNodeId == _noChange
          ? this.selectedNodeId
          : selectedNodeId as String?,
      dirty: dirty ?? this.dirty,
      validation: validation ?? this.validation,
    );
  }

  static const _noChange = Object();
}

class EditorController extends StateNotifier<EditorState> {
  EditorController(this._ref, this.journeyId) : super(const EditorState()) {
    load();
  }

  final Ref _ref;
  final String journeyId;

  // ---------------------------------------------------------------------------
  // Load
  // ---------------------------------------------------------------------------

  Future<void> load({int? selectVersion}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final repo = _ref.read(journeyRepositoryProvider);
      final caps = await _ref.read(capabilityRepositoryProvider).listCapabilities();
      final journey = await repo.getJourney(journeyId);

      // Prefer an explicit selection, then the editable draft, then active, then
      // the highest version present.
      JourneyVersion? target;
      if (selectVersion != null) {
        target = journey.versions
            .where((v) => v.version == selectVersion)
            .cast<JourneyVersion?>()
            .firstWhere((v) => true, orElse: () => null);
      }
      target ??= journey.draft ?? journey.active;
      if (target == null && journey.versions.isNotEmpty) {
        target = journey.versions.reduce((a, b) => a.version >= b.version ? a : b);
      }

      final dag = target?.dag ?? const Dag(startNodeId: '', nodes: []);
      state = EditorState(
        loading: false,
        journey: journey,
        workingVersion: target?.version,
        dag: dag,
        capabilities: caps,
        validation: _validate(dag, caps),
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  void selectVersion(int version) => load(selectVersion: version);

  // ---------------------------------------------------------------------------
  // Selection / layout (allowed even when read-only — they don't change config)
  // ---------------------------------------------------------------------------

  void select(String? nodeId) => state = state.copyWith(selectedNodeId: nodeId);

  void moveNode(String nodeId, double x, double y) {
    final layout = Map<String, NodeLayout>.from(state.dag.layout);
    layout[nodeId] = NodeLayout(x: x < 0 ? 0 : x, y: y < 0 ? 0 : y);
    // Position is persisted with the draft but isn't a structural change; mark
    // dirty only when editable so read-only versions stay clean.
    state = state.copyWith(
      dag: state.dag.copyWith(layout: layout),
      dirty: state.isEditable ? true : state.dirty,
    );
  }

  // ---------------------------------------------------------------------------
  // Structural edits (guarded by isEditable)
  // ---------------------------------------------------------------------------

  void addTask(String capabilityKey) {
    if (!state.isEditable) return;
    final id = _freshId('n');
    final node = DagNode.task(id: id, capabilityKey: capabilityKey);
    _addNode(node);
  }

  void addBranch() {
    if (!state.isEditable) return;
    final id = _freshId('br');
    final node = DagNode.branch(id: id, arms: const []);
    _addNode(node);
  }

  void addTerminal() {
    if (!state.isEditable) return;
    final id = _freshId('end');
    final node = DagNode.terminal(id: id);
    _addNode(node);
  }

  void _addNode(DagNode node) {
    final nodes = [...state.dag.nodes, node];
    final layout = Map<String, NodeLayout>.from(state.dag.layout);
    layout[node.id] = _nextFreePosition();
    final startNodeId =
        state.dag.startNodeId.isEmpty ? node.id : state.dag.startNodeId;
    _commit(
      state.dag.copyWith(nodes: nodes, layout: layout, startNodeId: startNodeId),
      select: node.id,
    );
  }

  void deleteNode(String nodeId) {
    if (!state.isEditable) return;
    final nodes = <DagNode>[];
    for (final n in state.dag.nodes) {
      if (n.id == nodeId) continue;
      nodes.add(_stripReferences(n, nodeId));
    }
    final layout = Map<String, NodeLayout>.from(state.dag.layout)..remove(nodeId);
    var start = state.dag.startNodeId;
    if (start == nodeId) start = nodes.isEmpty ? '' : nodes.first.id;
    _commit(
      state.dag.copyWith(nodes: nodes, layout: layout, startNodeId: start),
      select: state.selectedNodeId == nodeId ? null : state.selectedNodeId,
    );
  }

  void setStart(String nodeId) {
    if (!state.isEditable) return;
    _commit(state.dag.copyWith(startNodeId: nodeId));
  }

  /// Add a directed edge from -> to. Task: appends to `next`. Branch: adds a new
  /// arm (default expression) targeting `to`. Terminal: no outgoing edges.
  void connect(String fromId, String toId) {
    if (!state.isEditable || fromId == toId) return;
    final from = state.dag.nodeOrNull(fromId);
    if (from == null || state.dag.nodeOrNull(toId) == null) return;
    final updated = switch (from) {
      TaskNode() => from.next.contains(toId)
          ? from
          : from.copyWith(next: [...from.next, toId]),
      BranchNode() => from.arms.any((a) => a.next == toId)
          ? from
          : from.copyWith(
              arms: [...from.arms, BranchArm(expression: 'true', next: toId)]),
      TerminalNode() => from,
    };
    _replaceNode(updated);
  }

  void disconnect(String fromId, String toId) {
    if (!state.isEditable) return;
    final from = state.dag.nodeOrNull(fromId);
    if (from == null) return;
    final updated = switch (from) {
      TaskNode() =>
        from.copyWith(next: from.next.where((n) => n != toId).toList()),
      BranchNode() => from.copyWith(
          arms: from.arms.where((a) => a.next != toId).toList()),
      TerminalNode() => from,
    };
    _replaceNode(updated);
  }

  /// Replace a node wholesale (used by the inspector). The id must be unchanged.
  void replaceNode(DagNode node) {
    if (!state.isEditable) return;
    _replaceNode(node);
  }

  void _replaceNode(DagNode node) {
    final nodes = [
      for (final n in state.dag.nodes) if (n.id == node.id) node else n,
    ];
    _commit(state.dag.copyWith(nodes: nodes));
  }

  /// Remove every reference to [removedId] from a surviving node.
  DagNode _stripReferences(DagNode n, String removedId) => switch (n) {
        TaskNode() => n.copyWith(
            next: n.next.where((e) => e != removedId).toList(),
            joinOn: n.joinOn.where((e) => e != removedId).toList(),
            compensation: n.compensation == removedId ? null : n.compensation,
          ),
        BranchNode() => n.copyWith(
            joinOn: n.joinOn.where((e) => e != removedId).toList(),
            arms: n.arms.where((a) => a.next != removedId).toList(),
          ),
        TerminalNode() => n,
      };

  void _commit(Dag dag, {Object? select = _keepSelection}) {
    state = state.copyWith(
      dag: dag,
      dirty: true,
      validation: _validate(dag, state.capabilities),
      selectedNodeId: select == _keepSelection ? state.selectedNodeId : select,
    );
  }

  static const _keepSelection = Object();

  ValidationResult _validate(Dag dag, List<Capability> caps) =>
      _ref.read(dagValidatorProvider).validate(dag, capabilities: caps);

  // ---------------------------------------------------------------------------
  // Persistence (maker-checker)
  // ---------------------------------------------------------------------------

  /// Fork a fresh editable draft from the currently viewed (read-only) version.
  Future<void> editAsNewDraft() async {
    await _run(() async {
      final repo = _ref.read(journeyRepositoryProvider);
      final draft = await repo.createDraft(journeyId, state.dag,
          note: 'Draft from v${state.workingVersion ?? '-'}');
      await load(selectVersion: draft.version);
    });
  }

  Future<void> save() async {
    if (!state.isEditable) return;
    await _run(() async {
      final repo = _ref.read(journeyRepositoryProvider);
      await repo.saveDraft(journeyId, state.workingVersion!, state.dag);
      final journey = await repo.getJourney(journeyId);
      state = state.copyWith(journey: journey, dirty: false);
    });
  }

  Future<void> submit() async {
    if (!state.isEditable || !state.validation.isValid) return;
    await _run(() async {
      final repo = _ref.read(journeyRepositoryProvider);
      if (state.dirty) {
        await repo.saveDraft(journeyId, state.workingVersion!, state.dag);
      }
      await repo.submitForApproval(journeyId, state.workingVersion!);
      await load(selectVersion: state.workingVersion);
    });
  }

  Future<void> approve() async {
    await _run(() async {
      final repo = _ref.read(journeyRepositoryProvider);
      await repo.approve(journeyId, state.workingVersion!);
      await load(selectVersion: state.workingVersion);
    });
  }

  Future<void> reject(String comment) async {
    await _run(() async {
      final repo = _ref.read(journeyRepositoryProvider);
      await repo.reject(journeyId, state.workingVersion!, comment);
      await load(selectVersion: state.workingVersion);
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    state = state.copyWith(busy: true, error: null);
    try {
      await action();
    } catch (e) {
      state = state.copyWith(error: '$e');
    } finally {
      state = state.copyWith(busy: false);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _freshId(String prefix) {
    var i = 1;
    final ids = state.dag.nodes.map((n) => n.id).toSet();
    while (ids.contains('${prefix}_$i')) {
      i++;
    }
    return '${prefix}_$i';
  }

  /// A non-overlapping spot for a freshly added node.
  NodeLayout _nextFreePosition() {
    if (state.dag.layout.isEmpty) return const NodeLayout(x: 80, y: 120);
    final maxX = state.dag.layout.values.map((l) => l.x).reduce((a, b) => a > b ? a : b);
    final atRow = state.dag.layout.values.where((l) => (l.x - maxX).abs() < 1).length;
    return NodeLayout(x: maxX + 200, y: 120 + atRow * 110);
  }
}

/// One editor instance per journey id; auto-disposed when the screen leaves.
final editorControllerProvider = StateNotifierProvider.autoDispose
    .family<EditorController, EditorState, String>((ref, journeyId) {
  ref.keepAlive();
  return EditorController(ref, journeyId);
});
