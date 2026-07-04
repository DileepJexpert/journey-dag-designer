/// OPS P2 (triage-depth slice) behaviors: status tiles with tap-to-filter,
/// wall-clock durations on ended rows, the header live-line (age +
/// time-in-node + sweeper deadline/OVERDUE) computed off the injectable
/// clock, the compensation-saga progress line, timeline latency chips plus
/// attempts/failure-class annotations, and the canvas badges enriched to
/// 'failed · CLASS' / 'try N'. Failure classes are ENUM NAMES only.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/app/providers.dart';
import 'package:journey_ops_view/data/graph_repository.dart';
import 'package:journey_ops_view/data/mock_ops_api.dart';
import 'package:journey_ops_view/data/ops_api.dart';
import 'package:journey_ops_view/domain/models.dart';
import 'package:journey_ops_view/domain/ops_status.dart';
import 'package:journey_ops_view/features/run_detail/run_detail_screen.dart';
import 'package:journey_ops_view/features/runs/runs_screen.dart';

/// The one instant every assertion is computed against: the mock seeds its
/// fixtures relative to it AND the header's live math reads it via
/// [nowProvider] — so 'live for 2m 00s' is arithmetic, not luck.
final DateTime _t0 = DateTime.utc(2026, 7, 3, 10);

/// Serves exactly one hand-built run — for shapes the seeded mock doesn't
/// carry (an ACTIVE node mid-retry).
class _OneRunApi implements OpsApi {
  _OneRunApi(this.run);

  final RunDetail run;

  @override
  Future<RunDetail?> detail(String runId) async =>
      runId == run.runId ? run : null;

  @override
  Future<RunsPage> runs({
    OpsStatus? status,
    String? journeyKey,
    bool stuckOnly = false,
    int page = 0,
    int size = 50,
  }) async =>
      const RunsPage(items: [], page: 0, size: 1, totalItems: 0, totalPages: 0);

  @override
  Future<List<RunSummary>> search(String key) async => const [];

  @override
  Future<OpsMetrics> metrics() async =>
      OpsMetrics(generatedAt: run.startedAt, journeys: const []);
}

Widget _app(Widget home, {OpsApi? api}) => ProviderScope(
      overrides: [
        opsApiProvider.overrideWithValue(api ?? MockOpsApi(now: _t0)),
        graphRepositoryProvider.overrideWithValue(MockGraphRepository()),
        nowProvider.overrideWithValue(() => _t0),
      ],
      child: MaterialApp(home: home),
    );

