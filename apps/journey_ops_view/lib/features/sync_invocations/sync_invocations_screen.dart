/// The SYNC-LANE audit list — the counterpart to the runs list, but for
/// in-thread calls that never became journeys (imps-disbursal money movement,
/// lms-utilities queries). These are a SEPARATE surface, never faked as runs:
/// there is no journey to open, no DAG to overlay — the caller blocked on the
/// call and got its answer inline. The list carries the same idioms as the runs
/// screen (capability/outcome filters, pagination, a 15s poll with backoff that
/// never blanks data it already has) and the same colour language (SUCCESS green,
/// a business "no" teal, only a break red).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/ops_api.dart' show OpsApiException;
import '../../domain/sync_invocation.dart';
import '../common/sync_outcome_visuals.dart';
import '../common/timestamp_text.dart';

const _pollInterval = Duration(seconds: 15);
const _pollBackoffCap = Duration(seconds: 120);
const _pageSize = 20;

/// The known sync capabilities. `all` clears the server-side capability param.
enum _CapabilityFilter {
  all('All', null),
  imps('imps-disbursal', 'imps-disbursal'),
  lms('lms-utilities', 'lms-utilities');

  const _CapabilityFilter(this.label, this.key);
  final String label;
  final String? key;
}

class SyncInvocationsScreen extends ConsumerStatefulWidget {
  const SyncInvocationsScreen({super.key});

  @override
  ConsumerState<SyncInvocationsScreen> createState() =>
      _SyncInvocationsScreenState();
}

class _SyncInvocationsScreenState extends ConsumerState<SyncInvocationsScreen> {
  _CapabilityFilter _capability = _CapabilityFilter.all;
  SyncOutcome? _outcome; // null = all outcomes
  int _page = 0;
  SyncInvocationsPage? _data;

  bool _loading = false;
  String? _refreshError;
  DateTime? _lastRefreshed;
  Timer? _pollTimer;
  Duration _currentPoll = _pollInterval;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _schedulePoll() {
    _pollTimer?.cancel();
    _pollTimer = Timer(_currentPoll, _load);
  }

