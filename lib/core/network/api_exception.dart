/// Maps a dio error into a domain [Failure] (build doc §4 network), following
/// the registry's RegistryException wire contract exactly:
/// `{error, message, issues:[{code,severity,message,nodeId}]}` with
/// 401 (token/actor) / 403 (maker==checker) / 404 / 409 (lifecycle) /
/// 422 (validation — issues populated, designer vocabulary).
library;

import 'package:dio/dio.dart';

import '../../domain/models/validation.dart';
import '../error/failure.dart';

Failure mapDioError(DioException e) {
  final status = e.response?.statusCode;
  final data = e.response?.data;
  final serverMsg = _extractMessage(data);
  return switch (status) {
    401 => UnauthorizedFailure(serverMsg ?? 'Not authenticated'),
    403 => ForbiddenFailure(serverMsg ?? 'Not permitted (maker == checker?)'),
    404 => NotFoundFailure(serverMsg ?? 'Not found'),
    409 => ConflictFailure(serverMsg ?? 'Conflicting change'),
    422 => ValidationFailure(serverMsg ?? 'Validation failed',
        issues: parseWireIssues(data)),
    null => NetworkFailure(serverMsg ?? e.message ?? 'Network error'),
    _ => ServerFailure(serverMsg ?? 'Server error', statusCode: status),
  };
}

/// Parses the registry's ValidationIssue list — LENIENTLY: an unknown `code`
/// becomes [ValidationCode.serverRule] (the finding still renders), a missing
/// list yields empty. Never throws: this runs inside error handling.
List<ValidationIssue> parseWireIssues(dynamic data) {
  if (data is! Map || data['issues'] is! List) return const [];
  final out = <ValidationIssue>[];
  for (final raw in data['issues'] as List) {
    if (raw is! Map) continue;
    out.add(ValidationIssue(
      code: validationCodeFromWire(raw['code'] as String?),
      severity: raw['severity'] == 'warning'
          ? ValidationSeverity.warning
          : ValidationSeverity.error,
      message: (raw['message'] as String?) ?? 'server validation finding',
      nodeId: raw['nodeId'] as String?,
    ));
  }
  return out;
}

String? _extractMessage(dynamic data) {
  if (data is Map && data['message'] is String) return data['message'] as String;
  if (data is String && data.isNotEmpty) return data;
  return null;
}
