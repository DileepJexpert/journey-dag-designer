import 'package:flutter_test/flutter_test.dart';
import 'package:dag_core/dag_core.dart';
import 'package:journey_dag_designer/domain/services/dag_diff_service.dart';

void main() {
  const diff = DagDiffService();

  const base = Dag(startNodeId: 'a', nodes: [
    DagNode.task(id: 'a', capability: 'kyc', next: ['b']),
    DagNode.task(id: 'b', capability: 'bureau', next: ['c']),
    DagNode.terminal(id: 'c'),
  ]);

  test('identical DAGs -> empty diff', () {
    expect(diff.compute(base, base).isEmpty, isTrue);
  });

  test('added node and edge are reported', () {
    const next = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['b']),
      DagNode.task(id: 'b', capability: 'bureau', next: ['c', 'x']),
      DagNode.terminal(id: 'c'),
      DagNode.terminal(id: 'x'),
    ]);
    final d = diff.compute(base, next);
    expect(d.addedNodes, ['x']);
    expect(d.removedNodes, isEmpty);
    expect(d.addedEdges.map((e) => '${e.from}->${e.to}'), contains('b->x'));
  });

  test('removed node and edge are reported', () {
    const next = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['c']),
      DagNode.terminal(id: 'c'),
    ]);
    final d = diff.compute(base, next);
    expect(d.removedNodes, ['b']);
    expect(d.removedEdges.map((e) => '${e.from}->${e.to}'),
        containsAll(['a->b', 'b->c']));
    expect(d.addedEdges.map((e) => '${e.from}->${e.to}'), contains('a->c'));
  });

  test('changed node config is reported (capability swap)', () {
    const next = Dag(startNodeId: 'a', nodes: [
      DagNode.task(id: 'a', capability: 'kyc', next: ['b']),
      DagNode.task(id: 'b', capability: 'scoring', next: ['c']), // changed
      DagNode.terminal(id: 'c'),
    ]);
    final d = diff.compute(base, next);
    expect(d.changedNodes, ['b']);
  });

  test('layout-only moves are NOT a semantic change', () {
    const moved = Dag(
      startNodeId: 'a',
      nodes: [
        DagNode.task(id: 'a', capability: 'kyc', next: ['b']),
        DagNode.task(id: 'b', capability: 'bureau', next: ['c']),
        DagNode.terminal(id: 'c'),
      ],
      layout: {'a': NodeLayout(x: 999, y: 999)},
    );
    expect(diff.compute(base, moved).isEmpty, isTrue);
  });
}