  Future<void> _load() async {
    final api = ref.read(syncOpsApiProvider);
    setState(() => _loading = true);
    try {
      final data = await api.invocations(
        capability: _capability.key,
        outcome: _outcome,
        page: _page,
        size: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _data = data;
        _lastRefreshed = DateTime.now();
        _refreshError = null;
      });
      _currentPoll = _pollInterval; // success resets the backoff
    } catch (e) {
      if (!mounted) return;
      // Keep showing the last-known list; back the poll off.
      _refreshError = '$e';
      final doubled = _currentPoll * 2;
      _currentPoll = doubled > _pollBackoffCap ? _pollBackoffCap : doubled;
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        _schedulePoll();
      }
    }
  }

  void _setCapability(_CapabilityFilter c) {
    setState(() {
      _capability = c;
      _page = 0;
    });
    _load();
  }

  void _setOutcome(SyncOutcome? o) {
    setState(() {
      _outcome = o;
      _page = 0;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync invocations'),
        actions: [
          if (_lastRefreshed != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Last refreshed ${formatIstShort(_lastRefreshed!)}',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh now',
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: Column(
        children: [
          const _WhatIsThisBanner(),
          if (_refreshError != null)
            MaterialBanner(
              backgroundColor: const Color(0x33D64545),
              content: Text(
                'Refresh failing — showing last-known data'
                '${_lastRefreshed != null ? ' from ${formatIstShort(_lastRefreshed!)}' : ''}. '
                '($_refreshError)',
                style: const TextStyle(fontSize: 12),
              ),
              actions: [
                TextButton(onPressed: _load, child: const Text('Retry')),
              ],
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  for (final c in _CapabilityFilter.values)
                    ChoiceChip(
                      label: Text(c.label,
                          style: const TextStyle(fontSize: 11.5)),
                      selected: _capability == c,
                      onSelected: (_) => _setCapability(c),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  ChoiceChip(
                    label: const Text('All outcomes',
                        style: TextStyle(fontSize: 11.5)),
                    selected: _outcome == null,
                    onSelected: (_) => _setOutcome(null),
                    visualDensity: VisualDensity.compact,
                  ),
                  for (final o in SyncOutcome.values)
                    ChoiceChip(
                      label: Text(o.label,
                          style: const TextStyle(fontSize: 11.5)),
                      selected: _outcome == o,
                      selectedColor: SyncOutcomeVisuals.colorOf(o).withAlpha(60),
                      onSelected: (_) => _setOutcome(o),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildList()),
          _PaginationBar(
            page: _data?.page ?? 0,
            totalPages: _data?.totalPages ?? 0,
            totalItems: _data?.totalItems ?? 0,
            onPrev: _page > 0
                ? () {
                    setState(() => _page--);
                    _load();
                  }
                : null,
            onNext: (_data != null && _page < _data!.totalPages - 1)
                ? () {
                    setState(() => _page++);
                    _load();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final items = _data?.items;
    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty) {
      return const Center(child: Text('No sync invocations match this filter.'));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => _InvocationTile(invocation: items[i]),
    );
  }
}

/// The always-on explainer: these are NOT journeys. Management and new ops staff
/// must not hunt for a run that will never exist.
class _WhatIsThisBanner extends StatelessWidget {
  const _WhatIsThisBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0x1AFF9800), // orange = the sync lane's family
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.bolt, size: 16, color: Color(0xFFFF9800)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'In-thread sync calls — not journeys. The caller BLOCKED on each of '
              'these and got its answer inline; there is no DAG to open. This is '
              'the thin audit trail of what was invoked, deduped replays included.',
              style: TextStyle(fontSize: 11.5, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvocationTile extends StatelessWidget {
  const _InvocationTile({required this.invocation});

  final SyncInvocation invocation;

  @override
  Widget build(BuildContext context) {
    final inv = invocation;
    final hasKey = (inv.idempotencyKey ?? '').isNotEmpty;
    return ListTile(
      dense: true,
      title: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SyncOutcomeChip(outcome: inv.outcome, dense: true),
          Text(inv.capability,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text('· ${inv.operation}',
              style: const TextStyle(fontSize: 11.5, color: Colors.white60)),
          if (inv.deduped) const DedupBadge(),
        ],
      ),
      subtitle: Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('started ', style: TextStyle(fontSize: 11)),
          TimestampText(inv.startedAt, style: const TextStyle(fontSize: 11)),
          Text(' · took ${formatDuration(inv.duration)}',
              style: const TextStyle(fontSize: 11, color: Colors.white54)),
          if ((inv.source ?? '').isNotEmpty)
            Text(' · via ${inv.source}',
                style: const TextStyle(fontSize: 11, color: Colors.white60)),
          if (hasKey)
            Text(' · key ${inv.idempotencyKey}',
                style: const TextStyle(fontSize: 11, color: Colors.white38)),
          if ((inv.transactionId ?? '').isNotEmpty)
            Text(' · txn ${inv.transactionId}',
                style: const TextStyle(fontSize: 11, color: Colors.white38)),
          if ((inv.errorClass ?? '').isNotEmpty)
            Text(' · ${inv.errorClass}/${inv.errorCode ?? '?'}',
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFFD64545))),
        ],
      ),
      trailing: hasKey
          ? const Icon(Icons.link, size: 16, color: Colors.white38)
          : null,
      onTap: hasKey
          ? () => showDialog<void>(
                context: context,
                builder: (_) => _DedupChainDialog(
                    idempotencyKey: inv.idempotencyKey!),
              )
          : null,
    );
  }
}

/// The by-key drill-down: the transfer + every idempotent replay that carried the
/// same business dedup id. Answers "did this money move once, or did a retry
/// double it?" — the whole point of recording deduped replays.
class _DedupChainDialog extends ConsumerWidget {
  const _DedupChainDialog({required this.idempotencyKey});

  final String idempotencyKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('Dedup chain · $idempotencyKey',
          style: const TextStyle(fontSize: 15)),
      content: SizedBox(
        width: 420,
        child: FutureBuilder<List<SyncInvocation>>(
          future: ref.read(syncOpsApiProvider).byKey(idempotencyKey),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snap.hasError) {
              final e = snap.error;
              final msg = e is OpsApiException ? e.message : '$e';
              return Text('Could not load the chain: $msg',
                  style: const TextStyle(fontSize: 12));
            }
            final chain = snap.data ?? const <SyncInvocation>[];
            if (chain.isEmpty) {
              return const Text('No invocations carry that key.',
                  style: TextStyle(fontSize: 12));
            }
            final effected = chain.where((c) => !c.deduped).length;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  effected <= 1
                      ? '$effected effecting call, ${chain.length - effected} deduped replay(s) — money moved at most once.'
                      : '⚠ $effected effecting calls share this key — investigate a possible double.',
                  style: TextStyle(
                    fontSize: 12,
                    color: effected <= 1
                        ? Colors.white70
                        : const Color(0xFFD64545),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: chain.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final c = chain[i];
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SyncOutcomeChip(outcome: c.outcome, dense: true),
                            Text(c.invocationId,
                                style: const TextStyle(fontSize: 11.5)),
                            if (c.deduped) const DedupBadge(),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            TimestampText(c.startedAt,
                                style: const TextStyle(fontSize: 10.5)),
                            Text('  ·  ${formatDuration(c.duration)}',
                                style: const TextStyle(
                                    fontSize: 10.5, color: Colors.white54)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
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

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.page,
    required this.totalPages,
    required this.totalItems,
    required this.onPrev,
    required this.onNext,
  });

  final int page;
  final int totalPages;
  final int totalItems;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous page',
            onPressed: onPrev,
          ),
          Text(
            totalPages == 0
                ? 'No invocations'
                : 'Page ${page + 1} of $totalPages · $totalItems invocations',
            style: const TextStyle(fontSize: 12),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next page',
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
