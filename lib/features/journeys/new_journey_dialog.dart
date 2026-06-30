/// "New Journey" dialog (build doc §8). A maker names the journey, gives it a
/// stable `key`, and optionally scopes it to a business line / product / partner
/// (null = a global template refined later by bindings — build doc §0). On
/// create it registers the journey AND opens an empty editable draft, so the
/// maker lands straight on the canvas with somewhere to author.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models/dag.dart';
import '../../domain/models/scope_dimensions.dart';

/// Shows the dialog. Returns the new journey id, or null if cancelled.
Future<String?> showNewJourneyDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _NewJourneyDialog(),
  );
}

class _NewJourneyDialog extends ConsumerStatefulWidget {
  const _NewJourneyDialog();

  @override
  ConsumerState<_NewJourneyDialog> createState() => _NewJourneyDialogState();
}

class _NewJourneyDialogState extends ConsumerState<_NewJourneyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _key = TextEditingController();
  bool _keyEdited = false;

  String? _businessLine;
  String? _product;
  String? _partner;

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _key.dispose();
    super.dispose();
  }

  /// Derive a slug key from the name until the user edits the key field.
  void _onNameChanged(String v) {
    if (_keyEdited) return;
    final slug = v
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    _key.value = TextEditingValue(
      text: slug,
      selection: TextSelection.collapsed(offset: slug.length),
    );
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = ref.read(journeyRepositoryProvider);
      final journey = await repo.createJourney(
        key: _key.text.trim(),
        name: _name.text.trim(),
        businessLine: _businessLine,
        product: _product,
        partner: _partner,
      );
      // Open an empty editable draft so the canvas has a v1 to author.
      await repo.createDraft(
        journey.id,
        const Dag(startNodeId: '', nodes: []),
        note: 'Initial draft',
      );
      if (mounted) Navigator.of(context).pop(journey.id);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final caps = ref.read(capabilityRepositoryProvider);
    return AlertDialog(
      title: const Text('New journey'),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g. Loan Origination',
                ),
                onChanged: _onNameChanged,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _key,
                decoration: const InputDecoration(
                  labelText: 'Key',
                  helperText: 'Stable id used in config — lowercase-with-dashes',
                ),
                onChanged: (_) => _keyEdited = true,
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'Key is required';
                  if (!RegExp(r'^[a-z0-9][a-z0-9-]*$').hasMatch(t)) {
                    return 'lowercase letters, digits and dashes only';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Scope (optional — null = global template)',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              FutureBuilder<List<BusinessLine>>(
                future: caps.listBusinessLines(),
                builder: (context, snap) => _Dropdown(
                  label: 'Business line',
                  value: _businessLine,
                  items: {
                    for (final b in snap.data ?? const <BusinessLine>[])
                      b.code: b.label,
                  },
                  onChanged: (v) => setState(() => _businessLine = v),
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Product>>(
                future: caps.listProducts(),
                builder: (context, snap) => _Dropdown(
                  label: 'Product',
                  value: _product,
                  items: {
                    for (final p in snap.data ?? const <Product>[])
                      p.code: p.label,
                  },
                  onChanged: (v) => setState(() => _product = v),
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Partner>>(
                future: caps.listPartners(),
                builder: (context, snap) => _Dropdown(
                  label: 'Partner',
                  value: _partner,
                  items: {
                    for (final p in snap.data ?? const <Partner>[])
                      p.code: p.label,
                  },
                  onChanged: (v) => setState(() => _partner = v),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _busy ? null : _create,
          child: _busy
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Create & open'),
        ),
      ],
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('— any —')),
        for (final e in items.entries)
          DropdownMenuItem<String?>(value: e.key, child: Text(e.value)),
      ],
      onChanged: onChanged,
    );
  }
}
