/// Legacy-patterns demo seeds: the two RUNNABLE demo journeys validate clean
/// against the capability registry (they execute on the platform side), the
/// two REFERENCE drawings (file-batch, sync-read) are §7-expressible and
/// serialize round-trip (they are drawn for the honesty slide, NOT executed),
/// and the mock repository actually serves all four.
library;

import 'package:dag_core/dag_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_dag_designer/data/demo_seed_data.dart';
import 'package:journey_dag_designer/data/seed_data.dart';
import 'package:journey_dag_designer/data/repositories/mock_journey_repository.dart';
import 'package:journey_dag_designer/domain/models/journey.dart';
import 'package:journey_dag_designer/domain/services/dag_validator.dart';

void main() {
  const validator = DagValidator();
  const serializer = ConfigSerializer();

  test('device-financing demo journey validates clean — ONE dag, brands are '
      'config rows elsewhere', () {
    final result = validator.validate(demoDeviceFinancingDag(), capabilities: seedCapabilities);
    expect(result.issues, isEmpty);
    // The config-not-code proof in the drawing itself: no node names a brand.
    for (final node in demoDeviceFinancingDag().nodes) {
      expect(node.id.toUpperCase(), isNot(contains('SAMSUNG')));
      expect(node.id.toUpperCase(), isNot(contains('GODREJ')));
      expect(node.id.toUpperCase(), isNot(contains('BOSCH')));
    }
  });

  test('employee-lwd demo journey (per-record body) validates clean', () {
    expect(validator.validate(demoEmployeeLwdDag(), capabilities: seedCapabilities).issues, isEmpty);
  });

  test('REFERENCE file-batch drawing is §7-expressible and round-trips '
      '(foreach body, bounded parallelism, empty-file arm)', () {
    final dag = referenceFileBatchDag();
    final json = serializer.toJson(dag, key: 'reference-file-batch');
    final back = serializer.fromJson(json);
    expect(back.nodes.length, dag.nodes.length);
    final each = back.nodes.whereType<ForeachNode>().single;
    expect(each.items, 'context.batch.records');
    expect(each.mode, ForeachMode.parallel);
    expect(each.parallelism, 5);
    expect(each.body, ['n_updateRecord']);
    // One bad record must mark itself, never the batch.
    final update = back.nodes
        .whereType<TaskNode>()
        .singleWhere((n) => n.id == 'n_updateRecord');
    expect(update.optional, isTrue);
  });

  test('REFERENCE sync-read drawing validates clean and round-trips', () {
    expect(validator.validate(referenceSyncReadDag(), capabilities: seedCapabilities).issues, isEmpty);
    final back = serializer
        .fromJson(serializer.toJson(referenceSyncReadDag(), key: 'reference-sync-read'));
    expect(back.nodes.length, referenceSyncReadDag().nodes.length);
  });

  test('mock repository serves the two runnable demos PUBLISHED and the two '
      'references as DRAFTS', () async {
    final repo = MockJourneyRepository(now: DateTime.utc(2026, 7, 3));
    final all = await repo.listJourneys();
    final byKey = {for (final j in all) j.key: j};

    expect(byKey['device-financing']!.activeVersion, 1);
    expect(byKey['device-financing']!.active!.status, ApprovalStatus.published);
    expect(byKey['employee-lwd-update']!.active!.status, ApprovalStatus.published);

    for (final refKey in ['reference-file-batch', 'reference-sync-read']) {
      final j = byKey[refKey]!;
      expect(j.activeVersion, isNull,
          reason: 'references are drawn, not built — they must never publish');
      expect(j.draft!.status, ApprovalStatus.draft);
      expect(j.name, startsWith('REFERENCE —'));
    }
  });
}
