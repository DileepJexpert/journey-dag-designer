/// One run, forensically (spec C.2): the run's identity + status, the PINNED
/// version's graph with the run overlaid, the sequence-ordered transition
/// timeline (authoritative even when the graph isn't renderable), the DLQ
/// pointer for failed runs, and sibling runs that touched the same SFDC record.
library;

import 'dart:math' as math;

import 'package:dag_core/dag_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/graph_repository.dart';
import '../../domain/models.dart';
import '../../domain/overlay_mapper.dart';
import '../common/status_visuals.dart';
import '../common/timestamp_text.dart';

class RunDetailScreen extends ConsumerStatefulWidget {
  const RunDetailScreen({super.key, required this.runId});

  final String runId;

  @override
  ConsumerState<RunDetailScreen> createState() => _RunDetailScreenState();
}

class _RunDetailScreenState extends ConsumerState<RunDetailScreen> {
  late Future<RunDetail?> _detail;

  @override
  void initState() {
    super.initState();
    _detail = ref.read(opsApiProvider).detail(widget.runId);
  }

  void _reload() {
    setState(() {
      _detail = ref.read(opsApiProvider).detail(widget.runId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Run ${widget.runId}'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: _reload),
        ],
      ),
      body: FutureBuilder<RunDetail?>(
        future: _detail,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
                child: Text('Could not load run: ${snap.error}',
                    textAlign: TextAlign.center));
          }
          final run = snap.data;
          if (run == null) {
            return const Center(child: Text('No run with this id.'));
          }
          return _RunDetailBody(run: run);
        },
      ),
    );
  }
}

class _RunDetailBody extends ConsumerStatefulWidget {
  const _RunDetailBody({required this.run});

  final RunDetail run;

  @override
  ConsumerState<_RunDetailBody> createState() => _RunDetailBodyState();
}

class _RunDetailBodyState extends ConsumerState<_RunDetailBody> {
  /// One graph fetch shared by the graph card AND the timeline (which flags
  /// transitions whose nodeId the graph doesn't know — orphan warn chips).
  late Future<PinnedGraph> _graph;

  @override
  void initState() {
    super.initState();
    _graph = ref
        .read(graphRepositoryProvider)
        .graphFor(widget.run.journeyKey, widget.run.journeyVersion);
  }

  @override
  Widget build(BuildContext context) {
    final run = widget.run;
    return FutureBuilder<PinnedGraph>(
      future: _graph,
      builder: (context, snap) {
        final loading = snap.connectionState != ConnectionState.done;
        final pinned = snap.hasError ? null : snap.data;
        final graphNodeIds =
            pinned?.dag.nodes.map((n) => n.id).toSet();
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _HeaderCard(run: run),
            const SizedBox(height: 10),
            _GraphCard(
                run: run,
                pinned: pinned,
                loading: loading,
                error: snap.error),
            const SizedBox(height: 10),
            _GanttCard(run: run),
            const SizedBox(height: 10),
            _TimelineCard(run: run, graphNodeIds: graphNodeIds),
            const SizedBox(height: 10),
            _RelatedRunsCard(run: run),
          ],
        );
      },
    );
  }
}

// ---- header -----------------------------------------------------------------

class _HeaderCard extends ConsumerWidget {
  const _HeaderCard({required this.run});

