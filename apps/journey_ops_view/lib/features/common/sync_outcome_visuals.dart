/// Sync-outcome rendering — reuses the journey status families so the whole
/// console speaks one colour language: SUCCESS wears the approved-green,
/// BUSINESS_FAILURE wears the declined-teal (a business "no" is NEVER red), and
/// only TECHNICAL_ERROR wears the failure-red.
library;

import 'package:flutter/material.dart';

import '../../domain/sync_invocation.dart';
import 'status_visuals.dart';

class SyncOutcomeVisuals {
  const SyncOutcomeVisuals._();

  static Color colorOf(SyncOutcome outcome) => switch (outcome) {
        SyncOutcome.success => StatusVisuals.completionApproved,
        SyncOutcome.businessFailure => StatusVisuals.completionDeclined,
        SyncOutcome.technicalError => StatusVisuals.failure,
      };

  static IconData iconOf(SyncOutcome outcome) => switch (outcome) {
        SyncOutcome.success => Icons.check_circle_outline,
        SyncOutcome.businessFailure => Icons.do_not_disturb_on_outlined,
        SyncOutcome.technicalError => Icons.error_outline,
      };
}

class SyncOutcomeChip extends StatelessWidget {
  const SyncOutcomeChip({super.key, required this.outcome, this.dense = false});

  final SyncOutcome outcome;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final color = SyncOutcomeVisuals.colorOf(outcome);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: dense ? 6 : 10, vertical: dense ? 2 : 4),
      decoration: BoxDecoration(
        color: color.withAlpha(36),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(SyncOutcomeVisuals.iconOf(outcome),
              size: dense ? 12 : 15, color: color),
          SizedBox(width: dense ? 3 : 5),
          Text(
            outcome.label,
            style: TextStyle(
              color: color,
              fontSize: dense ? 10.5 : 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Marks an idempotent replay (a repeat money-movement that returned the prior
/// result, no second transfer) — the audit-view analog of the run "STUCK" badge.
class DedupBadge extends StatelessWidget {
  const DedupBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x334C7DFF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF4C7DFF)),
      ),
      child: const Text('DEDUPED',
          style: TextStyle(
              fontSize: 10,
              color: Color(0xFF4C7DFF),
              fontWeight: FontWeight.bold)),
    );
  }
}