/// Tall surface so lazy lists build every row/card the finders assert on.
Future<void> _pump(WidgetTester tester, Widget home, {OpsApi? api}) async {
  tester.view.physicalSize = const Size(1300, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(_app(home, api: api));
  await tester.pumpAndSettle();
}

/// Dispose the runs screen so its poll timer is cancelled before the test ends.
Future<void> _teardown(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
}

void main() {
  group('status tiles (runs list)', () {
    testWidgets('show the floor counts — 3 running, 1 stuck, 1 notify-pending, '
        '1 failed-notified', (tester) async {
      await _pump(tester, const RunsScreen());

      expect(find.text('3'), findsOneWidget); // running: pl-001/002/008
      expect(find.text('1'), findsNWidgets(3)); // stuck, notify-pending, notified
      expect(find.text('Notify-pending'), findsOneWidget);
      expect(find.text('Failed-notified'), findsOneWidget);

      await _teardown(tester);
    });

    testWidgets('tapping a tile applies its filter', (tester) async {
      await _pump(tester, const RunsScreen());

      await tester.tap(find.text('Notify-pending')); // the tile label
      await tester.pumpAndSettle();

      expect(find.text('run-pl-006'), findsOneWidget);
      expect(find.text('run-pl-001'), findsNothing,
          reason: 'the tile is a saved filter, not decoration');

      await _teardown(tester);
    });
  });

  group('durations (runs list)', () {
    testWidgets('ended rows say how long the run took; live rows never do',
        (tester) async {
      await _pump(tester, const RunsScreen());

      expect(find.textContaining('took 4m 00s'), findsOneWidget); // run-pl-003
      expect(find.textContaining('took 2m 00s'), findsOneWidget); // run-pl-005

      await tester.tap(find.text('Running').last); // the chip, not the tile
      await tester.pumpAndSettle();

      expect(find.text('run-pl-001'), findsOneWidget);
      expect(find.textContaining('took'), findsNothing,
          reason: 'a live run has no duration yet — only "live for"');

      await _teardown(tester);
    });
  });

  group('live-line (detail header)', () {
    testWidgets('live run: age, time-in-node, and WHEN the sweeper acts',
        (tester) async {
      await _pump(tester, const RunDetailScreen(runId: 'run-pl-001'));

      expect(find.textContaining('live for 2m 00s'), findsOneWidget);
      expect(find.textContaining('in n_kyc for 1m 00s'), findsOneWidget);
      // startedAt+15m = 10:13Z = 15:43 IST, 13m away from _t0.
      expect(
          find.textContaining(
              'sweeper acts at 03 Jul 15:43:00 IST (in 13m 00s)'),
          findsOneWidget);
    });

    testWidgets('stuck run past its deadline: sweeper OVERDUE', (tester) async {
      await _pump(tester, const RunDetailScreen(runId: 'run-pl-002'));

      expect(find.textContaining('live for 40m 00s'), findsOneWidget);
      expect(find.textContaining('in n_kyc for 39m 00s'), findsOneWidget);
      expect(find.textContaining('sweeper OVERDUE — force-fail imminent'),
          findsOneWidget);
    });

    testWidgets('ended run: a single took line, no sweeper talk',
        (tester) async {
      await _pump(tester, const RunDetailScreen(runId: 'run-pl-003'));

      expect(find.text('took 4m 00s'), findsOneWidget);
      expect(find.textContaining('sweeper'), findsNothing);
      expect(find.textContaining('live for'), findsNothing);
    });
  });

  group('compensation saga (detail)', () {
    testWidgets('COMPENSATING run: amber progress line, #comp timeline row, '
        'failed-class badge on the canvas', (tester) async {
      await _pump(tester, const RunDetailScreen(runId: 'run-pl-008'));

      expect(find.textContaining('COMPENSATING the failure at n_kyc'),
          findsOneWidget);
      expect(find.textContaining('still undoing: n_customer'), findsOneWidget);
      expect(find.textContaining('decision already sent'), findsOneWidget);
      expect(find.text('n_customer#comp'),
          findsNWidgets(2)); // Gantt bar + timeline list row
      expect(find.text('failed · PERMANENT'), findsOneWidget); // canvas badge
      expect(find.text('PERMANENT'), findsOneWidget); // timeline FAILED row
    });
  });

  group('timeline stats (detail)', () {
    testWidgets('rows carry +delta latency chips against the previous row',
        (tester) async {
      await _pump(tester, const RunDetailScreen(runId: 'run-pl-005'));

      expect(find.text('+0s'), findsOneWidget); // same-minute completion
      expect(find.text('+1m 00s'), findsNWidgets(2)); // kyc dispatch, kyc fail
      expect(find.text('took 2m 00s'), findsOneWidget);
      expect(find.text('PERMANENT'), findsOneWidget); // FAILED row class
      expect(find.text('failed · PERMANENT'), findsOneWidget); // canvas badge
    });

    testWidgets('re-dispatched node: attempts on the timeline, class on the '
        'canvas', (tester) async {
      await _pump(tester, const RunDetailScreen(runId: 'run-pl-006'));

      expect(find.text('attempts 3'), findsOneWidget); // DISPATCHED, attempts>1
      expect(find.text('TRANSIENT'), findsOneWidget); // FAILED row class
      expect(find.text('failed · TRANSIENT'), findsOneWidget); // canvas badge
    });
  });

  group('canvas retry ladder (detail)', () {
    testWidgets('an ACTIVE node mid-retry wears the try-N badge',
        (tester) async {
      final run = RunDetail(
        runId: 'run-syn-retry',
        journeyKey: 'loan-origination',
        journeyVersion: 2,
        status: OpsStatus.running,
        sfdcNotified: SfdcNotified.none,
        startedAt: _t0.subtract(const Duration(minutes: 3)),
        nodeStats: const [NodeStat(nodeId: 'n_kyc', attempts: 2)],
        transitions: [
          TransitionEntry(
              seq: 0,
              nodeId: 'n_customer',
              status: 'DISPATCHED',
              at: _t0.subtract(const Duration(minutes: 3))),
          TransitionEntry(
              seq: 1,
              nodeId: 'n_customer',
              status: 'COMPLETED',
              at: _t0.subtract(const Duration(minutes: 3))),
          TransitionEntry(
              seq: 2,
              nodeId: 'n_kyc',
              status: 'DISPATCHED',
              at: _t0.subtract(const Duration(minutes: 2))),
        ],
      );
      await _pump(tester, const RunDetailScreen(runId: 'run-syn-retry'),
          api: _OneRunApi(run));

      expect(find.text('active · try 2'), findsOneWidget); // canvas badge
      expect(find.text('attempts 2'), findsOneWidget); // its DISPATCHED row
    });
  });
}