  final RunDetail run;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider)();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                StatusChip(status: run.status),
                _VersionChip(run: run),
                if (run.stuck) const StuckBadge(),
                Text('notify: ${run.sfdcNotified.wire}',
                    style: const TextStyle(
                        fontSize: 11.5, color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 18,
              runSpacing: 6,
              children: [
                _IdRow(label: 'runId', value: run.runId),
                if (run.correlationId != null)
                  _IdRow(label: 'correlationId', value: run.correlationId!),
                if (run.notificationId != null)
                  _IdRow(label: 'notificationId', value: run.notificationId!),
                if (run.sfdcRecordId != null)
                  _IdRow(label: 'sfdcRecordId', value: run.sfdcRecordId!),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('started ', style: TextStyle(fontSize: 12)),
                TimestampText(run.startedAt,
                    style: const TextStyle(fontSize: 12)),
                if (run.endedAt != null) ...[
                  const Text('  ended ', style: TextStyle(fontSize: 12)),
                  TimestampText(run.endedAt!,
                      style: const TextStyle(fontSize: 12)),
                ],
              ],
            ),
            // Tier-1 wall-clock line: total duration (ended) or age +
            // time-in-current-node (live), plus WHEN the sweeper will act.
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _liveline(now),
            ),
            if (run.compensationOf != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(Icons.undo, size: 15, color: Color(0xFFE0A100)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        run.compensationPending.isEmpty
                            ? 'Compensation for the failure at ${run.compensationOf} is COMPLETE.'
                            : 'COMPENSATING the failure at ${run.compensationOf} — '
                                'still undoing: ${run.compensationPending.join(', ')} '
                                '(decision already sent to the channel).',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFFE0A100)),
                      ),
                    ),
                  ],
                ),
              ),
            if (run.terminalNodeId != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'terminal: ${run.terminalNodeId} → ${run.terminalOutcome ?? '?'}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            if (run.dlqTopicRef != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(Icons.inbox_outlined, size: 15),
                    const SizedBox(width: 6),
                    const Text('DLQ ref: ', style: TextStyle(fontSize: 12)),
                    SelectableText(run.dlqTopicRef!,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    _CopyButton(
                        value: run.dlqTopicRef!, what: 'DLQ topic ref'),
                    const SizedBox(width: 4),
                    const Flexible(
                      child: Text(
                        '(pointer only — DLQ content is masked in Brod)',
                        style:
                            TextStyle(fontSize: 10.5, color: Colors.white54),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension on _HeaderCard {
  Widget _liveline(DateTime now) {
    const style = TextStyle(fontSize: 12, color: Colors.white70);
    if (run.endedAt != null) {
      return Text('took ${formatDuration(run.duration!)}', style: style);
    }
    final parts = <String>['live for ${formatDuration(now.difference(run.startedAt))}'];
    if (run.transitions.isNotEmpty) {
      final last = run.transitions.last;
      parts.add('in ${last.nodeId} for '
          '${formatDuration(now.difference(last.at))}');
    }
    final deadline = run.sweepDeadline;
    if (deadline != null) {
      parts.add(deadline.isAfter(now)
          ? 'sweeper acts at ${formatIstShort(deadline)} '
              '(in ${formatDuration(deadline.difference(now))})'
          : 'sweeper OVERDUE — force-fail imminent');
    }
    return Text(parts.join('  ·  '), style: style);
  }
}

class _VersionChip extends StatelessWidget {
  const _VersionChip({required this.run});

  final RunDetail run;

  @override
  Widget build(BuildContext context) {
    final legacy = run.isLegacyVersion;
    return Tooltip(
      message: legacy
          ? 'Pre-pinning run: no recorded version — graph shown is the CURRENT one, approximate'
          : 'This run is PINNED to ${run.journeyKey} v${run.journeyVersion}; it renders against that exact version',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: legacy ? const Color(0xFFE0A100) : Colors.white38),
        ),
        child: Text(
          legacy
              ? '${run.journeyKey} · legacy (v0)'
              : '${run.journeyKey} @v${run.journeyVersion}',
          style: TextStyle(
            fontSize: 11.5,
            color: legacy ? const Color(0xFFE0A100) : Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _IdRow extends StatelessWidget {
  const _IdRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ',
            style: const TextStyle(fontSize: 11.5, color: Colors.white54)),
        SelectableText(value, style: const TextStyle(fontSize: 11.5)),
        _CopyButton(value: value, what: label),
      ],
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.value, required this.what});

  final String value;
  final String what;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: value));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$what copied'), duration: const Duration(seconds: 1)));
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Icon(Icons.copy, size: 13),
      ),
    );
  }
}

// ---- graph -------------------------------------------------------------------

class _GraphCard extends StatelessWidget {
  const _GraphCard({
    required this.run,
    required this.pinned,
    required this.loading,
    required this.error,
  });

