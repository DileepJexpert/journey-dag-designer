import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/dag_node.dart';
import 'package:journey_dag_designer/domain/services/config_serializer.dart';

import 'fixtures.dart';

void main() {
  const serializer = ConfigSerializer();

  group('ConfigSerializer.toJson', () {
    test('emits the §5 canonical shape with type discriminators', () {
      final json = serializer.toJson(canonicalLoanDag(), key: 'loan-origination');

      expect(json['key'], 'loan-origination');
      expect(json['startNodeId'], 'n_customer');

      final nodes = (json['nodes'] as List).cast<Map<String, dynamic>>();
      final customer = nodes.firstWhere((n) => n['id'] == 'n_customer');
      expect(customer['type'], 'task');
      expect(customer['capabilityKey'], 'customer-party');
      expect(customer['next'], ['n_kyc']);

      final decide = nodes.firstWhere((n) => n['id'] == 'n_decide');
      expect(decide['type'], 'branch');
      expect((decide['arms'] as List).first['next'], 'n_book');

      final done = nodes.firstWhere((n) => n['id'] == 'n_done');
      expect(done['type'], 'terminal');
      expect(done['action'], 'push_decision_to_channel');
      expect(done['emit'], ['LoanBooked']);
    });

    test('omits empty/default fields (terse wire shape)', () {
      final json = serializer.toJson(canonicalLoanDag(), key: 'k');
      final nodes = (json['nodes'] as List).cast<Map<String, dynamic>>();

      final customer = nodes.firstWhere((n) => n['id'] == 'n_customer');
      expect(customer.containsKey('joinOn'), isFalse);
      expect(customer.containsKey('meter'), isFalse);
      expect(customer.containsKey('optional'), isFalse);

      final book = nodes.firstWhere((n) => n['id'] == 'n_book');
      expect(book['meter'], 'finnone_pool');
      expect(book['compensation'], 'n_reverse');
    });

    test('preserves layout coordinates', () {
      final json = serializer.toJson(canonicalLoanDag(), key: 'k');
      final layout = json['layout'] as Map<String, dynamic>;
      expect(layout['n_customer'], {'x': 80.0, 'y': 200.0});
    });
  });

  group('ConfigSerializer round-trip', () {
    test('fromJson(toJson(dag)) preserves nodes and start', () {
      final original = canonicalLoanDag();
      final restored =
          serializer.fromJson(serializer.toJson(original, key: 'loan'));

      expect(restored.startNodeId, original.startNodeId);
      expect(restored.nodes.length, original.nodes.length);
      // freezed value equality, layout included.
      expect(restored.layout, original.layout);
      for (final n in original.nodes) {
        expect(restored.nodeOrNull(n.id), n, reason: 'node ${n.id} differs');
      }
    });

    test('round-trips through a JSON string and carries the key', () {
      final original = canonicalLoanDag();
      final str = serializer.toJsonString(original, key: 'loan');
      final restored = serializer.fromJsonString(str);
      expect(restored.nodes.length, original.nodes.length);
      expect(serializer.keyOf(serializer.toJson(original, key: 'loan')), 'loan');
    });

    test('preserves joinOn / optional through a round-trip', () {
      const dag = Dag(startNodeId: 'a', nodes: [
        DagNode.task(id: 'a', capabilityKey: 'kyc', next: ['b', 'c']),
        DagNode.task(id: 'b', capabilityKey: 'bureau', next: ['d']),
        DagNode.task(id: 'c', capabilityKey: 'scoring', next: ['d'], optional: true),
        DagNode.task(id: 'd', capabilityKey: 'kyc', joinOn: ['b', 'c']),
      ]);
      final restored = serializer.fromJson(serializer.toJson(dag, key: 'k'));
      final d = restored.nodeOrNull('d') as TaskNode;
      expect(d.joinOn, ['b', 'c']);
      final c = restored.nodeOrNull('c') as TaskNode;
      expect(c.optional, isTrue);
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
