/// The acceptance walk's first step (spec E): open the app, assert who you
/// are, land on the runs list — in mock mode with NO provider overrides, i.e.
/// exactly what `flutter run` boots.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/app/app.dart';

void main() {
  testWidgets('identity gate -> runs list, wired end-to-end in mock mode',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: OpsApp()));
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