  final RunDetail run;
  final PinnedGraph? pinned;
  final bool loading;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: _buildContent(context),
      ),
    );
  }

  /// OPS P2: enrich the run-state badge with the node's stats — the failure
  /// CLASS on failed nodes ("failed · PERMANENT") and the retry ladder on
  /// re-dispatched ones ("active · try 2/3" when the pinned graph declares
  /// maxAttempts; "try 2" otherwise).
  NodeOverlay? _decorated(DagNode node, NodeOverlay base) {
    final stat = run.statOf(node.id);
    if (stat == null) {
      return base;
    }
    var badge = base.badge;
    if (badge == 'failed' && stat.failureClass != null) {
      badge = 'failed · ${stat.failureClass}';
    } else if (stat.attempts > 1) {
      final max = node is TaskNode ? node.policies?.retry?.maxAttempts : null;
      final tries = max == null ? 'try ${stat.attempts}' : 'try ${stat.attempts}/$max';
      badge = badge == null ? tries : '$badge · $tries';
    }
    return NodeOverlay(accent: base.accent, badge: badge, dimmed: base.dimmed);
  }

  Widget _buildContent(BuildContext context) {
    if (loading) {
      return const SizedBox(
          height: 120, child: Center(child: CircularProgressIndicator()));
    }
    final graph = pinned;
    if (graph == null) {
      // Registry down / version unknown -> TIMELINE-ONLY fallback.
      return Row(
        children: [
          const Icon(Icons.cloud_off, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Graph unavailable (${error ?? 'unknown error'}). The '
              'transition timeline below is the authoritative run history.',
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
        ],
      );
    }
    final overlay = mapRunOntoGraph(graph.dag, run);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              graph.approximate
                  ? 'Graph — CURRENT version'
                  : 'Graph — pinned v${run.journeyVersion}',
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            if (graph.approximate)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0x33E0A100),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE0A100)),
                ),
                child: const Text(
                  'legacy, approximate',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFFE0A100)),
                ),
              ),
          ],
        ),
        if (overlay.orphanNodeIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_outlined,
                    size: 15, color: Color(0xFFE0A100)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'The run history references node(s) not in this graph: '
                    '${overlay.orphanNodeIds.join(', ')} — see the timeline; '
                    'the graph cannot show them.',
                    style: const TextStyle(
                        fontSize: 11.5, color: Color(0xFFE0A100)),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        SizedBox(
          height: 360,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DagCanvasView(
              dag: graph.dag,
              nodeOverlay: (node) => _decorated(
                  node,
                  StatusVisuals.overlayOf(
                      overlay.states[node.id] ?? NodeRunState.notReached)),
            ),
          ),
        ),
      ],
    );
  }
}

// ---- timeline ------------------------------------------------------------------

// ---- gantt (Temporal-style duration bars) ----------------------------------

/// A run's transitions collapsed to one span per node: first DISPATCH → the
/// node's terminal (COMPLETED/FAILED), or open to endedAt/now while in-flight.
class _NodeSpan {
  _NodeSpan(this.nodeId, this.start, this.end, this.status);
  final String nodeId;
  final DateTime start;
  final DateTime end;
  final String status; // COMPLETED / FAILED / DISPATCHED (still running)
  Duration get duration => end.difference(start);
}

List<_NodeSpan> _spansOf(List<TransitionEntry> transitions, DateTime fallbackEnd) {
  final order = <String>[];
  final start = <String, DateTime>{};
  final end = <String, DateTime>{};
  final status = <String, String>{};
  for (final t in transitions) {
    if (!start.containsKey(t.nodeId) && !end.containsKey(t.nodeId)) {
      order.add(t.nodeId);
    }
    if (t.status == 'DISPATCHED') {
      start.putIfAbsent(t.nodeId, () => t.at);
    } else {
      end[t.nodeId] = t.at;
      status[t.nodeId] = t.status;
      start.putIfAbsent(t.nodeId, () => t.at); // instant node (branch/terminal)
    }
  }
  final spans = <_NodeSpan>[];
  for (final id in order) {
    final s = start[id]!;
    var e = end[id] ?? fallbackEnd; // open bar for an in-flight node
    if (e.isBefore(s)) e = s;
    spans.add(_NodeSpan(id, s, e, status[id] ?? 'DISPATCHED'));
  }
  return spans;
}

