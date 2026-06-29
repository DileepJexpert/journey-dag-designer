/// Dark, dense control-plane theme + status tokens (build doc §10). Status
/// palette is shared across badges, diff, and canvas: draft=amber, pending=blue,
/// published=green, rejected=red.
library;

import 'package:flutter/material.dart';

import '../domain/models/journey.dart';

class StatusColors {
  const StatusColors._();
  static const draft = Color(0xFFE0A100); // amber
  static const pending = Color(0xFF2D74DA); // blue
  static const published = Color(0xFF2E9E5B); // green
  static const rejected = Color(0xFFD9483B); // red
  static const approved = Color(0xFF2E9E5B);

  static Color of(ApprovalStatus status) => switch (status) {
        ApprovalStatus.draft => draft,
        ApprovalStatus.pendingApproval => pending,
        ApprovalStatus.approved => approved,
        ApprovalStatus.published => published,
        ApprovalStatus.rejected => rejected,
      };
}

ThemeData buildTheme() {
  const seed = Color(0xFF2D74DA);
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
    scaffoldBackgroundColor: const Color(0xFF101317),
    cardTheme: const CardThemeData(margin: EdgeInsets.all(6)),
    chipTheme: const ChipThemeData(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),
  );
}
