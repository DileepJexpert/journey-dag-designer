/// Run detail behaviors (spec C.2): version-pinned graph render (v1 vs v2),
/// DECLINED renders as completion end-to-end, legacy/approximate + orphan
/// chips, timeline-only fallback when the registry is down, DLQ pointer,
/// related runs by sfdcRecordId.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/app/providers.dart';
import 'package:journey_ops_view/data/graph_repository.dart';
import 'package:journey_ops_view/data/mock_ops_api.dart';
import 'package:journey_ops_view/features/run_detail/run_detail_screen.dart';

class _DownGraphRepository implements GraphRepository {
  @override
  Future<PinnedGraph> graphFor(String journeyKey, int version) async =>
      throw const GraphUnavailableException('registry unreachable (test)');
}

Widget _app(String runId, {GraphRepository? graphs}) => ProviderScope(
      overrides: [
        opsApiProvider
            .overrideWithValue(MockOpsApi(now: DateTime.utc(2026, 7, 3, 10))),
        graphRepositoryProvider
            .overrideWithValue(graphs ?? MockGraphRepository()),
      ],
      child: MaterialApp(home: RunDetailScreen(runId: runId)),
    );

/// Detail is a lazy ListView (header + graph + timeline + related): give the
/// test a surface tall enough that EVERY card builds, so finders see them all.
Future<void> _pump(WidgetTester tester, String runId,
    {GraphRepository? graphs}) async {
  tester.view.physicalSize = const Size(1300, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(_app(runId, graphs: graphs));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a v1-pinned run renders the v1 graph even though v2 is '
      'current (no n_notify hop)', (tester) async {
    await _pump(tester, 'run-pl-003'); // pinned v1

    expect(find.text('Graph — pinned v1'), findsOneWidget);
    expect(find.text('n_notify'), findsNothing);
    expect(find.text('n_book'), findsWidgets); // graph node + timeline rows
  });

  testWidgets('a v2-pinned run renders the v2 graph WITH the notify hop',
      (tester) async {
    await _pump(tester, 'run-pl-001'); // pinned v2

    expect(find.text('Graph — pinned v2'), findsOneWidget);
    expect(find.text('n_notify'), findsOneWidget);
    // Overlay wiring: completed node badged 'done', in-flight node 'active'.
    expect(find.text('done'), findsOneWidget); // n_customer
    expect(find.text('active'), findsOneWidget); // n_kyc
  });

  testWidgets('DECLINED run detail renders as a COMPLETION: vocabulary chip, '
      'terminal info, and NO alarm iconography for THIS run', (tester) async {
    await _pump(tester, 'run-pl-004');

    expect(find.text('COMPLETED—DECLINED'), findsOneWidget);
    expect(find.textContaining('n_reject → REJECTED'), findsOneWidget);

    // The run's own surfaces — header chip, graph overlay, timeline — carry
    // no alarm icon. (The RELATED-runs section may legitimately alarm: this
    // SFDC record's OTHER run really did fail — that chip is about that run.)
    final ownCards = [
      find.byType(Card).at(0), // header
      find.byType(Card).at(1), // graph
      find.byType(Card).at(2), // timeline
    ];
    for (final card in ownCards) {
      expect(
          find.descendant(
              of: card, matching: find.byIcon(Icons.error_outline)),
          findsNothing,
          reason: 'a correctly-declined application must not alarm');
    }
    // And the related section is exactly the failed sibling, labelled as such.
    expect(find.text('FAILED—notify-pending'), findsOneWidget);
    expect(find.text('run-pl-006'), findsOneWidget);
  });

  testWidgets('legacy v0 run: CURRENT graph + "legacy, approximate" badge + '
      'orphan warn chips for nodes the graph lost', (tester) async {
    await _pump(tester, 'run-pl-007');

    expect(find.text('legacy, approximate'), findsOneWidget);
    expect(find.text('Graph — CURRENT version'), findsOneWidget);
    expect(find.text('loan-origination · legacy (v0)'), findsOneWidget);
    expect(find.textContaining('n_legacy_check'), findsWidgets);
    expect(find.text('not in graph'), findsNWidgets(2),
        reason: 'both n_legacy_check transitions wear the warn chip');
  });

  testWidgets('registry down -> TIMELINE-ONLY fallback: graph notice, '
      'history still fully rendered', (tester) async {
    await _pump(tester, 'run-pl-003', graphs: _DownGraphRepository());

    expect(find.textContaining('Graph unavailable'), findsOneWidget);
    expect(find.textContaining('timeline below is the authoritative'),
        findsOneWidget);
    expect(find.text('Timeline'), findsOneWidget);
    expect(find.text('n_customer'), findsWidgets); // timeline rows survive
    // No orphan judgement without a graph: no warn chips.
    expect(find.text('not in graph'), findsNothing);
  });

  testWidgets('failed run carries the copyable DLQ pointer and its related '
      'runs by sfdcRecordId', (tester) async {
    await _pump(tester, 'run-pl-006');

    expect(find.text('FAILED—notify-pending'), findsOneWidget);
    expect(find.text('orig.sfdc.dlq.v1'), findsOneWidget);
    expect(find.textContaining('pointer only'), findsOneWidget);
    expect(find.textContaining('Related runs — same sfdcRecordId (SFDC-9004)'),
        findsOneWidget);
    expect(find.text('run-pl-004'), findsOneWidget,
        reason: 'the declined run on the same SFDC record is related');
  });

  testWidgets('unknown runId says so instead of erroring', (tester) async {
    await _pump(tester, 'run-does-not-exist');

    expect(find.text('No run with this id.'), findsOneWidget);
  });
}
