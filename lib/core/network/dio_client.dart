/// Configured dio instance (build doc §3, §4 network). Adds the bearer token,
/// maps errors to [Failure]s, and triggers logout on 401.
library;

import 'package:dio/dio.dart';

import '../auth/token_store.dart';
import '../config/env.dart';

Dio buildDio({
  required TokenStore tokenStore,
  required Future<void> Function() onUnauthorized,
  String? baseUrl,
}) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl ?? Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    contentType: 'application/json',
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await tokenStore.read();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (e, handler) async {
      if (e.response?.statusCode == 401) {
        await onUnauthorized();
      }
      handler.next(e);
    },
  ));

  return dio;
}
