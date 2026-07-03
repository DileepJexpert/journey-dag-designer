/// THE single source of status rendering (spec C.4). Every place a run status
/// appears — list chips, detail headers, related-runs rows — renders through
/// [StatusChip]/[StatusVisuals], so the non-negotiable rule lives in exactly
/// one file: COMPLETED—DECLINED wears the COMPLETION family, never the failure
/// family. The DECLINED-is-not-red test locks these constants.
library;

import 'package:dag_core/dag_core.dart';
import 'package:flutter/material.dart';

import '../../domain/ops_status.dart';
import '../../domain/overlay_mapper.dart';

class StatusVisuals {
  const StatusVisuals._();

  // The three visual families. Declined completions get their own hue INSIDE
  // the completion family (teal vs green) so approved/declined are scannable,
  // but declined shares nothing with red.
  static const Color running = Color(0xFF4C7DFF);
  static const Color completionApproved = Color(0xFF2E9E6B);
  static const Color completionDeclined = Color(0xFF1F9E8F);
  static const Color failure = Color(0xFFD64545);

  static Color colorOf(OpsStatus status) => switch (status) {
        OpsStatus.running => running,
        OpsStatus.completedApproved => completionApproved,
        OpsStatus.completedDeclined => completionDeclined,
        OpsStatus.failedSfdcNotified ||
        OpsStatus.failedNotifyPending =>
          failure,
      };

  /// Completions get a check — INCLUDING declined: the journey finished and
  /// did its job; the business said no. Only the failure family alarms.
  static IconData iconOf(OpsStatus status) => switch (status.kind) {
        OpsStatusKind.running => Icons.play_circle_outline,
        OpsStatusKind.completion => Icons.check_circle_outline,
        OpsStatusKind.failure => Icons.error_outline,
      };

  // ---- node overlay (spec C.2) --------------------------------------------

  static const Color nodeCompleted = completionApproved;
  static const Color nodeActive = running;
  static const Color nodeWaiting = Color(0xFF8A63D2);
  static const Color nodeFailed = failure;

  /// Canvas decoration for a node's run state; null = plain (notReached is
  /// dimmed so the taken path pops).
  static NodeOverlay overlayOf(NodeRunState state) => switch (state) {
        NodeRunState.completed =>
          const NodeOverlay(accent: nodeCompleted, badge: 'done'),
        NodeRunState.active =>
          const NodeOverlay(accent: nodeActive, badge: 'active'),
        NodeRunState.waitingByDesign => const NodeOverlay(
            accent: nodeWaiting, badge: 'waiting (by design)'),
        NodeRunState.failed =>
          const NodeOverlay(accent: nodeFailed, badge: 'failed'),
        NodeRunState.notReached => const NodeOverlay(dimmed: true),
      };
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.dense = false});

  final OpsStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final color = StatusVisuals.colorOf(status);
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
          Icon(StatusVisuals.iconOf(status),
              size: dense ? 12 : 15, color: color),
          SizedBox(width: dense ? 3 : 5),
          Text(
            status.label,
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

/// The stuck marker (D9): shown while a RUNNING run has made no progress
/// inside the liveness budget — it surfaces here BEFORE the sweeper fires.
class StuckBadge extends StatelessWidget {
  const StuckBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x33E0A100),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0A100)),
      ),
      child: const Text('STUCK',
          style: TextStyle(
              fontSize: 10,
              color: Color(0xFFE0A100),
              fontWeight: FontWeight.bold)),
    );
  }
}