/// Temporal-style timeline: one horizontal bar per node, positioned and scaled
/// to the run's wall-clock window, so a slow node is obvious at a glance. Built
/// from the SAME transitions the list below renders — no new data, read-only.
class _GanttCard extends ConsumerWidget {
  const _GanttCard({required this.run});
  final RunDetail run;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transitions = [...run.transitions]
      ..sort((a, b) => a.seq.compareTo(b.seq));
    final spans = transitions.isEmpty
        ? const <_NodeSpan>[]
        : _spansOf(transitions, run.endedAt ?? ref.read(nowProvider)());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Timeline — durations',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (spans.isEmpty)
              const Text('No transitions recorded yet.',
                  style: TextStyle(fontSize: 12))
            else
              ..._bars(spans),
          ],
        ),
      ),
    );
  }

  List<Widget> _bars(List<_NodeSpan> spans) {
    final windowStart =
        spans.map((s) => s.start).reduce((a, b) => a.isBefore(b) ? a : b);
    var windowEnd =
        spans.map((s) => s.end).reduce((a, b) => a.isAfter(b) ? a : b);
    if (!windowEnd.isAfter(windowStart)) {
      windowEnd = windowStart.add(const Duration(milliseconds: 1));
    }
    final spanMs = windowEnd.difference(windowStart).inMilliseconds;
    return [
      for (final s in spans)
        _GanttRow(
          span: s,
          startFrac: s.start.difference(windowStart).inMilliseconds / spanMs,
          durFrac: s.duration.inMilliseconds / spanMs,
        ),
      const SizedBox(height: 4),
      Text('total ${formatDuration(windowEnd.difference(windowStart))}',
          style: const TextStyle(fontSize: 10.5, color: Colors.white38)),
    ];
  }
}

class _GanttRow extends StatelessWidget {
  const _GanttRow(
      {required this.span, required this.startFrac, required this.durFrac});
  final _NodeSpan span;
  final double startFrac;
  final double durFrac;

  @override
  Widget build(BuildContext context) {
    final color = switch (span.status) {
      'COMPLETED' => StatusVisuals.nodeCompleted,
      'FAILED' => StatusVisuals.nodeFailed,
      _ => StatusVisuals.nodeActive,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(span.nodeId,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11.5)),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final double w = c.maxWidth;
                final double df = durFrac.clamp(0.0, 1.0).toDouble();
                final double sf = startFrac.clamp(0.0, 1.0).toDouble();
                final double barW = math.max(3.0, df * w);
                final double maxLeft = math.max(0.0, w - barW);
                final double left = math.min(sf * w, maxLeft);
                return SizedBox(
                  height: 16,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      Positioned(
                        left: left,
                        top: 2,
                        bottom: 2,
                        width: barW,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 58,
            child: Text(formatDuration(span.duration),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 10.5, color: Colors.white54)),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.run, required this.graphNodeIds});

  final RunDetail run;

  /// Node ids of the rendered graph, or null while it loads / when the
  /// registry is down (then no orphan judgement can be made).
  final Set<String>? graphNodeIds;

  @override
  Widget build(BuildContext context) {
    // Server emits in sequence order (D11); sort defensively anyway.
    final transitions = [...run.transitions]
      ..sort((a, b) => a.seq.compareTo(b.seq));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Timeline',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            if (transitions.isEmpty)
              const Text('No transitions recorded yet.',
                  style: TextStyle(fontSize: 12)),
            for (var i = 0; i < transitions.length; i++)
              _TransitionRow(
                entry: transitions[i],
                previousAt: i == 0 ? null : transitions[i - 1].at,
                stat: run.statOf(transitions[i].nodeId),
                orphan: graphNodeIds != null &&
                    !graphNodeIds!.contains(transitions[i].nodeId),
              ),
          ],
        ),
      ),
    );
  }
}

