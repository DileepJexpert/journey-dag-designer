import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/domain/models/branch_arm.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/dag_node.dart';
import 'package:journey_dag_designer/domain/models/node_policies.dart';
import 'package:journey_dag_designer/domain/models/validation.dart';
import 'package:journey_dag_designer/domain/services/dag_validator.dart';

import 'fixtures.dart';

void main() {
  const validator = DagValidator();

  Set<ValidationCode> codes(Dag dag) => validator
      .validate(dag, capabilities: loanCapabilities)
      .issues
      .map((i) => i.code)
      .toSet();

  test('the canonical §7 DAG is valid', () {
    final result =
        validator.validate(canonicalLoanDag(), capabilities: loanCapabilities);
    expect(result.isValid, isTrue, reason: result.errors.toString());
    expect(result.errors, isEmpty);
  });

  test('empty DAG -> emptyDag error', () {
    const dag = Dag(startNodeId: 'x', nodes: []);
    expect(codes(dag), contains(ValidationCode.emptyDag));
  });

  test('missing start node -> startNodeMissing', () {
    const dag = Dag(startNodeId: 'ghost', nodes: [DagNode.terminal(id: 'a')]);
    expect(codes(dag), contains(ValidationCode.startNodeMissing));
  });

  test('duplicate node id -> duplicateNodeId', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['a']),
      DagNode.terminal(id: 'a'),
    ]);
    expect(codes(dag), contains(ValidationCode.duplicateNodeId));
  });

  test('dangling edge -> danglingEdge', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['nowhere']),
    ]);
    expect(codes(dag), contains(ValidationCode.danglingEdge));
  });

  test('unreachable node -> unreachableNode', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['b']),
      DagNode.terminal(id: 'b'),
      DagNode.terminal(id: 'orphan'),
    ]);
    expect(codes(dag), contains(ValidationCode.unreachableNode));
  });

  test('compute cycle -> cycleDetected', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['b']),
      DagNode.task(id: 'b', capability: 'bureau', next: ['a']),
    ]);
    expect(codes(dag), contains(ValidationCode.cycleDetected));
  });

  test('time-gated wait/timer loop is NOT a forbidden cycle', () {
    const dag = Dag(startNodeId: 'reg', nodes: [
      DagNode.task(id: 'reg', capability: 'kyc', next: ['await']),
      DagNode.wait(
          id: 'await',
          waitFor: 'Callback',
          timeout: '24h',
          onTimeout: 'chase',
          next: ['done']),
      DagNode.timer(id: 'chase', delay: '2h', next: ['await']), // loops back
      DagNode.terminal(id: 'done'),
    ]);
    expect(codes(dag), isNot(contains(ValidationCode.cycleDetected)));
  });

  test('branch without a default -> branchNoDefault', () {
    const dag = Dag(startNodeId: 'd', nodes: [
      DagNode.branch(id: 'd', arms: [BranchArm(when: 'x', next: 't')]),
      DagNode.terminal(id: 't'),
    ]);
    expect(codes(dag), contains(ValidationCode.branchNoDefault));
  });

  test('branch arm that never reaches a terminal -> branchArmDeadEnd', () {
    const dag = Dag(startNodeId: 'd', nodes: [
      DagNode.branch(id: 'd', arms: [
        BranchArm(when: 'x', next: 't'),
        BranchArm(when: 'y', next: 'deadEnd'),
      ], defaultNext: 't'),
      DagNode.terminal(id: 't'),
      DagNode.task(id: 'deadEnd', capability: 'kyc'), // no path to a terminal
    ]);
    expect(codes(dag), contains(ValidationCode.branchArmDeadEnd));
  });

  test('join.joinOn referencing a non-predecessor -> joinOnNotActualPredecessor',
      () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['j']),
      DagNode.join(id: 'j', joinOn: ['x'], next: ['c']),
      DagNode.terminal(id: 'c'),
      DagNode.task(id: 'x', capability: 'scoring', next: ['c']),
    ]);
    expect(codes(dag), contains(ValidationCode.joinOnNotActualPredecessor));
  });

  test('join.joinOn referencing an unknown node -> joinOnUnknownPredecessor', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['j']),
      DagNode.join(id: 'j', joinOn: ['ghost'], next: ['c']),
      DagNode.terminal(id: 'c'),
    ]);
    expect(codes(dag), contains(ValidationCode.joinOnUnknownPredecessor));
  });

  test('money/booking node without compensation -> missingCompensation', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'lending-origination', next: ['b']),
      DagNode.terminal(id: 'b'),
    ]);
    expect(codes(dag), contains(ValidationCode.missingCompensation));
  });

  test('metered node without compensation -> missingCompensation', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(
          id: 'a',
          capability: 'kyc',
          policies: NodePolicies(meter: MeterPolicy(pool: 'finnone_pool')),
          next: ['b']),
      DagNode.terminal(id: 'b'),
    ]);
    expect(codes(dag), contains(ValidationCode.missingCompensation));
  });

  test('wait without timeout/onTimeout -> waitMissingTimeout', () {
    const dag = Dag(startNodeId: 'w', nodes: [
      DagNode.wait(id: 'w', waitFor: 'Callback', next: ['done']),
      DagNode.terminal(id: 'done'),
    ]);
    expect(codes(dag), contains(ValidationCode.waitMissingTimeout));
  });

  test('unregistered capability -> unknownCapability', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'scoring-decisioning', next: ['b']),
      DagNode.terminal(id: 'b'),
    ]);
    expect(codes(dag), contains(ValidationCode.unknownCapability));
  });

  test('a valid parallel/join fan-out DAG passes', () {
    const dag = Dag(startNodeId: 'p', nodes: [
      DagNode.parallel(id: 'p', branches: ['b', 'c']),
      DagNode.task(id: 'b', capability: 'bureau', next: ['d']),
      DagNode.task(id: 'c', capability: 'scoring', next: ['d']),
      DagNode.join(id: 'd', joinOn: ['b', 'c'], next: ['e']),
      DagNode.terminal(id: 'e'),
    ]);
    final result = validator.validate(dag, capabilities: loanCapabilities);
    expect(result.isValid, isTrue, reason: result.errors.toString());
  });
}
