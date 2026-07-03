/// Live validation panel (build doc §6, §10 "Validation UX"). Renders the pure
/// [DagValidator] output for the working DAG; tapping an issue focuses its node
/// on the canvas. Errors gate Submit; warnings are advisory.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dag_core/dag_core.dart';
import '../editor_controller.dart';

class ValidationPanel extends ConsumerWidget {
  const ValidationPanel({super.key, required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = editorControllerProvider(journeyId);
    final result = ref.watch(provider.select((s) => s.validation));
    final controller = ref.read(provider.notifier);

    if (result.issues.isEmpty) {
      return const _Clean();
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _Tally(
                  count: result.errors.length,
                  color: StatusColors.rejected,
                  label: 'errors'),
              const SizedBox(width: 12),
              _Tally(
                  count: result.warnings.length,
                  color: StatusColors.draft,
                  label: 'warnings'),
            ],
          ),
        ),
        for (final issue in result.issues)
          _IssueTile(issue: issue, onTap: () => controller.select(issue.nodeId)),
      ],
    );
  }
}

class _IssueTile extends StatelessWidget {
  const _IssueTile({required this.issue, required this.onTap});
  final ValidationIssue issue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isError = issue.severity == ValidationSeverity.error;
    final color = isError ? StatusColors.rejected : StatusColors.draft;
    return ListTile(
      dense: true,
      leading: Icon(isError ? Icons.error_outline : Icons.warning_amber,
          color: color, size: 20),
      title: Text(issue.message, style: const TextStyle(fontSize: 13)),
      subtitle: Text(
        '${issue.code.name}${issue.nodeId != null ? '  ·  ${issue.nodeId}' : ''}',
        style: const TextStyle(fontSize: 11),
      ),
      trailing: issue.nodeId == null
          ? null
          : const Icon(Icons.my_location, size: 16),
      onTap: issue.nodeId == null ? null : onTap,
    );
  }
}

class _Tally extends StatelessWidget {
  const _Tally({required this.count, required this.color, required this.label});
  final int count;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 11, backgroundColor: color, child: Text('$count', style: const TextStyle(fontSize: 12, color: Colors.white))),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _Clean extends StatelessWidget {
  const _Clean();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: StatusColors.published, size: 40),
          SizedBox(height: 8),
          Text('Valid — ready to submit.'),
        ],
      ),
    );
  }
}
