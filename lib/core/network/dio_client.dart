/// Configured dio instance for the journey-registry API (build doc §3, §4).
/// Every request carries the SERVICE token (X-Registry-Token, from Env) and the
/// REAL actor identity (X-User-Id, from the auth session) — the server enforces
/// maker-checker on that identity; nothing here can bypass it. Identity is
/// asserted-not-authenticated until the SSO production gate lands (tracked in
/// the platform README).
library;

import 'package:dio/dio.dart';

import '../config/env.dart';

class RegistryHeaders {
  const RegistryHeaders._();

  static const String token = 'X-Registry-Token';
  static const String actor = 'X-User-Id';
}

Dio buildDio({
  required String Function() actorId,
  String? baseUrl,
  String? registryToken,
}) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl ?? Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    contentType: 'application/json',
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers[RegistryHeaders.token] = registryToken ?? Env.registryToken;
      final actor = actorId();
      if (actor.isNotEmpty) {
        // No fallback identity: an empty actor is OMITTED and the registry
        // 401s the mutation — fail closed on the server, not papered-over here.
        options.headers[RegistryHeaders.actor] = actor;
      }
      handler.next(options);
    },
  ));

  return dio;
}
