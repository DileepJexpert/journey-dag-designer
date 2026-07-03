/// The runs list behaviors (spec C.3): filter chips, TRIAGE ordering with a
/// notify-pending run on top, EXACT search, pagination, last-refreshed.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/app/providers.dart';
import 'package:journey_ops_view/data/graph_repository.dart';
import 'package:journey_ops_view/data/mock_ops_api.dart';
import 'package:journey_ops_view/features/runs/runs_screen.dart';

Widget _app() => ProviderScope(
      overrides: [
        opsApiProvider
            .overrideWithValue(MockOpsApi(now: DateTime.utc(2026, 7, 3, 10))),
        graphRepositoryProvider.overrideWithValue(MockGraphRepository()),
      ],
      child: const MaterialApp(home: RunsScreen()),
    );

/// Dispose the screen so its poll timer is cancelled before the test ends.
Future<void> _teardown(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
}

void main() {
  testWidgets('lists newest first with honest pagination and a last-refreshed '
      'stamp', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('run-pl-001'), findsOneWidget); // newest run on top
    expect(find.text('Page 1 of 2 · 26 runs'), findsOneWidget);
    expect(find.textContaining('Last refreshed'), findsOneWidget);

    await _teardown(tester);
  });

  testWidgets('TRIAGE puts the FAILED—notify-pending run ON TOP, stuck '
      'running below it, and drops pagination', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('TRIAGE'));
    await tester.pumpAndSettle();

    expect(find.text('run-pl-006'), findsOneWidget); // notify-pending
    expect(find.text('run-pl-002'), findsOneWidget); // stuck running
    final pendingY = tester.getTopLeft(find.text('run-pl-006')).dy;
    final stuckY = tester.getTopLeft(find.text('run-pl-002')).dy;
    expect(pendingY, lessThan(stuckY),
        reason: 'nobody will notify the channel unless a human acts — '
            'notify-pending outranks everything in triage');

    // Only the two triage-worthy runs are listed; healthy/notified runs stay out.
    expect(find.text('run-pl-001'), findsNothing);
    expect(find.text('run-pl-005'), findsNothing);
    expect(find.textContaining('Page 1 of'), findsNothing);

    await _teardown(tester);
  });

  testWidgets('search is EXACT-id: a shared sfdcRecordId returns its two '
      'runs; a prefix returns nothing', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'SFDC-9004');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Exact matches for "SFDC-9004"'), findsOneWidget);
    expect(find.text('run-pl-004'), findsOneWidget);
    expect(find.text('run-pl-006'), findsOneWidget);
    expect(find.text('run-pl-001'), findsNothing);

    await tester.enterText(find.byType(TextField), 'SFDC-900');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('No run carries that exact id.'), findsOneWidget);

    await _teardown(tester);
  });

  testWidgets('pagination pages through the full set', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_right).last);
    await tester.pumpAndSettle();

    expect(find.text('Page 2 of 2 · 26 runs'), findsOneWidget);
    expect(find.text('run-pl-001'), findsNothing);

    await _teardown(tester);
  });

  testWidgets('status chip filters to that vocabulary entry only',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Completed—Declined'));
    await tester.pumpAndSettle();

    expect(find.text('run-pl-004'), findsOneWidget);
    expect(find.text('run-pl-001'), findsNothing); // running, filtered out
    expect(find.text('run-pl-003'), findsNothing); // approved, filtered out

    await _teardown(tester);
  });
}