class _TransitionRow extends StatelessWidget {
  const _TransitionRow({
    required this.entry,
    required this.orphan,
    this.previousAt,
    this.stat,
  });

  final TransitionEntry entry;

  /// True when the rendered graph doesn't know this nodeId — the row wears a
  /// warn chip instead of being dropped (the history is authoritative).
  final bool orphan;

  /// Tier-1 latency profile: the previous row's timestamp -> "+90s" chip.
  final DateTime? previousAt;

  /// OPS P2 stats for this row's node (attempts / failure class), if any.
  final NodeStat? stat;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (entry.status) {
      'COMPLETED' => (Icons.check_circle_outline, StatusVisuals.nodeCompleted),
      'FAILED' => (Icons.error_outline, StatusVisuals.nodeFailed),
      _ => (Icons.send_outlined, StatusVisuals.nodeActive), // DISPATCHED
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text('#${entry.seq}',
                style:
                    const TextStyle(fontSize: 10.5, color: Colors.white38)),
          ),
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(entry.nodeId, style: const TextStyle(fontSize: 12.5)),
          const SizedBox(width: 6),
          Text(entry.status.toLowerCase(),
              style: TextStyle(fontSize: 11, color: color)),
          if (entry.status == 'FAILED' && stat?.failureClass != null) ...[
            const SizedBox(width: 6),
            Text(stat!.failureClass!,
                style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFD64545),
                    fontWeight: FontWeight.w600)),
          ],
          if (entry.status == 'DISPATCHED' && (stat?.attempts ?? 0) > 1) ...[
            const SizedBox(width: 6),
            Text('attempts ${stat!.attempts}',
                style:
                    const TextStyle(fontSize: 10, color: Colors.white54)),
          ],
          if (orphan) ...[
            const SizedBox(width: 6),
            Tooltip(
              message:
                  'This nodeId is not in the rendered graph (legacy/approximate '
                  'render or schema drift) — the timeline is authoritative',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFFE0A100)),
                ),
                child: const Text('not in graph',
                    style: TextStyle(
                        fontSize: 9.5, color: Color(0xFFE0A100))),
              ),
            ),
          ],
          if (entry.late) ...[
            const SizedBox(width: 6),
            Tooltip(
              message:
                  'Arrived AFTER the run already ended (kept for audit, did not change the outcome)',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFFE0A100)),
                ),
                child: const Text('late',
                    style: TextStyle(
                        fontSize: 9.5, color: Color(0xFFE0A100))),
              ),
            ),
          ],
          const Spacer(),
          if (previousAt != null) ...[
            Text('+${formatDuration(entry.at.difference(previousAt!))}',
                style: const TextStyle(fontSize: 10, color: Colors.white38)),
            const SizedBox(width: 8),
          ],
          TimestampText(entry.at, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

// ---- related runs ---------------------------------------------------------------

class _RelatedRunsCard extends ConsumerWidget {
  const _RelatedRunsCard({required this.run});

  final RunDetail run;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sfdcId = run.sfdcRecordId;
    if (sfdcId == null || sfdcId.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Related runs — same sfdcRecordId ($sfdcId)',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            FutureBuilder(
              future: ref.read(opsApiProvider).search(sfdcId),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(strokeWidth: 2))),
                  );
                }
                if (snap.hasError) {
                  return Text('Could not load related runs: ${snap.error}',
                      style: const TextStyle(fontSize: 11.5));
                }
                final related = (snap.data ?? const [])
                    .where((r) => r.runId != run.runId)
                    .toList();
                if (related.isEmpty) {
                  return const Text(
                      'No other run touched this SFDC record.',
                      style: TextStyle(fontSize: 12));
                }
                return Column(
                  children: [
                    for (final r in related)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            StatusChip(status: r.status, dense: true),
                            Text(r.runId,
                                style: const TextStyle(fontSize: 12.5)),
                          ],
                        ),
                        subtitle: Wrap(
                          spacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text('started ',
                                style: TextStyle(fontSize: 11)),
                            TimestampText(r.startedAt,
                                style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 16),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => RunDetailScreen(runId: r.runId),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
