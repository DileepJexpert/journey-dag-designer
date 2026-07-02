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
import '../../core/error/failure.dart';
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

  /// Monotonic guard against the LAST-RESPONSE-WINS race: rapid version
  /// switches fire overlapping loads over real (async) HTTP, and without this
  /// the slowest response would overwrite the user's latest selection. Only
  /// the newest in-flight load may apply its result.
  int _loadSeq = 0;

  /// Monotonic edit generation for the DIRTY-FLAG race: a save snapshots the
  /// generation it persisted; edits made while that save was in flight bump it,
  /// and completion only clears `dirty` if nothing changed meanwhile.
  int _editGen = 0;

  // ---------------------------------------------------------------------------
  // Load
  // ---------------------------------------------------------------------------

  Future<void> load({int? selectVersion}) async {
    final seq = ++_loadSeq;
    state = state.copyWith(loading: true, error: null);
    try {
      final repo = _ref.read(journeyRepositoryProvider);
      final caps = await _ref.read(capabilityRepositoryProvider).listCapabilities();
      final journey = await repo.getJourney(journeyId);
      if (seq != _loadSeq || !mounted) {
        return; // a newer load superseded this one — drop the stale response
      }

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
      if (seq != _loadSeq || !mounted) {
        return; // stale failure — the newer load owns the state
      }
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
    if (state.isEditable) {
      _editGen++; // a move made during an in-flight save must survive it
    }
    state = state.copyWith(
      dag: state.dag.copyWith(layout: layout),
      dirty: state.isEditable ? true : state.dirty,
    );
  }

  // ---------------------------------------------------------------------------
  // Structural edits (guarded by isEditable)
  // ---------------------------------------------------------------------------

  void addTask(String capability) {
    if (!state.isEditable) return;
    _addNode(DagNode.task(id: _freshId('task'), capability: capability));
  }

  void addBranch() {
    if (!state.isEditable) return;
    _addNode(DagNode.branch(id: _freshId('branch'), arms: const []));
  }

  void addParallel() {
    if (!state.isEditable) return;
    _addNode(DagNode.parallel(id: _freshId('parallel')));
  }

  void addJoin() {
    if (!state.isEditable) return;
    _addNode(DagNode.join(id: _freshId('join')));
  }

  void addWait() {
    if (!state.isEditable) return;
    _addNode(DagNode.wait(id: _freshId('wait'), waitFor: 'Event'));
  }

  void addTimer() {
    if (!state.isEditable) return;
    _addNode(DagNode.timer(id: _freshId('timer'), delay: '2h'));
  }

  void addHuman() {
    if (!state.isEditable) return;
    _addNode(DagNode.human(id: _freshId('human')));
  }

  void addForeach() {
    if (!state.isEditable) return;
    _addNode(DagNode.foreach(id: _freshId('foreach'), items: 'context.items'));
  }

  void addSubjourney() {
    if (!state.isEditable) return;
    _addNode(
        DagNode.subjourney(id: _freshId('sub'), journeyKey: 'sub-journey'));
  }

  void addTerminal() {
    if (!state.isEditable) return;
    _addNode(DagNode.terminal(id: _freshId('end')));
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

  /// Add a directed forward edge from -> to, per node kind (branch adds an arm,
  /// parallel a branch, human an outcome, terminal nothing).
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
          : from.copyWith(arms: [...from.arms, BranchArm(when: 'true', next: toId)]),
      ParallelNode() => from.branches.contains(toId)
          ? from
          : from.copyWith(branches: [...from.branches, toId]),
      JoinNode() => from.next.contains(toId)
          ? from
          : from.copyWith(next: [...from.next, toId]),
      WaitNode() => from.next.contains(toId)
          ? from
          : from.copyWith(next: [...from.next, toId]),
      TimerNode() => from.next.contains(toId)
          ? from
          : from.copyWith(next: [...from.next, toId]),
      HumanNode() => from.outcomes.any((o) => o.next == toId)
          ? from
          : from.copyWith(outcomes: [
              ...from.outcomes,
              HumanOutcome(value: 'outcome${from.outcomes.length + 1}', next: toId),
            ]),
      ForeachNode() => from.next.contains(toId)
          ? from
          : from.copyWith(next: [...from.next, toId]),
      SubjourneyNode() => from.next.contains(toId)
          ? from
          : from.copyWith(next: [...from.next, toId]),
      TerminalNode() => from,
    };
    _replaceNode(updated);
  }

  void disconnect(String fromId, String toId) {
    if (!state.isEditable) return;
    final from = state.dag.nodeOrNull(fromId);
    if (from == null) return;
    final updated = switch (from) {
      TaskNode() => from.copyWith(next: _without(from.next, toId)),
      BranchNode() =>
        from.copyWith(arms: from.arms.where((a) => a.next != toId).toList()),
      ParallelNode() => from.copyWith(branches: _without(from.branches, toId)),
      JoinNode() => from.copyWith(next: _without(from.next, toId)),
      WaitNode() => from.copyWith(next: _without(from.next, toId)),
      TimerNode() => from.copyWith(next: _without(from.next, toId)),
      HumanNode() => from.copyWith(
          outcomes: from.outcomes.where((o) => o.next != toId).toList()),
      ForeachNode() => from.copyWith(next: _without(from.next, toId)),
      SubjourneyNode() => from.copyWith(next: _without(from.next, toId)),
      TerminalNode() => from,
    };
    _replaceNode(updated);
  }

  static List<String> _without(List<String> xs, String x) =>
      xs.where((e) => e != x).toList();

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
            next: _without(n.next, removedId),
            onFailure: n.onFailure == removedId ? null : n.onFailure,
          ),
        BranchNode() => n.copyWith(
            arms: n.arms.where((a) => a.next != removedId).toList(),
            defaultNext: n.defaultNext == removedId ? null : n.defaultNext,
          ),
        ParallelNode() => n.copyWith(branches: _without(n.branches, removedId)),
        JoinNode() => n.copyWith(
            joinOn: _without(n.joinOn, removedId),
            next: _without(n.next, removedId),
          ),
        WaitNode() => n.copyWith(
            next: _without(n.next, removedId),
            onTimeout: n.onTimeout == removedId ? null : n.onTimeout,
          ),
        TimerNode() => n.copyWith(next: _without(n.next, removedId)),
        HumanNode() => n.copyWith(
            outcomes: n.outcomes.where((o) => o.next != removedId).toList()),
        ForeachNode() => n.copyWith(
            body: _without(n.body, removedId),
            next: _without(n.next, removedId),
          ),
        SubjourneyNode() => n.copyWith(next: _without(n.next, removedId)),
        TerminalNode() => n,
      };

  void _commit(Dag dag, {Object? select = _keepSelection}) {
    _editGen++;
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
      // DIRTY-FLAG RACE guard: snapshot the edit generation the save persists.
      // Edits made while the (real, async) save is in flight bump _editGen —
      // clearing dirty then would silently lose their "unsaved" marker, and a
      // later Submit could skip re-saving them.
      final savedGen = _editGen;
      await repo.saveDraft(journeyId, state.workingVersion!, state.dag);
      final journey = await repo.getJourney(journeyId);
      if (!mounted) return;
      state = state.copyWith(journey: journey, dirty: _editGen != savedGen);
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
    } on ValidationFailure catch (e) {
      // The server's authoritative 422: the designer-vocabulary issues land in
      // the SAME validation panel as live client findings (jump-to-node works),
      // never a generic toast. The next structural edit re-validates live.
      if (!mounted) return;
      state = state.copyWith(
        error: e.message,
        validation: e.issues.isEmpty
            ? state.validation
            : ValidationResult(issues: e.issues),
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(error: '$e'); // Failure.toString() is the message
    } finally {
      if (mounted) {
        state = state.copyWith(busy: false);
      }
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
