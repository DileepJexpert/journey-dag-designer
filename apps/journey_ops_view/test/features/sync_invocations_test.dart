/// The sync-invocations list behaviors: it renders as its OWN surface (not runs),
/// labels itself as in-thread calls, filters by capability and by outcome, marks
/// deduped replays, and drills into a dedup chain by idempotency key.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/app/providers.dart';
import 'package:journey_ops_view/data/mock_sync_ops_api.dart';
import 'package:journey_ops_view/features/sync_invocations/sync_invocations_screen.dart';

Widget _app() => ProviderScope(
      overrides: [
        syncOpsApiProvider.overrideWithValue(
            MockSyncOpsApi(now: DateTime.utc(2026, 7, 3, 10))),
      ],
      child: const MaterialApp(home: SyncInvocationsScreen()),
    );

/// Dispose the screen so its poll timer is cancelled before the test ends.
Future<void> _teardown(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
}

void main() {
  testWidgets(
      'lists the sync lane as its OWN surface — labelled not-a-journey, newest '
      'first, deduped replay marked', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // The always-on explainer keeps ops from hunting for a run that never exists.
    expect(find.textContaining('not journeys'), findsOneWidget);

    // All seven fixtures fit one page.
    expect(find.text('Page 1 of 1 · 7 invocations'), findsOneWidget);
    expect(find.textContaining('Last refreshed'), findsOneWidget);

    // The idempotent replay is marked (and the downstream txn is shown).
    expect(find.text('DEDUPED'), findsOneWidget);
    expect(find.textContaining('003712585052'), findsWidgets);

    await _teardown(tester);
  });

  testWidgets('capability filter narrows to lms-utilities only', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // Before filtering, an IMPS transfer with its txn is present.
    expect(find.textContaining('003712585052'), findsWidgets);

    await tester.tap(find.widgetWithText(ChoiceChip, 'lms-utilities'));
    await tester.pumpAndSettle();

    // IMPS records are gone; LMS reads remain.
    expect(find.textContaining('003712585052'), findsNothing);
    expect(find.textContaining('OFFER_CHECK'), findsWidgets);

    await _teardown(tester);
  });

  testWidgets(
      'outcome filter shows only TECHNICAL_ERROR — a business "no" is not '
      'mixed in with breaks', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'TECHNICAL—error'));
    await tester.pumpAndSettle();

    // The two breaks surface with their error ids; the success/business rows drop.
    expect(find.textContaining('AMBIGUOUS'), findsOneWidget);
    expect(find.textContaining('UNKNOWN_REQUEST_CODE'), findsOneWidget);
    expect(find.textContaining('003712585052'), findsNothing);

    await _teardown(tester);
  });

  testWidgets(
      'tapping a keyed invocation opens its dedup chain — proves money moved '
      'at most once', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // The newest row is the IMPS transfer (idem-imps-1); its link opens the chain.
    await tester.tap(find.byIcon(Icons.link).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('idem-imps-1'), findsWidgets);
    expect(find.text('sync-imps-1b'), findsOneWidget); // the deduped replay
    expect(find.textContaining('money moved at most once'), findsOneWidget);

    await _teardown(tester);
  });
}
