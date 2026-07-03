/// THE NON-NEGOTIABLE RENDERING RULE (spec C.4), locked from every angle this
/// widget kit can express it: COMPLETED—DECLINED is a NORMAL COMPLETION. A
/// declined loan shown red pages someone at 2am for a correctly-rejected
/// application.
///
/// RED-proof: flipping `StatusVisuals.colorOf(completedDeclined)` to the
/// failure color (or its icon to the failure icon) turns this file red —
/// exercised during development and recorded at the P1b gate.
///
/// The int channel getters (alpha/red/green/blue) are the only Color API that
/// exists across the workspace's full Flutter range (3.22 floor .. current
/// stable, where they are deprecated in favor of the double .a/.r/.g/.b that
/// the floor doesn't have). Deprecated-but-working beats unportable:
// ignore_for_file: deprecated_member_use
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/domain/ops_status.dart';
import 'package:journey_ops_view/features/common/status_visuals.dart';

Future<void> _pumpChip(WidgetTester tester, OpsStatus status) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: Center(child: StatusChip(status: status))),
  ));
}

/// Every color the chip actually painted: container fill, border, icon, text.
Set<Color> _paintedColors(WidgetTester tester) {
  final colors = <Color>{};
  for (final w in tester.widgetList(find.byType(Container))) {
    final deco = (w as Container).decoration;
    if (deco is BoxDecoration) {
      if (deco.color != null) colors.add(deco.color!);
      final border = deco.border;
      if (border is Border) colors.add(border.top.color);
    }
  }
  for (final w in tester.widgetList(find.byType(Icon))) {
    final c = (w as Icon).color;
    if (c != null) colors.add(c);
  }
  for (final w in tester.widgetList(find.byType(Text))) {
    final c = (w as Text).style?.color;
    if (c != null) colors.add(c);
  }
  return colors;
}

bool _isRedFamily(Color c) {
  // Failure red or anything visually adjacent: strong red channel dominating.
  return c.alpha > 0 && c.red > 170 && c.red > c.green * 2 && c.red > c.blue * 2;
}

void main() {
  testWidgets('DECLINED chip carries the exact vocabulary label', (tester) async {
    await _pumpChip(tester, OpsStatus.completedDeclined);
    expect(find.text('COMPLETED—DECLINED'), findsOneWidget);
  });

  testWidgets('DECLINED-IS-NOT-RED: no pixel source in the declined chip is '
      'the failure color or any red', (tester) async {
    await _pumpChip(tester, OpsStatus.completedDeclined);
    final painted = _paintedColors(tester);

    expect(painted, isNot(contains(StatusVisuals.failure)));
    expect(
      painted
          .map((c) => Color.fromARGB(255, c.red, c.green, c.blue))
          .where(_isRedFamily),
      isEmpty,
      reason: 'a business decline must never wear the failure family',
    );
  });

  testWidgets('DECLINED renders as a COMPLETION: check icon, completion hue, '
      'never the alarm icon', (tester) async {
    await _pumpChip(tester, OpsStatus.completedDeclined);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsNothing);
    expect(StatusVisuals.colorOf(OpsStatus.completedDeclined),
        StatusVisuals.completionDeclined);
    expect(StatusVisuals.iconOf(OpsStatus.completedDeclined),
        StatusVisuals.iconOf(OpsStatus.completedApproved),
        reason: 'declined and approved share the completion icon family');
  });

  testWidgets('control: the FAILURE chips DO wear red (proves the assertion '
      'above bites)', (tester) async {
    for (final failed in [
      OpsStatus.failedSfdcNotified,
      OpsStatus.failedNotifyPending,
    ]) {
      await _pumpChip(tester, failed);
      final painted = _paintedColors(tester);
      expect(painted, contains(StatusVisuals.failure), reason: '$failed');
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    }
  });

  testWidgets('the five statuses render five distinct labels through ONE '
      'widget (no second rendering path to drift)', (tester) async {
    for (final s in OpsStatus.values) {
      await _pumpChip(tester, s);
      expect(find.text(s.label), findsOneWidget, reason: s.name);
    }
  });
}
