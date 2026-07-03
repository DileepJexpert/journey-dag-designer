/// Canonical config preview (build doc §2, §6). Shows exactly what the
/// [ConfigSerializer] emits for the working DAG — the byte-for-byte contract the
/// orchestration engine's loader consumes. Copy-to-clipboard for handing the
/// config to the backend / committing it as a fixture.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../editor_controller.dart';

class ConfigPreview extends ConsumerWidget {
  const ConfigPreview({super.key, required this.journeyId});
  final String journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editorControllerProvider(journeyId));
    final serializer = ref.read(configSerializerProvider);
    final key = state.journey?.key ?? 'journey';
    final json = state.dag.nodes.isEmpty
        ? '// empty journey — add nodes to generate config'
        : serializer.toJsonString(state.dag, key: key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          child: Row(
            children: [
              Expanded(
                child: Text('$key.journey.json',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              TextButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: json));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Config copied')),
                    );
                  }
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              json,
              style: const TextStyle(
                  fontFamily: 'monospace', fontSize: 12, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
