/// Journey list (build doc §8 journeys, §11.4) — proves the repository
/// round-trip against the seeded mock. Editor/canvas is a later step.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/auth/auth_controller.dart';
import '../../domain/models/journey.dart';

final journeyListProvider = FutureProvider<List<Journey>>((ref) {
  return ref.watch(journeyRepositoryProvider).listJourneys();
});

class JourneysScreen extends ConsumerWidget {
  const JourneysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeys = ref.watch(journeyListProvider);
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journeys'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text('${user.name}  ·  ${user.roles.map((r) => r.name).join(", ")}'),
              ),
            ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: journeys.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No journeys yet'))
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final j = list[i];
                  final status = j.active?.status ?? ApprovalStatus.draft;
                  return Card(
                    child: ListTile(
                      title: Text(j.name),
                      subtitle: Text(
                        '${j.key}   ·   ${[j.businessLine, j.product, j.partner].where((s) => s != null).join(" / ")}',
                      ),
                      trailing: Chip(
                        label: Text(status.name),
                        backgroundColor: StatusColors.of(status).withValues(alpha: 0.18),
                        side: BorderSide(color: StatusColors.of(status)),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
