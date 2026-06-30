import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/dag_node.dart';
import 'package:journey_dag_designer/domain/services/config_serializer.dart';

import 'fixtures.dart';

void main() {
  const serializer = ConfigSerializer();

  group('ConfigSerializer.toJson', () {
    test('emits the §7 canonical shape with type discriminators', () {
      final json = serializer.toJson(canonicalLoanDag(), key: 'loan-origination');

      expect(json['journeyKey'], 'loan-origination');
      expect(json['version'], 1);
      expect(json['startNodeId'], 'n_customer');
      expect((json['pools'] as Map)['finnone_pool'], {'maxConcurrent': 20});
      expect((json['context'] as Map)['schemaRef'], 'loan-origination-context@1');

      final nodes = (json['nodes'] as List).cast<Map<String, dynamic>>();
      final customer = nodes.firstWhere((n) => n['id'] == 'n_customer');
      expect(customer['type'], 'task');
      expect(customer['capability'], 'customer-party');
      expect(customer['operation'], 'resolve');
      expect(customer['next'], ['n_kyc']);

      final decide = nodes.firstWhere((n) => n['id'] == 'n_decide');
      expect(decide['type'], 'branch');
      expect((decide['arms'] as List).first['next'], 'n_book');
      expect(decide['default'], 'n_reject');

      final done = nodes.firstWhere((n) => n['id'] == 'n_done');
      expect(done['type'], 'terminal');
      expect(done['status'], 'completed');
      expect(done['action'], 'push_decision_to_channel');
      expect(done['emit'], ['LoanBooked']);
    });

    test('emits §7 policies + compensation on the booking node', () {
      final json = serializer.toJson(canonicalLoanDag(), key: 'k');
      final nodes = (json['nodes'] as List).cast<Map<String, dynamic>>();

      final customer = nodes.firstWhere((n) => n['id'] == 'n_customer');
      expect(customer.containsKey('policies'), isFalse);
      expect(customer.containsKey('optional'), isFalse);

      final book = nodes.firstWhere((n) => n['id'] == 'n_book');
      expect(book['policies']['meter']['pool'], 'finnone_pool');
      expect(book['compensation']['operation'], 'reverseBooking');
      expect(book['onFailure'], 'compensate');
    });

    test('preserves layout coordinates', () {
      final json = serializer.toJson(canonicalLoanDag(), key: 'k');
      final layout = json['layout'] as Map<String, dynamic>;
      expect(layout['n_customer'], {'x': 80.0, 'y': 200.0});
    });
  });

  group('ConfigSerializer round-trip', () {
    test('fromJson(toJson(dag)) preserves nodes, pools, and context', () {
      final original = canonicalLoanDag();
      final restored =
          serializer.fromJson(serializer.toJson(original, key: 'loan'));

      expect(restored.startNodeId, original.startNodeId);
      expect(restored.nodes.length, original.nodes.length);
      expect(restored.pools, original.pools);
      expect(restored.contextSchemaRef, original.contextSchemaRef);
      expect(restored.layout, original.layout);
      for (final n in original.nodes) {
        expect(restored.nodeOrNull(n.id), n, reason: 'node ${n.id} differs');
      }
    });

    test('round-trips through a JSON string and carries the key + version', () {
      final original = canonicalLoanDag();
      final str = serializer.toJsonString(original, key: 'loan', version: 3);
      final restored = serializer.fromJsonString(str);
      expect(restored.nodes.length, original.nodes.length);
      final json = serializer.toJson(original, key: 'loan', version: 3);
      expect(serializer.keyOf(json), 'loan');
      expect(serializer.versionOf(json), 3);
    });

    test('round-trips parallel/join/wait/foreach node kinds', () {
      const dag = Dag(startNodeId: 'p', nodes: [
        DagNode.parallel(id: 'p', branches: ['a', 'b']),
        DagNode.task(id: 'a', capability: 'kyc', next: ['j']),
        DagNode.task(id: 'b', capability: 'bureau', next: ['j']),
        DagNode.join(
            id: 'j',
            joinOn: ['a', 'b'],
            policy: JoinPolicy.quorum,
            quorum: 2,
            next: ['w']),
        DagNode.wait(
            id: 'w',
            waitFor: 'Callback',
            timeout: '24h',
            onTimeout: 'end',
            next: ['fe']),
        DagNode.foreach(
            id: 'fe',
            items: 'context.items',
            mode: ForeachMode.parallel,
            parallelism: 4,
            next: ['end']),
        DagNode.terminal(id: 'end'),
      ]);
      final restored = serializer.fromJson(serializer.toJson(dag, key: 'k'));
      for (final n in dag.nodes) {
        expect(restored.nodeOrNull(n.id), n, reason: 'node ${n.id} differs');
      }
      final j = restored.nodeOrNull('j') as JoinNode;
      expect(j.policy, JoinPolicy.quorum);
      expect(j.quorum, 2);
    });

    test('preserves optional + onFailure through a round-trip', () {
      const dag = Dag(startNodeId: 'a', nodes: [
        DagNode.task(id: 'a', capability: 'kyc', next: ['b']),
        DagNode.task(
            id: 'b', capability: 'bureau', optional: true, onFailure: 'fail'),
      ]);
      final restored = serializer.fromJson(serializer.toJson(dag, key: 'k'));
      final b = restored.nodeOrNull('b') as TaskNode;
      expect(b.optional, isTrue);
      expect(b.onFailure, 'fail');
    });

    test('throws on an unknown node type', () {
      expect(
        () => serializer.fromJson({
          'startNodeId': 'a',
          'nodes': [
            {'type': 'gateway', 'id': 'a'},
          ],
          'layout': {},
        }),
        throwsFormatException,
      );
    });
  });
}
