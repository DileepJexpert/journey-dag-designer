/// Temporal-style "Workflows" analytics: per-journey aggregate metrics from
/// GET /ops/metrics. Read-only, ids/counts only — each journey gets a status
/// proportion bar, counts, success rate, and end-to-end duration p50/p95.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models.dart';
import '../../domain/ops_status.dart';
import '../common/status_visuals.dart';
import '../common/timestamp_text.dart';

class MetricsScreen extends ConsumerWidget {
  const MetricsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(metricsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey metrics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(metricsProvider),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _MetricsError(
            message: '$e', onRetry: () => ref.invalidate(metricsProvider)),
        data: (m) => _MetricsBody(metrics: m),
      ),
    );
  }
}

class _MetricsError extends StatelessWidget {
  const _MetricsError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Metrics unavailable\n$message',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      );
}

class _MetricsBody extends StatelessWidget {
  const _MetricsBody({required this.metrics});
  final OpsMetrics metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.journeys.isEmpty) {
      return const Center(
        child: Text('No runs yet — fire a journey to see metrics.',
            style: TextStyle(color: Colors.white54)),
      );
    }
    final totalRuns = metrics.journeys.fold<int>(0, (s, j) => s + j.total);
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
          child: Text(
            '${metrics.journeys.length} journeys · $totalRuns runs · '
            'as of ${formatIstShort(metrics.generatedAt)}',
            style: const TextStyle(fontSize: 12, color: Colors.white54),
          ),
        ),
        for (final j in metrics.journeys) _JourneyMetricCard(m: j),
      ],
    );
  }
}

class _JourneyMetricCard extends StatelessWidget {
  const _JourneyMetricCard({required this.m});
  final JourneyMetric m;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(m.journeyKey,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ),
                Text('${m.total} runs',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.white60)),
              ],
            ),
            const SizedBox(height: 8),
            _proportionBar(),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _chip('✓ ${m.completedApproved} approved',
                    StatusVisuals.colorOf(OpsStatus.completedApproved)),
                if (m.completedDeclined > 0)
                  _chip('${m.completedDeclined} declined',
                      StatusVisuals.colorOf(OpsStatus.completedDeclined)),
                if (m.failed > 0)
                  _chip('✗ ${m.failed} failed',
                      StatusVisuals.colorOf(OpsStatus.failedNotifyPending)),
                if (m.running > 0)
                  _chip('▶ ${m.running} running',
                      StatusVisuals.colorOf(OpsStatus.running)),
                if (m.stuck > 0)
                  _chip('${m.stuck} stuck', const Color(0xFFE0A100)),
                _chip('success ${(m.approvalRate * 100).round()}%', null),
                if (m.p50 != null) _chip('p50 ${formatDuration(m.p50!)}', null),
                if (m.p95 != null) _chip('p95 ${formatDuration(m.p95!)}', null),
                _chip('${m.startedLast24h} in 24h', null),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Stacked proportion of the terminal + running counts (flex = count).
  Widget _proportionBar() {
    final segments = <Widget>[];
    void seg(int count, OpsStatus status) {
      if (count > 0) {
        segments.add(Expanded(
            flex: count,
            child: Container(color: StatusVisuals.colorOf(status))));
      }
    }

    seg(m.completedApproved, OpsStatus.completedApproved);
    seg(m.completedDeclined, OpsStatus.completedDeclined);
    seg(m.failed, OpsStatus.failedNotifyPending);
    seg(m.running, OpsStatus.running);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 10,
        child: segments.isEmpty
            ? Container(color: Colors.white10)
            : Row(children: segments),
      ),
    );
  }

  Widget _chip(String label, Color? color) {
    final c = color ?? Colors.white38;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: c.withValues(alpha: 0.15),
        border: Border.all(color: c.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}
