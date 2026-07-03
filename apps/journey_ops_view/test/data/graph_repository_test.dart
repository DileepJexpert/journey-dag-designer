/// PINNED-GRAPH rules (spec C.2/D + A2): a run renders ITS version's graph —
/// v1 runs get v1 even when v2 is current; published versions are immutable so
/// pinned fetches cache forever; failures are never cached; legacy v0 rides
/// the CURRENT graph, marked approximate and never cached.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:dag_core/dag_core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/data/graph_repository.dart';

const _serializer = ConfigSerializer();

/// Fake HTTP layer: routes registry paths to canned JSON, counts hits per
/// path, and can be told to fail everything (registry down).
class _FakeRegistryAdapter implements HttpClientAdapter {
  _FakeRegistryAdapter();

  final Map<String, int> hits = {};
  bool down = false;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final path = options.uri.path;
    hits[path] = (hits[path] ?? 0) + 1;
    if (down) {
      throw DioException.connectionError(
          requestOptions: options, reason: 'registry down (test)');
    }
    if (path == '/api/v1/published-journeys/loan-origination/versions/1') {
      return _json({
        'journeyKey': 'loan-origination',
        'version': 1,
        'config': _serializer.toJson(seedLoanDag(),
            key: 'loan-origination', version: 1),
      });
    }
    if (path == '/api/v1/published-journeys/loan-origination/versions/2') {
      return _json({
        'journeyKey': 'loan-origination',
        'version': 2,
        'config': _serializer.toJson(mockLoanDagV2(),
            key: 'loan-origination', version: 2),
      });
    }
    if (path == '/api/v1/published-journeys') {
      // The CURRENT pointer is v2.
      return _json([
        {
          'journeyKey': 'loan-origination',
          'version': 2,
          'config': _serializer.toJson(mockLoanDagV2(),
              key: 'loan-origination', version: 2),
        }
      ]);
    }
    return ResponseBody.fromString('{"error":"NOT_FOUND"}', 404,
        headers: _headers);
  }

  static final _headers = {
    Headers.contentTypeHeader: ['application/json'],
  };

  ResponseBody _json(Object body) =>
      ResponseBody.fromString(jsonEncode(body), 200, headers: _headers);

  @override
  void close({bool force = false}) {}
}

void main() {
  late _FakeRegistryAdapter adapter;
  late HttpGraphRepository repo;

  setUp(() {
    adapter = _FakeRegistryAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://registry.test'));
    dio.httpClientAdapter = adapter;
    repo = HttpGraphRepository(dio: dio);
  });

  test('PINNED v1 vs v2: each version fetch returns ITS OWN graph — a v1 run '
      'renders v1 even though v2 exists and is current', () async {
    final v1 = await repo.graphFor('loan-origination', 1);
    final v2 = await repo.graphFor('loan-origination', 2);

    expect(v1.approximate, isFalse);
    expect(v1.dag.nodeOrNull('n_notify'), isNull,
        reason: 'v1 predates the notify hop');
    expect(v2.dag.nodeOrNull('n_notify'), isNotNull,
        reason: 'v2 added the notify hop');
    expect(v2.approximate, isFalse);
  });

  test('published versions are IMMUTABLE: a pinned fetch is cached forever '
      '(second read never hits the registry)', () async {
    await repo.graphFor('loan-origination', 1);
    await repo.graphFor('loan-origination', 1);
    await repo.graphFor('loan-origination', 1);
    expect(
        adapter
            .hits['/api/v1/published-journeys/loan-origination/versions/1'],
        1);
  });

  test('registry down -> GraphUnavailableException; the failure is NOT '
      'cached, so recovery works on the next fetch', () async {
    adapter.down = true;
    await expectLater(repo.graphFor('loan-origination', 1),
        throwsA(isA<GraphUnavailableException>()));

    adapter.down = false;
    final recovered = await repo.graphFor('loan-origination', 1);
    expect(recovered.dag.nodeOrNull('n_customer'), isNotNull);
  });

  test('unknown version (never published) -> GraphUnavailableException', () async {
    await expectLater(repo.graphFor('loan-origination', 99),
        throwsA(isA<GraphUnavailableException>()));
  });

  test('legacy v0 -> CURRENT graph marked approximate, and NEVER enters the '
      'immutable cache (current moves; v0 re-reads every time)', () async {
    final legacy = await repo.graphFor('loan-origination', 0);
    expect(legacy.approximate, isTrue);
    expect(legacy.dag.nodeOrNull('n_notify'), isNotNull,
        reason: 'current graph is v2');

    await repo.graphFor('loan-origination', 0);
    expect(adapter.hits['/api/v1/published-journeys'], 2,
        reason: 'v0 must not be served from the immutable cache');
  });
}
