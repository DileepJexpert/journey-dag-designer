/// The Designer's canvas: dag_core's presentational [DagCanvasView] wired to
/// the editor controller (extraction seam, Ops View C.1). All drawing/panning/
/// connect UX lives in dag_core — shared with the read-only Ops View; this
/// wrapper only supplies the editor state and mutation callbacks, plus the
/// capability-aware node labels the shared view can't know about.
library;

import 'package:dag_core/dag_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/capability.dart';
import '../editor_controller.dart';

class DagCanvas extends ConsumerWidget {
  const DagCanvas({super.key, required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = editorControllerProvider(journeyId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    return DagCanvasView(
      dag: state.dag,
      selectedNodeId: state.selectedNodeId,
      invalidNodeIds: state.validation.invalidNodeIds,
      editable: state.isEditable,
      nodeLabel: (node) => _labelFor(node, state.capabilities),
      onSelect: controller.select,
      onMoveNode: controller.moveNode,
      onConnect: controller.connect,
      emptyMessage: state.isEditable
          ? 'Empty journey — add nodes from the palette on the left.'
          : 'This version has no nodes.',
    );
  }

  /// Task nodes show the registered capability NAME; everything else uses the
  /// shared default labels.
  String _labelFor(DagNode node, List<Capability> capabilities) {
    if (node is TaskNode) {
      for (final c in capabilities) {
        if (c.key == node.capability) return c.name;
      }
      return node.capability;
    }
    return defaultNodeLabel(node);
  }
}
