/// Node palette (build doc §5, §13.1). The capability list is populated ONLY
/// from the registry, so an unregistered capability cannot be placed — the
/// config-vs-code boundary made physical. Clicking a capability appends a Task
/// node; the Branch/Terminal buttons add the structural node kinds.
///
/// Disabled wholesale when the version is read-only.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../editor_controller.dart';

class Palette extends ConsumerWidget {
  const Palette({super.key, required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = editorControllerProvider(journeyId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final enabled = state.isEditable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Text('PALETTE',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(letterSpacing: 1.2)),
        ),
        if (!enabled)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text('Read-only version',
                style: TextStyle(fontSize: 11, color: Colors.white54)),
          ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _StructuralButton(
                  icon: Icons.call_split,
                  label: 'Branch',
                  color: StatusColors.draft,
                  onTap: enabled ? controller.addBranch : null),
              _StructuralButton(
                  icon: Icons.account_tree,
                  label: 'Parallel',
                  color: StatusColors.draft,
                  onTap: enabled ? controller.addParallel : null),
              _StructuralButton(
                  icon: Icons.merge,
                  label: 'Join',
                  color: StatusColors.draft,
                  onTap: enabled ? controller.addJoin : null),
              _StructuralButton(
                  icon: Icons.hourglass_empty,
                  label: 'Wait',
                  color: const Color(0xFF8A63D2),
                  onTap: enabled ? controller.addWait : null),
              _StructuralButton(
                  icon: Icons.schedule,
                  label: 'Timer',
                  color: const Color(0xFF8A63D2),
                  onTap: enabled ? controller.addTimer : null),
              _StructuralButton(
                  icon: Icons.person_outline,
                  label: 'Human',
                  color: const Color(0xFF8A63D2),
                  onTap: enabled ? controller.addHuman : null),
              _StructuralButton(
                  icon: Icons.repeat,
                  label: 'Foreach',
                  color: const Color(0xFF1F9E8F),
                  onTap: enabled ? controller.addForeach : null),
              _StructuralButton(
                  icon: Icons.subdirectory_arrow_right,
                  label: 'Subjourney',
                  color: const Color(0xFF1F9E8F),
                  onTap: enabled ? controller.addSubjourney : null),
              _StructuralButton(
                  icon: Icons.stop_circle_outlined,
                  label: 'Terminal',
                  color: StatusColors.published,
                  onTap: enabled ? controller.addTerminal : null),
            ],
          ),
        ),
        const Divider(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('Capabilities',
              style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              for (final cap in state.capabilities)
                Card(
                  child: ListTile(
                    dense: true,
                    enabled: enabled,
                    leading: Icon(
                      cap.isMoneyOrBookingNode
                          ? Icons.account_balance
                          : Icons.bolt,
                      size: 18,
                      color: StatusColors.pending,
                    ),
                    title: Text(cap.name, style: const TextStyle(fontSize: 13)),
                    subtitle: Text(cap.key, style: const TextStyle(fontSize: 11)),
                    trailing: enabled ? const Icon(Icons.add, size: 18) : null,
                    onTap: enabled ? () => controller.addTask(cap.key) : null,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StructuralButton extends StatelessWidget {
  const _StructuralButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        side: BorderSide(color: color.withValues(alpha: 0.5)),
      ),
    );
  }
}
