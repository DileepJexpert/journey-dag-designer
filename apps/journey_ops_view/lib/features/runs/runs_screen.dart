/// The runs list (spec C.3): filter chips over the server vocabulary, TRIAGE
/// as a saved filter (notify-pending on top, then stuck), EXACT-id search,
/// pagination, and a 15s poll with backoff that never blanks data it already
/// has — on refresh failure the list stays, marked with when it was last true.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models.dart';
import '../../domain/ops_status.dart';
import '../../data/ops_api.dart';
import '../../domain/triage.dart';
import '../common/status_visuals.dart';
import '../common/timestamp_text.dart';
import '../run_detail/run_detail_screen.dart';

const pollInterval = Duration(seconds: 15);
const pollBackoffCap = Duration(seconds: 120);
const _pageSize = 20;

/// The chip row: the five vocabulary statuses + stuck + the TRIAGE saved
/// filter. Single-select, mirroring the server's single status param.
enum RunsFilter {
  all('All'),
  triage('TRIAGE'),
  running('Running'),
  stuck('Stuck'),
  approved('Completed—Approved'),
  declined('Completed—Declined'),
  failedNotified('Failed—SFDC-notified'),
  failedPending('Failed—notify-pending');

  const RunsFilter(this.label);
  final String label;

  OpsStatus? get status => switch (this) {
        RunsFilter.running => OpsStatus.running,
        RunsFilter.approved => OpsStatus.completedApproved,
        RunsFilter.declined => OpsStatus.completedDeclined,
        RunsFilter.failedNotified => OpsStatus.failedSfdcNotified,
        RunsFilter.failedPending => OpsStatus.failedNotifyPending,
        _ => null,
      };
}

class RunsScreen extends ConsumerStatefulWidget {
  const RunsScreen({super.key});

  @override
  ConsumerState<RunsScreen> createState() => _RunsScreenState();
}

class _RunsScreenState extends ConsumerState<RunsScreen> {
  RunsFilter _filter = RunsFilter.all;
  int _page = 0;
  RunsPage? _data;
  List<RunSummary>? _searchResults;
  List<RunSummary>? _triageResults;
  /// Tier-1 status tiles: label -> count, refreshed with every poll via
  /// size-1 totalItems reads (v1 mechanism — a counts endpoint replaces it
  /// if tile count grows; do not let the hack calcify).
  Map<RunsFilter, int>? _counts;
  String? _activeSearch;
  bool _loading = false;
  String? _refreshError;
  DateTime? _lastRefreshed;
  Timer? _pollTimer;
  Duration _currentPoll = pollInterval;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _schedulePoll() {
    _pollTimer?.cancel();
    _pollTimer = Timer(_currentPoll, _load);
  }

