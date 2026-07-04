/// The acceptance walk's first step (spec E): open the app, assert who you
/// are, land on the runs list. The app now defaults to the REAL engine ops API
/// (`OpsEnv.useMockOpsApi` is false), so this pumps the whole [OpsApp] with the
/// seeded mock injected — the identity-gate → runs-list flow, backend-free.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/app/app.dart';
import 'package:journey_ops_view/app/providers.dart';
import 'package:journey_ops_view/data/graph_repository.dart';
import 'package:journey_ops_view/data/mock_ops_api.dart';

void main() {
  testWidgets('identity gate -> runs list, wired end-to-end against the seeded mock',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        opsApiProvider.overrideWithValue(MockOpsApi()),
        graphRepositoryProvider.overrideWithValue(MockGraphRepository()),
      ],
      child: const OpsApp(),
    ));
    await tester.pumpAndSettle();

    // Gated until an operator id is asserted.
    expect(find.text('Journey Ops View'), findsOneWidget);
    expect(find.textContaining('asserted, not authenticated'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'ops-anita');
    await tester.tap(find.text('Enter ops view'));
    await tester.pumpAndSettle();

    // The runs list, served by the seeded mock.
    expect(find.text('Journey Ops — runs'), findsOneWidget);
    expect(find.text('run-pl-001'), findsOneWidget);
    expect(find.text('TRIAGE'), findsOneWidget);

    // Dispose the screen so the poll timer is cancelled.
    await tester.pumpWidget(const SizedBox());
  });
}
