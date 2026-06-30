/// Journey registry list (build doc §8, §11.4). Lists every authored journey
/// with its scope and lifecycle status, lets a maker create a new one, and opens
/// any row in the editor. Scope filters (business line / product / partner) make
/// the "one platform, many channels" surface navigable.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/auth/auth_controller.dart';
import '../../core/auth/role_gate.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/journey.dart';
import 'new_journey_dialog.dart';

final journeyListProvider = FutureProvider.autoDispose<List<Journey>>((ref) {
  return ref.watch(journeyRepositoryProvider).listJourneys();
});

/// Active scope filter (null entries = unfiltered on that axis).
final _filterProvider =
    StateProvider.autoDispose<({String? bl, String? partner})>(
  (ref) => (bl: null, partner: null),
);

class JourneysScreen extends ConsumerWidget {
  const JourneysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeys = ref.watch(journeyListProvider);
    final user = ref.watch(authControllerProvider).user;
    final filter = ref.watch(_filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journeys'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(child: _UserChip(user: user)),
            ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      floatingActionButton: RoleGate(
        role: UserRole.maker,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final id = await showNewJourneyDialog(context);
            if (id != null && context.mounted) {
              ref.invalidate(journeyListProvider);
              context.push('/journeys/$id');
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('New journey'),
        ),
      ),
      body: journeys.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (list) {
          final filtered = list.where((j) {
            if (filter.bl != null && j.businessLine != filter.bl) return false;
            if (filter.partner != null && j.partner != filter.partner) {
              return false;
            }
            return true;
          }).toList()
            ..sort((a, b) => a.name.compareTo(b.name));

          return Column(
            children: [
              _FilterBar(all: list),
              const Divider(height: 1),
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyState(canCreate: roleAllows(user, UserRole.maker))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 88),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) =>
                            _JourneyTile(journey: filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UserChip extends StatelessWidget {
  const _UserChip({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Text('${user.name}  ·  ${user.roles.map((r) => r.name).join(", ")}');
  }
}

class _JourneyTile extends StatelessWidget {
  const _JourneyTile({required this.journey});
  final Journey journey;

  @override
  Widget build(BuildContext context) {
    final draft = journey.draft;
    final published = journey.active;
    final scope = [journey.businessLine, journey.product, journey.partner]
        .where((s) => s != null)
        .join(' / ');

    return Card(
      child: ListTile(
        onTap: () => context.push('/journeys/${journey.id}'),
        title: Text(journey.name),
        subtitle: Text('${journey.key}${scope.isEmpty ? '' : '   ·   $scope'}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (published != null)
              _StatusChip(
                  status: ApprovalStatus.published,
                  label: 'v${published.version} live'),
            if (draft != null) ...[
              const SizedBox(width: 6),
              _StatusChip(
                  status: draft.status,
                  label: 'v${draft.version} ${draft.status.name}'),
            ],
            if (published == null && draft == null)
              const _StatusChip(status: ApprovalStatus.draft, label: 'empty'),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.label});
  final ApprovalStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = StatusColors.of(status);
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: c.withValues(alpha: 0.18),
      side: BorderSide(color: c),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.all});
  final List<Journey> all;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(_filterProvider);
    final bls =
        all.map((j) => j.businessLine).whereType<String>().toSet().toList()
          ..sort();
    final partners =
        all.map((j) => j.partner).whereType<String>().toSet().toList()..sort();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 18),
          const SizedBox(width: 8),
          _FilterMenu(
            label: 'Business line',
            value: filter.bl,
            options: bls,
            onChanged: (v) => ref.read(_filterProvider.notifier).state =
                (bl: v, partner: filter.partner),
          ),
          const SizedBox(width: 8),
          _FilterMenu(
            label: 'Partner',
            value: filter.partner,
            options: partners,
            onChanged: (v) => ref.read(_filterProvider.notifier).state =
                (bl: filter.bl, partner: v),
          ),
          const Spacer(),
          Text('${all.length} journeys',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _FilterMenu extends StatelessWidget {
  const _FilterMenu({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(value == null ? label : '$label: $value'),
      selected: value != null,
      onDeleted: value == null ? null : () => onChanged(null),
      avatar: const Icon(Icons.expand_more, size: 16),
      onPressed: options.isEmpty
          ? null
          : () async {
              final box = context.findRenderObject() as RenderBox;
              final pos = box.localToGlobal(Offset.zero);
              final picked = await showMenu<String>(
                context: context,
                position: RelativeRect.fromLTRB(
                    pos.dx, pos.dy + box.size.height, pos.dx + 1, 0),
                items: [
                  for (final o in options)
                    PopupMenuItem<String>(value: o, child: Text(o)),
                ],
              );
              if (picked != null) onChanged(picked);
            },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.canCreate});
  final bool canCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_tree_outlined, size: 48),
          const SizedBox(height: 12),
          const Text('No journeys match this filter.'),
          if (canCreate) ...[
            const SizedBox(height: 6),
            Text('Use the “New journey” button to author one.',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
