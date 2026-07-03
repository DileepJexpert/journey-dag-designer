/// The overlay mapping rules (spec C.2): four states, no "pending", and the
/// terminal-freeze rule — an ENDED run may never render live work.
library;

import 'package:dag_core/dag_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/domain/models.dart';
import 'package:journey_ops_view/domain/ops_status.dart';
import 'package:journey_ops_view/domain/overlay_mapper.dart';

TransitionEntry _t(int seq, String node, String status) => TransitionEntry(
    seq: seq, nodeId: node, status: status, at: DateTime.utc(2026, 7, 3, 10, seq));

RunDetail _run({
  required OpsStatus status,
  required List<TransitionEntry> transitions,
}) =>
    RunDetail(
      runId: 'r1',
      journeyKey: 'loan-origination',
      journeyVersion: 1,
      status: status,
      sfdcNotified: SfdcNotified.none,
      startedAt: DateTime.utc(2026, 7, 3, 10),
      transitions: transitions,
    );

void main() {
  final graph = seedLoanDag();

  test('running run: completed / active / notReached — never "pending"', () {
    final result = mapRunOntoGraph(
      graph,
      _run(status: OpsStatus.running, transitions: [
        _t(0, 'n_customer', 'DISPATCHED'),
        _t(1, 'n_customer', 'COMPLETED'),
        _t(2, 'n_kyc', 'DISPATCHED'),
      ]),
    );
    expect(result.states['n_customer'], NodeRunState.completed);
    expect(result.states['n_kyc'], NodeRunState.active);
    for (final id in ['n_bureau', 'n_score', 'n_decide', 'n_book', 'n_done', 'n_reject']) {
      expect(result.states[id], NodeRunState.notReached, reason: id);
    }
    // Every graph node got exactly one of the four states.
    expect(result.states.length, graph.nodes.length);
    expect(result.orphanNodeIds, isEmpty);
  });

  test('failed transition renders failed — and outlives a completion', () {
    final result = mapRunOntoGraph(
      graph,
      _run(status: OpsStatus.failedNotifyPending, transitions: [
        _t(0, 'n_customer', 'COMPLETED'),
        _t(1, 'n_kyc', 'DISPATCHED'),
        _t(2, 'n_kyc', 'FAILED'),
      ]),
    );
    expect(result.states['n_kyc'], NodeRunState.failed);
    expect(result.states['n_customer'], NodeRunState.completed);
  });

  test('TERMINAL RUN FREEZES notReached: a dispatched-but-unfinished node on '
      'an ended run must NOT render as active', () {
    final transitions = [
      _t(0, 'n_customer', 'COMPLETED'),
      _t(1, 'n_kyc', 'DISPATCHED'), // never completed, never failed
    ];

    // Same transitions, run still RUNNING -> active.
    final live = mapRunOntoGraph(
        graph, _run(status: OpsStatus.running, transitions: transitions));
    expect(live.states['n_kyc'], NodeRunState.active);

    // Run ended (any terminal status) -> frozen to notReached, NOT active.
    for (final terminal in [
      OpsStatus.completedApproved,
      OpsStatus.completedDeclined,
      OpsStatus.failedSfdcNotified,
      OpsStatus.failedNotifyPending,
    ]) {
      final frozen = mapRunOntoGraph(
          graph, _run(status: terminal, transitions: transitions));
      expect(frozen.states['n_kyc'], NodeRunState.notReached,
          reason: 'terminal $terminal must freeze the dispatched node');
      expect(frozen.states.values, isNot(contains(NodeRunState.active)),
          reason: 'nothing on an ended run may render as live work');
    }
  });

  test('wait/timer/human nodes active within budget = waiting (by design)', () {
    const waitingGraph = Dag(
      startNodeId: 'n_wait',
      nodes: [
        DagNode.wait(id: 'n_wait', waitFor: 'callback', next: ['n_end']),
        DagNode.terminal(id: 'n_end'),
      ],
      layout: {},
    );
    final live = mapRunOntoGraph(
      waitingGraph,
      _run(status: OpsStatus.running, transitions: [
        _t(0, 'n_wait', 'DISPATCHED'),
      ]),
    );
    expect(live.states['n_wait'], NodeRunState.waitingByDesign);

    // Terminal freeze applies to waiting nodes too.
    final frozen = mapRunOntoGraph(
      waitingGraph,
      _run(status: OpsStatus.failedNotifyPending, transitions: [
        _t(0, 'n_wait', 'DISPATCHED'),
      ]),
    );
    expect(frozen.states['n_wait'], NodeRunState.notReached);
  });

  test('transitions referencing nodes the graph does not know become orphans '
      '(warn chips), never dropped and never polluting graph states', () {
    final result = mapRunOntoGraph(
      graph,
      _run(status: OpsStatus.completedApproved, transitions: [
        _t(0, 'n_customer', 'COMPLETED'),
        _t(1, 'n_legacy_check', 'DISPATCHED'),
        _t(2, 'n_legacy_check', 'COMPLETED'),
        _t(3, 'n_book', 'COMPLETED'),
      ]),
    );
    expect(result.orphanNodeIds, ['n_legacy_check']);
    expect(result.states.containsKey('n_legacy_check'), isFalse);
    expect(result.states['n_book'], NodeRunState.completed);
  });
}
