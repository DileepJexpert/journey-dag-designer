import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/dag_node.dart';
import 'package:journey_dag_designer/domain/services/simulation_engine.dart';

import 'fixtures.dart';

void main() {
  const engine = SimulationEngine();

  test('linear chain fires one node per step, in order', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['b']),
      DagNode.task(id: 'b', capabilityKey: 'bureau', next: ['c']),
      DagNode.terminal(id: 'c'),
    ]);
    final plan = engine.plan(dag);
    expect(plan.steps.map((s) => s.nodeIds), [
      ['a'],
      ['b'],
      ['c'],
    ]);
    expect(plan.firedOrder, ['a', 'b', 'c']);
  });

  test('fan-out then join: parallel group then a joined node', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['b', 'c']),
      DagNode.task(id: 'b', capabilityKey: 'bureau', next: ['d']),
      DagNode.task(id: 'c', capabilityKey: 'scoring', next: ['d']),
      DagNode.task(id: 'd', capabilityKey: 'customer-party', joinOn: ['b', 'c']),
    ]);
    final plan = engine.plan(dag);
    expect(plan.steps[0].nodeIds, ['a']);
    expect(plan.steps[1].nodeIds, ['b', 'c']); // parallel group
    expect(plan.steps[2].nodeIds, ['d']); // fires only after both joins
  });

  test('branch takes the chosen arm', () {
    final dag = canonicalLoanDag();
    final approved = engine.plan(
      dag,
      const SimulationInput(branchChoices: {'n_decide': 'n_book'}),
    );
    expect(approved.firedOrder, contains('n_book'));
    expect(approved.firedOrder, isNot(contains('n_reject')));

    final rejected = engine.plan(
      dag,
      const SimulationInput(branchChoices: {'n_decide': 'n_reject'}),
    );
    expect(rejected.firedOrder, contains('n_reject'));
    expect(rejected.firedOrder, isNot(contains('n_book')));
  });

  test('branch with no decision defaults to the first arm (deterministic)', () {
    final plan = engine.plan(canonicalLoanDag());
    expect(plan.firedOrder, contains('n_book')); // first arm -> n_book
    expect(plan.firedOrder, isNot(contains('n_reject')));
  });

  test('meter node marks its step as metered', () {
    final plan = engine.plan(
      canonicalLoanDag(),
      const SimulationInput(branchChoices: {'n_decide': 'n_book'}),
    );
    final bookStep = plan.steps.firstWhere((s) => s.nodeIds.contains('n_book'));
    expect(bookStep.hasMeter, isTrue);
  });

  test('injected failure records the compensation path and halts forward edges', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(
        id: 'a',
        capabilityKey: 'lending-origination',
        meter: 'finnone_pool',
        compensation: 'rev',
        next: ['done'],
      ),
      DagNode.terminal(id: 'done'),
      DagNode.task(id: 'rev', capabilityKey: 'lending-origination', next: ['failed']),
      DagNode.terminal(id: 'failed'),
    ]);
    final plan = engine.plan(dag, const SimulationInput(failAt: 'a'));
    expect(plan.firedOrder, contains('a'));
    expect(plan.firedOrder, isNot(contains('done'))); // forward edge halted
    expect(plan.compensated, ['rev', 'failed']); // compensation chain walked
  });

  test('unknown start node yields an empty plan', () {
    const dag = Dag(startNodeId: 'ghost', nodes: [DagNode.terminal(id: 'a')]);
    expect(engine.plan(dag).steps, isEmpty);
  });
}
