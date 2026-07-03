/// Configured dio instance for the registry/ops APIs (build doc §3, §4).
/// Every request carries the SERVICE token and the REAL actor identity
/// (X-User-Id, from the auth session) — servers enforce their rules on that
/// identity; nothing here can bypass them. Identity is asserted-not-
/// authenticated until the SSO production gate lands (platform README).
///
/// dag_core is app-agnostic: the HOST app supplies baseUrl + token (each app
/// has its own Env and its own secret — the Designer's registry token and the
/// Ops View's ops token are DIFFERENT credentials by design, D14).
library;

import 'package:dio/dio.dart';

class RegistryHeaders {
  const RegistryHeaders._();

  static const String token = 'X-Registry-Token';
  static const String actor = 'X-User-Id';
}

Dio buildDio({
  required String Function() actorId,
  required String baseUrl,
  required String registryToken,
  String tokenHeader = RegistryHeaders.token,
}) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    contentType: 'application/json',
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers[tokenHeader] = registryToken;
      final actor = actorId();
      if (actor.isNotEmpty) {
        // No fallback identity: an empty actor is OMITTED and the server
        // 401s the call — fail closed on the server, not papered-over here.
        options.headers[RegistryHeaders.actor] = actor;
      }
      handler.next(options);
    },
  ));

  return dio;
}
