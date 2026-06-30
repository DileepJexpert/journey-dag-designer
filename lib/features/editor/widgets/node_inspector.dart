/// Inspector for the selected node (build doc §5, §7). Type-specific forms edit
/// the node's config and commit through the [EditorController]:
///   * Task     — capability, next edges, joinOn, meter, compensation, optional
///   * Branch   — ordered arms (expression → target), joinOn
///   * Terminal — action, emitted events
///
/// Every field is disabled when the version is read-only; edits route to
/// `replaceNode`, which re-validates so the canvas + Submit gate stay live.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/branch_arm.dart';
import '../../../domain/models/dag_node.dart';
import '../editor_controller.dart';

class NodeInspector extends ConsumerWidget {
  const NodeInspector({super.key, required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = editorControllerProvider(journeyId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final node = state.selectedNode;

    if (node == null) {
      return const _Hint('Select a node to edit its configuration.');
    }

    final editable = state.isEditable;
    final otherIds =
        state.dag.nodes.map((n) => n.id).where((id) => id != node.id).toList();

    return ListView(
      key: ValueKey(node.id),
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(_typeName(node),
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            if (state.dag.startNodeId == node.id)
              const Chip(
                label: Text('start', style: TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
              )
            else if (editable)
              TextButton(
                onPressed: () => controller.setStart(node.id),
                child: const Text('Set as start'),
              ),
          ],
        ),
        Text(node.id, style: Theme.of(context).textTheme.bodySmall),
        const Divider(height: 20),
        ...switch (node) {
          TaskNode() =>
            _taskForm(context, controller, node, state, otherIds, editable),
          BranchNode() =>
            _branchForm(context, controller, node, otherIds, editable),
          TerminalNode() => _terminalForm(context, controller, node, editable),
        },
        const Divider(height: 24),
        if (editable)
          OutlinedButton.icon(
            onPressed: () => controller.deleteNode(node.id),
            icon: const Icon(Icons.delete_outline, size: 18),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
            label: const Text('Delete node'),
          ),
      ],
    );
  }

  // ---- Task ----------------------------------------------------------------
  List<Widget> _taskForm(BuildContext context, EditorController c, TaskNode n,
      EditorState state, List<String> otherIds, bool editable) {
    return [
      _DropdownField(
        label: 'Capability',
        value: n.capabilityKey,
        items: {for (final cap in state.capabilities) cap.key: cap.name},
        enabled: editable,
        onChanged: (v) =>
            v == null ? null : c.replaceNode(n.copyWith(capabilityKey: v)),
      ),
      const SizedBox(height: 12),
      _EdgeEditor(
        label: 'Next (fan-out runs in parallel)',
        targets: n.next,
        candidates: otherIds,
        enabled: editable,
        onAdd: (t) => c.connect(n.id, t),
        onRemove: (t) => c.disconnect(n.id, t),
      ),
      const SizedBox(height: 12),
      _EdgeEditor(
        label: 'Join on (wait for these predecessors)',
        targets: n.joinOn,
        candidates: otherIds,
        enabled: editable,
        onAdd: (t) => c.replaceNode(n.copyWith(joinOn: [...n.joinOn, t])),
        onRemove: (t) => c.replaceNode(
            n.copyWith(joinOn: n.joinOn.where((e) => e != t).toList())),
      ),
      const SizedBox(height: 12),
      _TextField(
        nodeId: n.id,
        field: 'meter',
        label: 'Meter (backpressure pool, optional)',
        initial: n.meter ?? '',
        enabled: editable,
        onChanged: (v) =>
            c.replaceNode(n.copyWith(meter: v.isEmpty ? null : v)),
      ),
      const SizedBox(height: 12),
      _DropdownField(
        label: 'Compensation node (saga rollback)',
        value: n.compensation,
        items: {for (final id in otherIds) id: id},
        enabled: editable,
        allowEmpty: true,
        onChanged: (v) => c.replaceNode(n.copyWith(compensation: v)),
      ),
      const SizedBox(height: 4),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Optional (failure does not abort the journey)'),
        value: n.optional,
        onChanged: editable
            ? (v) => c.replaceNode(n.copyWith(optional: v))
            : null,
      ),
    ];
  }

