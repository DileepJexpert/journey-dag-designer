import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/domain/models/branch_arm.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/dag_node.dart';
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

  test('the canonical §5 DAG is valid', () {
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
    const dag = Dag(startNodeId: 'ghost', nodes: [
      DagNode.terminal(id: 'a'),
    ]);
    expect(codes(dag), contains(ValidationCode.startNodeMissing));
  });

  test('duplicate node id -> duplicateNodeId', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['a']),
      DagNode.terminal(id: 'a'),
    ]);
    expect(codes(dag), contains(ValidationCode.duplicateNodeId));
  });

  test('dangling edge -> danglingEdge', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['nowhere']),
    ]);
    expect(codes(dag), contains(ValidationCode.danglingEdge));
  });

  test('unreachable node -> unreachableNode', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['b']),
      DagNode.terminal(id: 'b'),
      DagNode.terminal(id: 'orphan'),
    ]);
    expect(codes(dag), contains(ValidationCode.unreachableNode));
  });

  test('cycle -> cycleDetected', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['b']),
      DagNode.task(id: 'b', capabilityKey: 'bureau', next: ['a']),
    ]);
    expect(codes(dag), contains(ValidationCode.cycleDetected));
  });

  test('branch arm that never reaches a terminal -> branchArmDeadEnd', () {
    // arm -> b -> c -> b would be a cycle; instead make an arm reach a task with
    // no onward path to a terminal.
    const dag = Dag(startNodeId: 'd', nodes: [
      DagNode.branch(id: 'd', arms: [
        BranchArm(expression: 'x', next: 't'),
        BranchArm(expression: 'y', next: 'deadEnd'),
      ]),
      DagNode.terminal(id: 't'),
      // deadEnd is a task whose only successor loops back? No — keep acyclic:
      // a task with no successors at all never reaches a terminal.
      DagNode.task(id: 'deadEnd', capabilityKey: 'kyc'),
    ]);
    expect(codes(dag), contains(ValidationCode.branchArmDeadEnd));
  });

  test('joinOn referencing a non-predecessor -> joinOnNotActualPredecessor', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['b']),
      DagNode.task(id: 'b', capabilityKey: 'bureau', next: ['c'], joinOn: ['x']),
      DagNode.terminal(id: 'c'),
      DagNode.task(id: 'x', capabilityKey: 'scoring', next: ['c']),
    ]);
    final set = codes(dag);
    expect(set, contains(ValidationCode.joinOnNotActualPredecessor));
  });

  test('joinOn referencing an unknown node -> joinOnUnknownPredecessor', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['b']),
      DagNode.task(id: 'b', capabilityKey: 'bureau', joinOn: ['ghost']),
    ]);
    expect(codes(dag), contains(ValidationCode.joinOnUnknownPredecessor));
  });

  test('money/booking node without compensation -> missingCompensation', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'lending-origination', next: ['b']),
      DagNode.terminal(id: 'b'),
    ]);
    expect(codes(dag), contains(ValidationCode.missingCompensation));
  });

  test('metered node without compensation -> missingCompensation', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', meter: 'finnone_pool', next: ['b']),
      DagNode.terminal(id: 'b'),
    ]);
    expect(codes(dag), contains(ValidationCode.missingCompensation));
  });

  test('unregistered capability -> unknownCapability', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'scoring-decisioning', next: ['b']),
      DagNode.terminal(id: 'b'),
    ]);
    // "scoring-decisioning" is NOT a registered backend module — the real key
    // is "scoring". The validator catches the drift the build doc example had.
    expect(codes(dag), contains(ValidationCode.unknownCapability));
  });

  test('a valid join/fan-out DAG passes', () {
    const dag = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['b', 'c']),
      DagNode.task(id: 'b', capabilityKey: 'bureau', next: ['d']),
      DagNode.task(id: 'c', capabilityKey: 'scoring', next: ['d']),
      DagNode.task(id: 'd', capabilityKey: 'customer-party', joinOn: ['b', 'c'], next: ['e']),
      DagNode.terminal(id: 'e'),
    ]);
    final result = validator.validate(dag, capabilities: loanCapabilities);
    expect(result.isValid, isTrue, reason: result.errors.toString());
  });
}
