/// Fetches the graph a run is PINNED to (spec C.2/D): version-exact from the
/// registry's historical endpoint, cached IMMUTABLY — published versions never
/// change (A2), so a version fetched once is correct forever. Legacy v0 runs
/// have no pinned version: render the CURRENT graph, marked approximate, and
/// never let it into the immutable cache.
library;

import 'package:dag_core/dag_core.dart';
import 'package:dio/dio.dart';

/// A graph to render a run against.
class PinnedGraph {
  const PinnedGraph({required this.dag, required this.approximate});

  final Dag dag;

  /// True for legacy v0 runs rendered against the CURRENT graph — the UI
  /// shows a "legacy, approximate" badge and trusts the timeline over it.
  final bool approximate;
}

/// Registry unreachable / version unknown: the view falls back to the
/// TIMELINE-ONLY rendering — the audited run history is authoritative anyway.
class GraphUnavailableException implements Exception {
  const GraphUnavailableException(this.message);

  final String message;

  @override
  String toString() => 'GraphUnavailableException: $message';
}

abstract interface class GraphRepository {
  Future<PinnedGraph> graphFor(String journeyKey, int version);
}

class HttpGraphRepository implements GraphRepository {
  HttpGraphRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;
  final _serializer = const ConfigSerializer();

  /// key@version -> parsed Dag. ONLY successful PINNED fetches enter (they are
  /// immutable); failures and v0 current-graph reads never do.
  final Map<String, Dag> _immutableCache = {};

  @override
  Future<PinnedGraph> graphFor(String journeyKey, int version) async {
    if (version <= 0) {
      return PinnedGraph(dag: await _currentGraph(journeyKey), approximate: true);
    }
    final cacheKey = '$journeyKey@$version';
    final cached = _immutableCache[cacheKey];
    if (cached != null) {
      return PinnedGraph(dag: cached, approximate: false);
    }
    final dag = await _pinnedGraph(journeyKey, version);
    _immutableCache[cacheKey] = dag;
    return PinnedGraph(dag: dag, approximate: false);
  }

  Future<Dag> _pinnedGraph(String journeyKey, int version) async {
    final data = await _get(
        '/api/v1/published-journeys/$journeyKey/versions/$version');
    return _parseConfig(data);
  }

  Future<Dag> _currentGraph(String journeyKey) async {
    final data = await _get('/api/v1/published-journeys');
    for (final entry in data as List<dynamic>) {
      final map = entry as Map<String, dynamic>;
      if (map['journeyKey'] == journeyKey) {
        return _parseConfig(map);
      }
    }
    throw GraphUnavailableException(
        'no currently-published config for "$journeyKey"');
  }

  Dag _parseConfig(dynamic data) {
    try {
      final config = (data as Map<String, dynamic>)['config'];
      return _serializer.fromJson(config as Map<String, dynamic>);
    } catch (e) {
      throw GraphUnavailableException('unparseable registry config: $e');
    }
  }

  Future<dynamic> _get(String path) async {
    try {
      final res = await _dio.get<dynamic>(path);
      return res.data;
    } on DioException catch (e) {
      throw GraphUnavailableException(
          'registry unreachable (${e.response?.statusCode ?? e.type.name})');
    }
  }
}

/// Mock-mode graphs: v1 is the canonical loan journey; v2 the same journey
/// with a channel-notify hop added after booking (a realistic re-publish).
/// The v0 "current" graph is v2, served as approximate.
class MockGraphRepository implements GraphRepository {
  @override
  Future<PinnedGraph> graphFor(String journeyKey, int version) async {
    if (journeyKey != 'loan-origination') {
      throw GraphUnavailableException('mock has no graphs for "$journeyKey"');
    }
    if (version == 1) {
      return PinnedGraph(dag: seedLoanDag(), approximate: false);
    }
    // v2 and the legacy-v0 "current" graph.
    return PinnedGraph(dag: mockLoanDagV2(), approximate: version <= 0);
  }
}

/// loan-origination v2: v1 plus an explicit channel-notify task after booking.
Dag mockLoanDagV2() {
  final v1 = seedLoanDag();
  final nodes = <DagNode>[];
  for (final n in v1.nodes) {
    if (n is TaskNode && n.id == 'n_book') {
      nodes.add(n.copyWith(next: ['n_notify']));
    } else {
      nodes.add(n);
    }
  }
  nodes.add(const DagNode.task(
    id: 'n_notify',
    capability: 'lending-origination',
    operation: 'notifyChannel',
    next: ['n_done'],
  ));
  return v1.copyWith(
    nodes: nodes,
    layout: {
      ...v1.layout,
      'n_notify': const NodeLayout(x: 1160, y: 40),
      'n_done': const NodeLayout(x: 1340, y: 120),
    },
  );
}
