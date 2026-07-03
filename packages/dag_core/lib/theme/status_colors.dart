/// Shared status color TOKENS (build doc §10) — the visual vocabulary badges,
/// diff, canvas and the ops overlay all draw from, so the two apps can never
/// disagree about what green/amber/red mean. App-specific mappings (e.g.
/// ApprovalStatus -> color in the Designer) live in the apps.
library;

import 'package:flutter/material.dart';

class StatusColors {
  const StatusColors._();

  static const draft = Color(0xFFE0A100); // amber
  static const pending = Color(0xFF2D74DA); // blue
  static const published = Color(0xFF2E9E5B); // green
  static const rejected = Color(0xFFD9483B); // red
  static const approved = Color(0xFF2E9E5B);
}
