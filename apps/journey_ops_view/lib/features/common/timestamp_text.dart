/// Timestamps the way the ops floor reads them (spec C.3): IST inline,
/// long-press for the full IST + ISO-8601 (UTC) pair with copy buttons.
/// IST is a fixed UTC+05:30 offset — computed directly, no locale dep.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _istOffset = Duration(hours: 5, minutes: 30);
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _two(int v) => v.toString().padLeft(2, '0');

/// `02 Jul 14:05:31 IST`
String formatIstShort(DateTime t) {
  final ist = t.toUtc().add(_istOffset);
  return '${_two(ist.day)} ${_months[ist.month - 1]} '
      '${_two(ist.hour)}:${_two(ist.minute)}:${_two(ist.second)} IST';
}

/// `2026-07-02 14:05:31 IST (UTC+05:30)`
String formatIstFull(DateTime t) {
  final ist = t.toUtc().add(_istOffset);
  return '${ist.year}-${_two(ist.month)}-${_two(ist.day)} '
      '${_two(ist.hour)}:${_two(ist.minute)}:${_two(ist.second)} IST (UTC+05:30)';
}

String formatIso(DateTime t) => t.toUtc().toIso8601String();

/// `12s` / `4m 05s` / `1h 02m` — wall-clock durations for run rows/headers.
String formatDuration(Duration d) {
  final abs = d.isNegative ? Duration.zero : d;
  if (abs.inHours >= 1) {
    return '${abs.inHours}h ${_two(abs.inMinutes % 60)}m';
  }
  if (abs.inMinutes >= 1) {
    return '${abs.inMinutes}m ${_two(abs.inSeconds % 60)}s';
  }
  return '${abs.inSeconds}s';
}

class TimestampText extends StatelessWidget {
  const TimestampText(this.time, {super.key, this.style});

  final DateTime time;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showDialog<void>(
        context: context,
        builder: (_) => _TimestampDialog(time: time),
      ),
      child: Tooltip(
        message: 'Long-press for IST + ISO, copyable',
        child: Text(formatIstShort(time), style: style),
      ),
    );
  }
}

class _TimestampDialog extends StatelessWidget {
  const _TimestampDialog({required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Timestamp'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CopyRow(label: 'IST', value: formatIstFull(time)),
          const SizedBox(height: 8),
          _CopyRow(label: 'ISO-8601', value: formatIso(time)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 70,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: SelectableText(value)),
        IconButton(
          icon: const Icon(Icons.copy, size: 16),
          tooltip: 'Copy',
          onPressed: () => Clipboard.setData(ClipboardData(text: value)),
        ),
      ],
    );
  }
}