  Future<void> _load() async {
    final api = ref.read(opsApiProvider);
    setState(() => _loading = true);
    try {
      if (_activeSearch != null) {
        final results = await api.search(_activeSearch!);
        if (!mounted) return;
        setState(() => _searchResults = results);
      } else if (_filter == RunsFilter.triage) {
        // TRIAGE = the saved filter: both bands fetched wide (200 = the ops
        // API's max page — beyond that the floor is drowning anyway).
        final pending = await api.runs(
            status: OpsStatus.failedNotifyPending, size: 200);
        final stuck = await api.runs(stuckOnly: true, size: 200);
        if (!mounted) return;
        setState(() => _triageResults = mergeTriage(
            notifyPending: pending.items, stuckRunning: stuck.items));
      } else {
        final data = await api.runs(
          status: _filter.status,
          stuckOnly: _filter == RunsFilter.stuck,
          page: _page,
          size: _pageSize,
        );
        if (!mounted) return;
        setState(() => _data = data);
      }
      _counts = await _fetchCounts(api);
      if (!mounted) return;
      _lastRefreshed = DateTime.now();
      _refreshError = null;
      _currentPoll = pollInterval; // success resets the backoff
    } catch (e) {
      if (!mounted) return;
      // Keep showing the last-known list; back the poll off.
      _refreshError = '$e';
      final doubled = _currentPoll * 2;
      _currentPoll = doubled > pollBackoffCap ? pollBackoffCap : doubled;
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        _schedulePoll();
      }
    }
  }

  /// One size-1 page per tile: totalItems is the count.
  static Future<Map<RunsFilter, int>> _fetchCounts(OpsApi api) async {
    Future<int> count({OpsStatus? status, bool stuckOnly = false}) async =>
        (await api.runs(status: status, stuckOnly: stuckOnly, size: 1))
            .totalItems;
    return {
      RunsFilter.running: await count(status: OpsStatus.running),
      RunsFilter.stuck: await count(stuckOnly: true),
      RunsFilter.failedPending:
          await count(status: OpsStatus.failedNotifyPending),
      RunsFilter.failedNotified:
          await count(status: OpsStatus.failedSfdcNotified),
    };
  }

  void _setFilter(RunsFilter f) {
    setState(() {
      _filter = f;
      _page = 0;
      _activeSearch = null;
      _searchController.clear();
      _searchResults = null;
    });
    _load();
  }

  void _submitSearch(String raw) {
    final key = raw.trim();
    if (key.isEmpty) return;
    setState(() {
      _activeSearch = key;
      _searchResults = null;
    });
    _load();
  }

  void _clearSearch() {
    setState(() {
      _activeSearch = null;
      _searchResults = null;
      _searchController.clear();
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Ops — runs'),
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
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                hintText:
                    'Exact id search: runId · correlationId · notificationId · sfdcRecordId',
                prefixIcon: const Icon(Icons.search, size: 18),
                suffixIcon: _activeSearch != null
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: 'Clear search',
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onSubmitted: _submitSearch,
            ),
          ),
          if (_counts != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: Row(
                children: [
                  _StatusTile(
                      label: 'Running',
                      count: _counts![RunsFilter.running] ?? 0,
                      color: const Color(0xFF4C7DFF),
                      onTap: () => _setFilter(RunsFilter.running)),
                  _StatusTile(
                      label: 'Stuck',
                      count: _counts![RunsFilter.stuck] ?? 0,
                      color: const Color(0xFFE0A100),
                      onTap: () => _setFilter(RunsFilter.stuck)),
                  _StatusTile(
                      label: 'Notify-pending',
                      count: _counts![RunsFilter.failedPending] ?? 0,
                      color: const Color(0xFFD64545),
                      onTap: () => _setFilter(RunsFilter.failedPending)),
                  _StatusTile(
                      label: 'Failed-notified',
                      count: _counts![RunsFilter.failedNotified] ?? 0,
                      color: const Color(0xFFB05454),
                      onTap: () => _setFilter(RunsFilter.failedNotified)),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  for (final f in RunsFilter.values)
                    ChoiceChip(
                      label: Text(f.label,
                          style: const TextStyle(fontSize: 11.5)),
                      selected: _filter == f && _activeSearch == null,
                      onSelected: (_) => _setFilter(f),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          ),
          if (_activeSearch != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Exact matches for "$_activeSearch"',
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ),
            ),
          Expanded(child: _buildList()),
          if (_activeSearch == null && _filter != RunsFilter.triage)
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
    final List<RunSummary>? items = _activeSearch != null
        ? _searchResults
        : _filter == RunsFilter.triage
            ? _triageResults
            : _data?.items;

    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty) {
      return Center(
        child: Text(_activeSearch != null
            ? 'No run carries that exact id.'
            : _filter == RunsFilter.triage
                ? 'Triage is clear — nothing needs a human right now.'
                : 'No runs match this filter.'),
      );
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => _RunTile(run: items[i]),
    );
  }
}

class _RunTile extends StatelessWidget {
  const _RunTile({required this.run});

  final RunSummary run;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          StatusChip(status: run.status, dense: true),
          Text(run.runId,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(
            run.journeyVersion == 0
                ? '${run.journeyKey} · legacy (v0)'
                : '${run.journeyKey} @v${run.journeyVersion}',
            style: const TextStyle(fontSize: 11.5, color: Colors.white60),
          ),
          if (run.stuck) const StuckBadge(),
        ],
      ),
      subtitle: Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('started ', style: TextStyle(fontSize: 11)),
          TimestampText(run.startedAt,
              style: const TextStyle(fontSize: 11)),
          if (run.endedAt != null) ...[
            const Text(' · ended ', style: TextStyle(fontSize: 11)),
            TimestampText(run.endedAt!,
                style: const TextStyle(fontSize: 11)),
            Text(' · took ${formatDuration(run.duration!)}',
                style: const TextStyle(fontSize: 11, color: Colors.white54)),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => RunDetailScreen(runId: run.runId),
        ),
      ),
    );
  }
}

/// Tier-1 count tile: tap = apply that filter.
class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withAlpha(115)),
            ),
            child: Column(
              children: [
                Text('$count',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: color)),
                Text(label,
                    style:
                        const TextStyle(fontSize: 10, color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
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
                ? 'No runs'
                : 'Page ${page + 1} of $totalPages · $totalItems runs',
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
