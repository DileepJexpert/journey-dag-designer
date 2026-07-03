import 'package:flutter_test/flutter_test.dart';
import 'package:dag_core/dag_core.dart';
import 'package:journey_dag_designer/domain/services/simulation_engine.dart';

import 'fixtures.dart';

void main() {
  const engine = SimulationEngine();

  test('linear chain fires one node per step, in order', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['b']),
      DagNode.task(id: 'b', capability: 'bureau', next: ['c']),
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

  test('parallel fan-out then join: parallel group then a joined node', () {
    const dag = Dag(startNodeId: 'p', nodes: [
      DagNode.parallel(id: 'p', branches: ['b', 'c']),
      DagNode.task(id: 'b', capability: 'bureau', next: ['d']),
      DagNode.task(id: 'c', capability: 'scoring', next: ['d']),
      DagNode.join(id: 'd', joinOn: ['b', 'c'], next: ['e']),
      DagNode.terminal(id: 'e'),
    ]);
    final plan = engine.plan(dag);
    expect(plan.steps[0].nodeIds, ['p']);
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

  test('injected failure records the compensation and halts forward edges', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(
        id: 'a',
        capability: 'lending-origination',
        policies: NodePolicies(meter: MeterPolicy(pool: 'finnone_pool')),
        compensation: Compensation(operation: 'reverseBooking'),
        next: ['done'],
      ),
      DagNode.terminal(id: 'done'),
    ]);
    final plan = engine.plan(dag, const SimulationInput(failAt: 'a'));
    expect(plan.firedOrder, contains('a'));
    expect(plan.firedOrder, isNot(contains('done'))); // forward edge halted
    expect(plan.compensated, ['a']); // the failed step was compensated
  });

  test('unknown start node yields an empty plan', () {
    const dag = Dag(startNodeId: 'ghost', nodes: [DagNode.terminal(id: 'a')]);
    expect(engine.plan(dag).steps, isEmpty);
  });
}
