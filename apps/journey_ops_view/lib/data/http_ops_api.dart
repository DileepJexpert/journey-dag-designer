/// Dio adapter for the engine's audited ops read window (B.3). Every request
/// carries X-Ops-Token + X-User-Id — the server audit-logs EVERY attempt with
/// the asserted actor. (D14: the ops token is its own secret; the registry
/// token does not authorize this API and vice versa.)
library;

import 'package:dio/dio.dart';

import '../domain/models.dart';
import '../domain/ops_status.dart';
import 'ops_api.dart';

class HttpOpsApi implements OpsApi {
  HttpOpsApi({
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
  Future<RunsPage> runs({
    OpsStatus? status,
    String? journeyKey,
    bool stuckOnly = false,
    int page = 0,
    int size = 50,
  }) async {
    final res = await _get('/ops/runs', query: {
      if (status != null) 'status': status.wire,
      if (journeyKey != null && journeyKey.isNotEmpty) 'journeyKey': journeyKey,
      if (stuckOnly) 'stuckOnly': 'true',
      'page': '$page',
      'size': '$size',
    });
    return RunsPage.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<RunSummary>> search(String key) async {
    final res = await _get('/ops/runs/search', query: {'key': key});
    return (res.data as List<dynamic>)
        .map((r) => RunSummary.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RunDetail?> detail(String runId) async {
    try {
      final res = await _get('/ops/runs/$runId');
      return RunDetail.fromJson(res.data as Map<String, dynamic>);
    } on OpsApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    }
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
          : e.message ?? 'ops API unreachable';
      throw OpsApiException(message, statusCode: code);
    }
  }
}