  // ---- Branch --------------------------------------------------------------
  List<Widget> _branchForm(BuildContext context, EditorController c,
      BranchNode n, List<String> otherIds, bool editable) {
    return [
      Text('Arms (evaluated top-to-bottom; first match wins)',
          style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 8),
      for (var i = 0; i < n.arms.length; i++)
        _ArmRow(
          key: ValueKey('${n.id}_arm_$i'),
          nodeId: n.id,
          index: i,
          arm: n.arms[i],
          candidates: otherIds,
          enabled: editable,
          onExpression: (expr) {
            final arms = [...n.arms];
            arms[i] = arms[i].copyWith(expression: expr);
            c.replaceNode(n.copyWith(arms: arms));
          },
          onTarget: (t) {
            final arms = [...n.arms];
            arms[i] = arms[i].copyWith(next: t);
            c.replaceNode(n.copyWith(arms: arms));
          },
          onRemove: () {
            final arms = [...n.arms]..removeAt(i);
            c.replaceNode(n.copyWith(arms: arms));
          },
        ),
      if (editable)
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => c.replaceNode(n.copyWith(arms: [
              ...n.arms,
              BranchArm(
                  expression: 'true',
                  next: otherIds.isEmpty ? '' : otherIds.first),
            ])),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add arm'),
          ),
        ),
      const SizedBox(height: 12),
      _EdgeEditor(
        label: 'Join on',
        targets: n.joinOn,
        candidates: otherIds,
        enabled: editable,
        onAdd: (t) => c.replaceNode(n.copyWith(joinOn: [...n.joinOn, t])),
        onRemove: (t) => c.replaceNode(
            n.copyWith(joinOn: n.joinOn.where((e) => e != t).toList())),
      ),
    ];
  }

  // ---- Terminal ------------------------------------------------------------
  List<Widget> _terminalForm(
      BuildContext context, EditorController c, TerminalNode n, bool editable) {
    return [
      _TextField(
        nodeId: n.id,
        field: 'action',
        label: 'Terminal action (e.g. push_decision_to_channel)',
        initial: n.action ?? '',
        enabled: editable,
        onChanged: (v) =>
            c.replaceNode(n.copyWith(action: v.isEmpty ? null : v)),
      ),
      const SizedBox(height: 12),
      _StringListEditor(
        label: 'Emit events',
        values: n.emit,
        enabled: editable,
        onChanged: (list) => c.replaceNode(n.copyWith(emit: list)),
      ),
    ];
  }

  String _typeName(DagNode n) => switch (n) {
        TaskNode() => 'Task',
        BranchNode() => 'Branch',
        TerminalNode() => 'Terminal',
      };
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall),
        ),
      );
}

/// A debounce-free text field that keeps its own controller across rebuilds.
class _TextField extends StatefulWidget {
  const _TextField({
    required this.nodeId,
    required this.field,
    required this.label,
    required this.initial,
    required this.enabled,
    required this.onChanged,
  });

