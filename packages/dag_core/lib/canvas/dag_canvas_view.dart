/// The visual DAG canvas (build doc §7), DECOUPLED for reuse (Ops View C.1/C.2):
/// a pure presentational widget — no Riverpod, no controller import. The
/// Designer wraps it with its editor controller (drag/select/connect wired via
/// callbacks); the read-only Ops View passes `editable: false` and no mutation
/// callbacks, so no edit affordance is even constructed.
///
/// Renders each node at its persisted [NodeLayout] inside a pan/zoom viewport,
/// draws the edges (task `next`, branch arms) behind the nodes with a
/// [CustomPainter], and supports:
///   * dragging a node to reposition it (when [onMoveNode] is provided),
///   * selecting a node (drives inspector/validation focus in the Designer),
///   * click-to-connect: tap a node's ► handle then a target (when [onConnect]).
library;

import 'package:flutter/material.dart';

import '../domain/models/dag.dart';
import '../domain/models/dag_node.dart';
import '../domain/models/node_layout.dart';
import '../theme/status_colors.dart';

const double _nodeW = 168;
const double _nodeH = 66;

/// Per-node RUN-STATE decoration for the read-only Ops overlay (Ops View C.2):
/// the host app computes run state (completed/active/failed/notReached) from
/// the audited ops API and hands the canvas pure visuals — the canvas itself
/// knows nothing about runs. All fields optional; a node with no overlay
/// renders exactly as in the Designer.
class NodeOverlay {
  const NodeOverlay({this.accent, this.badge, this.dimmed = false});

  /// Overrides the node-kind accent (stripe + border tint).
  final Color? accent;

  /// Small status chip rendered next to the label (e.g. "failed", "active").
  final String? badge;

  /// notReached: fades the whole node so the taken path pops.
  final bool dimmed;
}

/// Default node label when the host app supplies no capability-aware labeler.
String defaultNodeLabel(DagNode node) => switch (node) {
      TaskNode(:final capability) => capability,
      BranchNode(:final arms) => 'Branch · ${arms.length} arm(s)',
      ParallelNode(:final branches) => 'Parallel · ${branches.length}',
      JoinNode(:final policy) => 'Join · ${policy.name}',
      WaitNode(:final waitFor) => 'Wait · $waitFor',
      TimerNode() => 'Timer',
      HumanNode(:final assignTo) => 'Human · ${assignTo ?? "?"}',
      ForeachNode() => 'Foreach',
      SubjourneyNode(:final journeyKey) => 'Sub · $journeyKey',
      TerminalNode(:final action) => action ?? 'End',
    };

class DagCanvasView extends StatefulWidget {
  const DagCanvasView({
    super.key,
    required this.dag,
    this.selectedNodeId,
    this.invalidNodeIds = const <String>{},
    this.editable = false,
    this.nodeLabel,
    this.nodeOverlay,
    this.onSelect,
    this.onMoveNode,
    this.onConnect,
    this.emptyMessage,
  });

  final Dag dag;
  final String? selectedNodeId;
  final Set<String> invalidNodeIds;

  /// Gates drag-move and connect affordances; pan/zoom/select always work.
  final bool editable;

  final String Function(DagNode node)? nodeLabel;

  /// Optional run-state decoration per node (Ops overlay). Null = plain render.
  final NodeOverlay? Function(DagNode node)? nodeOverlay;
  final ValueChanged<String?>? onSelect;
  final void Function(String nodeId, double x, double y)? onMoveNode;
  final void Function(String fromId, String toId)? onConnect;
  final String? emptyMessage;

  @override
  State<DagCanvasView> createState() => _DagCanvasViewState();
}

class _DagCanvasViewState extends State<DagCanvasView> {
  final _viewer = TransformationController();
  String? _connectFrom;

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  bool get _canConnect => widget.editable && widget.onConnect != null;
  bool get _canMove => widget.editable && widget.onMoveNode != null;

