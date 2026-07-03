/// Dark, dense control-plane theme (build doc §10). The status color TOKENS
/// moved to dag_core (shared with the Ops View) and are re-exported here so
/// existing imports keep working; the ApprovalStatus mapping is Designer-only.
library;

import 'package:dag_core/dag_core.dart';
import 'package:flutter/material.dart';

import '../domain/models/journey.dart';

export 'package:dag_core/theme/status_colors.dart';

/// Designer-side mapping: maker-checker status -> shared color token.
Color statusColorOf(ApprovalStatus status) => switch (status) {
      ApprovalStatus.draft => StatusColors.draft,
      ApprovalStatus.pendingApproval => StatusColors.pending,
      ApprovalStatus.approved => StatusColors.approved,
      ApprovalStatus.published => StatusColors.published,
      ApprovalStatus.rejected => StatusColors.rejected,
    };

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