  final String nodeId;
  final String field;
  final String label;
  final String initial;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late final TextEditingController _c =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _c,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.label,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      onChanged: widget.onChanged,
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.enabled,
    required this.onChanged,
    this.allowEmpty = false,
  });

  final String label;
  final String? value;
  final Map<String, String> items;
  final bool enabled;
  final bool allowEmpty;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = items.keys.toSet();
    return DropdownButtonFormField<String?>(
      initialValue: values.contains(value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(
          labelText: label, isDense: true, border: const OutlineInputBorder()),
      items: [
        if (allowEmpty)
          const DropdownMenuItem<String?>(value: null, child: Text('— none —')),
        for (final e in items.entries)
          DropdownMenuItem<String?>(value: e.key, child: Text(e.value)),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}

/// Edits a set of node-id edges as removable chips + an "add" dropdown.
class _EdgeEditor extends StatelessWidget {
  const _EdgeEditor({
    required this.label,
    required this.targets,
    required this.candidates,
    required this.enabled,
    required this.onAdd,
    required this.onRemove,
  });

  final String label;
  final List<String> targets;
  final List<String> candidates;
  final bool enabled;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final addable = candidates.where((c) => !targets.contains(c)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            for (final t in targets)
              InputChip(
                label: Text(t),
                onDeleted: enabled ? () => onRemove(t) : null,
                visualDensity: VisualDensity.compact,
              ),
            if (enabled && addable.isNotEmpty)
              ActionChip(
                avatar: const Icon(Icons.add, size: 16),
                label: const Text('add'),
                onPressed: () async {
                  final picked = await showMenu<String>(
                    context: context,
                    position: _menuPos(context),
                    items: [
                      for (final c in addable)
                        PopupMenuItem(value: c, child: Text(c)),
                    ],
                  );
                  if (picked != null) onAdd(picked);
                },
              ),
          ],
        ),
      ],
    );
  }
}

/// Free-text string list (emit events) as chips + add.
class _StringListEditor extends StatefulWidget {
  const _StringListEditor({
    required this.label,
    required this.values,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final List<String> values;
  final bool enabled;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_StringListEditor> createState() => _StringListEditorState();
}

class _StringListEditorState extends State<_StringListEditor> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _add() {
    final v = _c.text.trim();
    if (v.isEmpty || widget.values.contains(v)) return;
    widget.onChanged([...widget.values, v]);
    _c.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          children: [
            for (final v in widget.values)
              InputChip(
                label: Text(v),
                onDeleted: widget.enabled
                    ? () => widget.onChanged(
                        widget.values.where((e) => e != v).toList())
                    : null,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
        if (widget.enabled)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _c,
                  decoration: const InputDecoration(
                      isDense: true, hintText: 'event name'),
                  onSubmitted: (_) => _add(),
                ),
              ),
              IconButton(onPressed: _add, icon: const Icon(Icons.add)),
            ],
          ),
      ],
    );
  }
}

class _ArmRow extends StatefulWidget {
  const _ArmRow({
    super.key,
    required this.nodeId,
    required this.index,
    required this.arm,
    required this.candidates,
    required this.enabled,
    required this.onExpression,
    required this.onTarget,
    required this.onRemove,
  });

  final String nodeId;
  final int index;
  final BranchArm arm;
  final List<String> candidates;
  final bool enabled;
  final ValueChanged<String> onExpression;
  final ValueChanged<String> onTarget;
  final VoidCallback onRemove;

  @override
  State<_ArmRow> createState() => _ArmRowState();
}

class _ArmRowState extends State<_ArmRow> {
  late final TextEditingController _expr =
      TextEditingController(text: widget.arm.expression);

  @override
  void dispose() {
    _expr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final candidates = widget.candidates.toSet();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _expr,
              enabled: widget.enabled,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              decoration: const InputDecoration(
                  isDense: true, hintText: "expr e.g. decision == 'APPROVED'"),
              onChanged: widget.onExpression,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.arrow_forward, size: 16),
          ),
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              isExpanded: true,
              value: candidates.contains(widget.arm.next) ? widget.arm.next : null,
              hint: const Text('target'),
              items: [
                for (final c in widget.candidates)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: widget.enabled
                  ? (v) => v == null ? null : widget.onTarget(v)
                  : null,
            ),
          ),
          if (widget.enabled)
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.close, size: 16),
            ),
        ],
      ),
    );
  }
}

RelativeRect _menuPos(BuildContext context) {
  final box = context.findRenderObject() as RenderBox;
  final pos = box.localToGlobal(Offset.zero);
  return RelativeRect.fromLTRB(
      pos.dx, pos.dy + box.size.height, pos.dx + 1, 0);
}