  @override
  Widget build(BuildContext context) {
    final dag = widget.dag;
    if (dag.nodes.isEmpty) {
      return _EmptyCanvas(
          message: widget.emptyMessage ?? 'This version has no nodes.');
    }

    final label = widget.nodeLabel ?? defaultNodeLabel;

    // Canvas extent from the furthest node, plus room to drag outward.
    double maxX = 0, maxY = 0;
    for (final n in dag.nodes) {
      final p = dag.layout[n.id] ?? const NodeLayout(x: 0, y: 0);
      if (p.x > maxX) maxX = p.x;
      if (p.y > maxY) maxY = p.y;
    }
    final size = Size(maxX + _nodeW + 240, maxY + _nodeH + 240);

    return Stack(
      children: [
        Positioned.fill(
          child: InteractiveViewer(
            transformationController: _viewer,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(400),
            minScale: 0.4,
            maxScale: 2.0,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  // Edges behind the nodes.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _EdgePainter(
                        dag: dag,
                        selected: widget.selectedNodeId,
                      ),
                    ),
                  ),
                  // Tap empty space to clear selection.
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => widget.onSelect?.call(null),
                    ),
                  ),
                  for (final node in dag.nodes)
                    _PositionedNode(
                      node: node,
                      layout:
                          dag.layout[node.id] ?? const NodeLayout(x: 0, y: 0),
                      label: label(node),
                      overlay: widget.nodeOverlay?.call(node),
                      selected: widget.selectedNodeId == node.id,
                      isStart: dag.startNodeId == node.id,
                      hasError: widget.invalidNodeIds.contains(node.id),
                      connecting: _connectFrom != null,
                      isConnectSource: _connectFrom == node.id,
                      editable: widget.editable,
                      onTap: () => _onNodeTap(node.id),
                      onDrag: _canMove
                          ? (delta) {
                              final cur = dag.layout[node.id] ??
                                  const NodeLayout(x: 0, y: 0);
                              widget.onMoveNode!(
                                node.id,
                                cur.x + delta.dx / _scale,
                                cur.y + delta.dy / _scale,
                              );
                            }
                          : null,
                      onStartConnect: _canConnect && node is! TerminalNode
                          ? () => setState(() => _connectFrom = node.id)
                          : null,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_connectFrom != null)
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                color: StatusColors.pending,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Click a target node to connect',
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => setState(() => _connectFrom = null),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          right: 8,
          bottom: 8,
          child: _ZoomControls(controller: _viewer),
        ),
      ],
    );
  }

  double get _scale => _viewer.value.getMaxScaleOnAxis();

  void _onNodeTap(String nodeId) {
    if (_connectFrom != null) {
      if (_connectFrom != nodeId) widget.onConnect?.call(_connectFrom!, nodeId);
      setState(() => _connectFrom = null);
      return;
    }
    widget.onSelect?.call(nodeId);
  }
}

class _PositionedNode extends StatelessWidget {
  const _PositionedNode({
    required this.node,
    required this.layout,
    required this.label,
    required this.overlay,
    required this.selected,
    required this.isStart,
    required this.hasError,
    required this.connecting,
    required this.isConnectSource,
    required this.editable,
    required this.onTap,
    required this.onDrag,
    required this.onStartConnect,
  });

  final DagNode node;
  final NodeLayout layout;
  final String label;
  final NodeOverlay? overlay;
  final bool selected;
  final bool isStart;
  final bool hasError;
  final bool connecting;
  final bool isConnectSource;
  final bool editable;
  final VoidCallback onTap;
  final void Function(Offset delta)? onDrag;
  final VoidCallback? onStartConnect;

