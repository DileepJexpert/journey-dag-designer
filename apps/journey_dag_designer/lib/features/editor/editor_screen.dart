/// Journey editor (build doc §7, §8, §10). The authoring surface: a capability
/// palette, the visual DAG canvas, and a right rail that tabs between the node
/// inspector, live validation, and the canonical config preview. The top bar
/// carries the maker-checker lifecycle controls — Save / Submit (maker) and
/// Approve / Reject (checker, with author≠approver enforced) — plus a version
/// selector.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/auth/auth_controller.dart';
import '../../core/auth/role_gate.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/journey.dart';
import 'editor_controller.dart';
import 'widgets/config_preview.dart';
import 'widgets/dag_canvas.dart';
import 'widgets/node_inspector.dart';
import 'widgets/palette.dart';
import 'widgets/validation_panel.dart';

class EditorScreen extends ConsumerWidget {
  const EditorScreen({super.key, required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = editorControllerProvider(journeyId);
    final state = ref.watch(provider);

    // Surface action errors as a snackbar.
    ref.listen(provider.select((s) => s.error), (_, err) {
      if (err != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err)));
      }
    });

    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.journey == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: Center(child: Text(state.error ?? 'Journey not found')),
      );
    }

    final journey = state.journey!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/journeys'),
        ),
        title: Row(
          children: [
            Flexible(child: Text(journey.name, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 10),
            _VersionSelector(journeyId: journeyId),
            if (state.dirty) ...[
              const SizedBox(width: 8),
              const Chip(
                label: Text('unsaved', style: TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        ),
        actions: [
          if (state.busy)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                  child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))),
            ),
          _ActionBar(journeyId: journeyId),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: 220,
            child: Material(
              color: const Color(0xFF15191F),
              child: Palette(journeyId: journeyId),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Container(
              color: const Color(0xFF0C0E12),
              child: DagCanvas(journeyId: journeyId),
            ),
          ),
          const VerticalDivider(width: 1),
          SizedBox(
            width: 340,
            child: Material(
              color: const Color(0xFF15191F),
              child: _RightRail(journeyId: journeyId),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionSelector extends ConsumerWidget {
  const _VersionSelector({required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = editorControllerProvider(journeyId);
    final state = ref.watch(provider);
    final journey = state.journey!;
    if (journey.versions.isEmpty) return const SizedBox.shrink();

    final versions = [...journey.versions]
      ..sort((a, b) => b.version.compareTo(a.version));

    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: state.workingVersion,
        borderRadius: BorderRadius.circular(8),
        items: [
          for (final v in versions)
            DropdownMenuItem(
              value: v.version,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('v${v.version}',
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 6),
                  _StatusDot(status: v.status),
                  const SizedBox(width: 4),
                  Text(v.status.name, style: const TextStyle(fontSize: 11)),
                  if (journey.activeVersion == v.version)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.bolt,
                          size: 13, color: StatusColors.published),
                    ),
                ],
              ),
            ),
        ],
        onChanged: (v) =>
            v == null ? null : ref.read(provider.notifier).selectVersion(v),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});
  final ApprovalStatus status;
  @override
  Widget build(BuildContext context) => Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
            color: statusColorOf(status), shape: BoxShape.circle),
      );
}

/// The lifecycle controls. Buttons stay visible but disable (with a tooltip)
/// when the action isn't available — clearer than hiding them.
class _ActionBar extends ConsumerWidget {
  const _ActionBar({required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = editorControllerProvider(journeyId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final user = ref.watch(authControllerProvider).user;
    final version = state.version;
    final busy = state.busy;

    final isMaker = roleAllows(user, UserRole.maker);
    final isChecker = roleAllows(user, UserRole.checker);

    // Maker, read-only version → fork a new draft.
    if (version != null && !state.isEditable && !state.isPendingApproval) {
      return RoleGate(
        role: UserRole.maker,
        child: FilledButton.icon(
          onPressed: busy ? null : controller.editAsNewDraft,
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Edit as new draft'),
        ),
      );
    }

    final children = <Widget>[];

    if (state.isEditable) {
      children.add(_Btn(
        label: 'Save',
        icon: Icons.save_outlined,
        tooltip: state.dirty ? 'Save draft' : 'No changes',
        onPressed: isMaker && state.dirty && !busy ? controller.save : null,
      ));
      children.add(_Btn(
        label: 'Submit',
        icon: Icons.send,
        filled: true,
        tooltip: state.validation.isValid
            ? 'Submit for approval'
            : 'Fix validation errors first',
        onPressed: isMaker && state.validation.isValid && !busy
            ? controller.submit
            : null,
      ));
    }

    if (state.isPendingApproval) {
      final sameAuthor = user != null && version?.authorId == user.id;
      children.add(_Btn(
        label: 'Reject',
        icon: Icons.close,
        tooltip: isChecker ? 'Reject with a comment' : 'Checker role required',
        onPressed: isChecker && !busy
            ? () => _promptReject(context, controller)
            : null,
      ));
      children.add(_Btn(
        label: 'Approve',
        icon: Icons.check,
        filled: true,
        tooltip: !isChecker
            ? 'Checker role required'
            : sameAuthor
                ? 'Author cannot approve their own version'
                : 'Approve & publish',
        onPressed: isChecker && !sameAuthor && !busy ? controller.approve : null,
      ));
    }

    if (children.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in children) ...[c, const SizedBox(width: 8)],
      ],
    );
  }

  Future<void> _promptReject(
      BuildContext context, EditorController controller) async {
    final ctrl = TextEditingController();
    final comment = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject version'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
              labelText: 'Reason', hintText: 'What needs to change?'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('Reject')),
        ],
      ),
    );
    if (comment != null && comment.isNotEmpty) {
      await controller.reject(comment);
    }
  }
}

class _Btn extends StatelessWidget {
  const _Btn({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final btn = filled
        ? FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 18),
            label: Text(label))
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 18),
            label: Text(label));
    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
  }
}

class _RightRail extends StatelessWidget {
  const _RightRail({required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Inspector'),
              Tab(text: 'Validation'),
              Tab(text: 'Config'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                NodeInspector(journeyId: journeyId),
                ValidationPanel(journeyId: journeyId),
                ConfigPreview(journeyId: journeyId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
