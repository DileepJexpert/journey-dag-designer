/// Dio adapter for the DIGITAL EDGE's sync-invocation audit surface (:8081). Same
/// fail-closed auth as the journey ops API — X-Ops-Token + X-User-Id on every
/// request — but a different host, because the sync lane runs on the edge, not the
/// engine.
library;

import 'package:dio/dio.dart';

import '../domain/sync_invocation.dart';
import 'ops_api.dart' show OpsApiException;
import 'sync_ops_api.dart';

class HttpSyncOpsApi implements SyncOpsApi {
  HttpSyncOpsApi({
    required String baseUrl,
    required String opsToken,
    required String Function() actorId,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 5)
      ..receiveTimeout = const Duration(seconds: 10)
      ..responseType = ResponseType.json;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['X-Ops-Token'] = opsToken;
        options.headers['X-User-Id'] = actorId();
        handler.next(options);
      },
    ));
  }

  final Dio _dio;

  @override
  Future<SyncInvocationsPage> invocations({
    String? capability,
    String? source,
    SyncOutcome? outcome,
    int page = 0,
    int size = 50,
  }) async {
    final res = await _get('/ops/sync-invocations', query: {
      if (capability != null && capability.isNotEmpty) 'capability': capability,
      if (source != null && source.isNotEmpty) 'source': source,
      if (outcome != null) 'outcome': outcome.wire,
      'page': '$page',
      'size': '$size',
    });
    return SyncInvocationsPage.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<SyncInvocation>> byKey(String idempotencyKey) async {
    final res = await _get('/ops/sync-invocations/by-key/$idempotencyKey');
    return (res.data as List<dynamic>)
        .map((e) => SyncInvocation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Response<dynamic>> _get(String path,
      {Map<String, String>? query}) async {
    try {
      return await _dio.get<dynamic>(path, queryParameters: query);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final body = e.response?.data;
      final message = body is Map && body['message'] != null
          ? body['message'] as String
          : e.message ?? 'sync-ops API unreachable';
      throw OpsApiException(message, statusCode: code);
    }
  }
}