  /// Which engine tier still owes EXECUTION for this node, if any — so authors
  /// don't assume a drawn meter/saga/async node runs today. null = T1 (runs now).
  String? get _tierBadge => switch (node) {
        WaitNode() || TimerNode() => 'T3',
        HumanNode() || ForeachNode() || SubjourneyNode() => 'T4',
        TaskNode(:final policies, :final compensation)
            when policies?.meter != null || compensation != null =>
          'T2',
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final kindAccent = switch (node) {
      TaskNode() => StatusColors.pending,
      BranchNode() || ParallelNode() || JoinNode() => StatusColors.draft,
      WaitNode() || TimerNode() || HumanNode() => const Color(0xFF8A63D2),
      ForeachNode() || SubjourneyNode() => const Color(0xFF1F9E8F),
      TerminalNode() => StatusColors.published,
    };
    final accent = overlay?.accent ?? kindAccent;
    final borderColor = hasError
        ? StatusColors.rejected
        : isConnectSource
            ? StatusColors.pending
            : selected
                ? scheme.primary
                : accent.withAlpha(overlay?.accent != null ? 255 : 153);

    Widget positioned = GestureDetector(
        onTap: onTap,
        onPanUpdate: onDrag == null ? null : (d) => onDrag!(d.delta),
        child: MouseRegion(
          cursor:
              editable ? SystemMouseCursors.grab : SystemMouseCursors.click,
          child: Container(
            width: _nodeW,
            height: _nodeH,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2027),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: borderColor, width: selected || isConnectSource ? 2 : 1),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
              child: Row(
                children: [
                  Container(width: 4, height: double.infinity, color: accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            if (isStart)
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(Icons.play_arrow,
                                    size: 13, color: StatusColors.published),
                              ),
                            Flexible(
                              child: Text(label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ),
                            if (_tierBadge != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Tooltip(
                                  message:
                                      'Authored, not yet executed by the engine ($_tierBadge tier)',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0x40E0A100),
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          color: const Color(0xFFE0A100)),
                                    ),
                                    child: Text(_tierBadge!,
                                        style: const TextStyle(
                                            fontSize: 8.5,
                                            color: Color(0xFFE0A100),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            if (overlay?.badge != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: accent.withAlpha(56),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(color: accent),
                                  ),
                                  child: Text(overlay!.badge!,
                                      style: TextStyle(
                                          fontSize: 8.5,
                                          color: accent,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                          ],
                        ),
                        Text(node.id,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withAlpha(128))),
                      ],
                    ),
                  ),
                  if (onStartConnect != null)
                    Tooltip(
                      message: 'Drag an edge from here',
                      child: InkWell(
                        onTap: onStartConnect,
                        child: Icon(Icons.east,
                            size: 18,
                            color: connecting
                                ? Colors.white24
                                : scheme.primary),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );

    if (overlay?.dimmed ?? false) {
      positioned = Opacity(opacity: 0.35, child: positioned);
    }
    return Positioned(left: layout.x, top: layout.y, child: positioned);
  }
}

/// Draws edges as cubic beziers from a source's right edge to a target's left
/// edge. Branch arms are dashed + labelled with the (truncated) expression.
class _EdgePainter extends CustomPainter {
  _EdgePainter({required this.dag, required this.selected});

  final Dag dag;
  final String? selected;

  @override
  void paint(Canvas canvas, Size size) {
    for (final node in dag.nodes) {
      final from = dag.layout[node.id];
      if (from == null) continue;
      final start = Offset(from.x + _nodeW, from.y + _nodeH / 2);
      final isSel = selected == node.id;

      switch (node) {
        case BranchNode(:final arms, :final defaultNext):
          for (final a in arms) {
            _edge(canvas, start, a.next, isSel, label: a.when, dashed: true);
          }
          if (defaultNext != null) {
            _edge(canvas, start, defaultNext, isSel,
                label: 'default', dashed: true);
          }
        case HumanNode(:final outcomes):
          for (final o in outcomes) {
            _edge(canvas, start, o.next, isSel, label: o.value, dashed: true);
          }
        default:
          for (final t in node.successors) {
            _edge(canvas, start, t, isSel, label: null, dashed: false);
          }
      }
    }
  }

  void _edge(Canvas canvas, Offset start, String targetId, bool highlight,
      {String? label, required bool dashed}) {
    final to = dag.layout[targetId];
    if (to == null) return;
    final end = Offset(to.x, to.y + _nodeH / 2);
    final paint = Paint()
      ..color = (highlight ? StatusColors.pending : Colors.white30)
      ..strokeWidth = highlight ? 2.2 : 1.4
      ..style = PaintingStyle.stroke;

    final dx = (end.dx - start.dx).abs().clamp(40, 220) * 0.6;
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(start.dx + dx, start.dy, end.dx - dx, end.dy, end.dx, end.dy);

    if (dashed) {
      _drawDashed(canvas, path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
    _arrowHead(canvas, end, paint..style = PaintingStyle.fill);

    if (label != null && label.isNotEmpty) {
      final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2 - 8);
      final text = label.length > 22 ? '${label.substring(0, 21)}…' : label;
      final tp = TextPainter(
        text: TextSpan(
            text: text,
            style: const TextStyle(fontSize: 10, color: Colors.white70)),
        textDirection: TextDirection.ltr,
      )..layout();
      final bg = Rect.fromLTWH(
          mid.dx - tp.width / 2 - 4, mid.dy - 2, tp.width + 8, tp.height + 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(bg, const Radius.circular(4)),
        Paint()..color = const Color(0xFF101317),
      );
      tp.paint(canvas, Offset(mid.dx - tp.width / 2, mid.dy));
    }
  }

  void _arrowHead(Canvas canvas, Offset tip, Paint paint) {
    const s = 5.0;
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - s * 1.6, tip.dy - s)
      ..lineTo(tip.dx - s * 1.6, tip.dy + s)
      ..close();
    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final seg = metric.extractPath(d, d + 7);
        canvas.drawPath(seg, paint);
        d += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EdgePainter old) =>
      old.dag != dag || old.selected != selected;
}

class _ZoomControls extends StatelessWidget {
  const _ZoomControls({required this.controller});
  final TransformationController controller;

  void _zoom(double factor) {
    final m = controller.value.clone()
      ..multiply(Matrix4.diagonal3Values(factor, factor, factor));
    controller.value = m;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton.small(
          heroTag: 'zoomIn',
          onPressed: () => _zoom(1.15),
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 6),
        FloatingActionButton.small(
          heroTag: 'zoomOut',
          onPressed: () => _zoom(0.87),
          child: const Icon(Icons.remove),
        ),
        const SizedBox(height: 6),
        FloatingActionButton.small(
          heroTag: 'zoomReset',
          onPressed: () => controller.value = Matrix4.identity(),
          child: const Icon(Icons.center_focus_strong),
        ),
      ],
    );
  }
}

class _EmptyCanvas extends StatelessWidget {
  const _EmptyCanvas({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_tree_outlined, size: 56),
          const SizedBox(height: 12),
          Text(message),
        ],
      ),
    );
  }
}
