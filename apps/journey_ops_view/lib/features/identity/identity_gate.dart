/// Collects the operator id carried as X-User-Id on EVERY ops request — the
/// server audit-logs each attempt with it. Identity here is ASSERTED, not
/// authenticated (same posture as the Designer): SSO in front of both consoles
/// is a tracked production gate.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

class IdentityGate extends ConsumerStatefulWidget {
  const IdentityGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<IdentityGate> createState() => _IdentityGateState();
}

class _IdentityGateState extends ConsumerState<IdentityGate> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final id = _controller.text.trim();
    if (id.isEmpty) return;
    ref.read(opsActorProvider.notifier).state = id;
  }

  @override
  Widget build(BuildContext context) {
    final actor = ref.watch(opsActorProvider);
    if (actor != null) {
      return widget.child;
    }
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Journey Ops View',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Read-only. Every request is audit-logged.',
                      style:
                          TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Your operator id (X-User-Id)',
                      hintText: 'e.g. ops-anita',
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Enter ops view'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Identity is asserted, not authenticated — SSO in front '
                    'of this console is a tracked production gate.',
                    style: TextStyle(fontSize: 10.5, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
