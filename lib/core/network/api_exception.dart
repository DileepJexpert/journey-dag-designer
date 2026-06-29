/// Maps a dio error into a domain [Failure] (build doc §4 network).
library;

import 'package:dio/dio.dart';

import '../error/failure.dart';

Failure mapDioError(DioException e) {
  final status = e.response?.statusCode;
  final serverMsg = _extractMessage(e.response?.data);
  return switch (status) {
    401 => const UnauthorizedFailure(),
    403 => ForbiddenFailure(serverMsg ?? 'Not permitted (maker == checker?)'),
    422 => ValidationFailure(serverMsg ?? 'Validation failed'),
    null => NetworkFailure(serverMsg ?? e.message ?? 'Network error'),
    _ => ServerFailure(serverMsg ?? 'Server error', statusCode: status),
  };
}

String? _extractMessage(dynamic data) {
  if (data is Map && data['message'] is String) return data['message'] as String;
  if (data is String && data.isNotEmpty) return data;
  return null;
}
