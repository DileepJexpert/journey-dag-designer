/// Domain-facing failure type (build doc §4 core/error). Network/transport
/// errors are mapped into these by the dio error interceptor so the UI never
/// sees a raw DioException. The variants mirror the registry's RegistryException
/// kinds 1:1 (401/403/404/409/422) — transport stays a mapping, business
/// meaning survives it.
library;

import '../../domain/models/validation.dart';

sealed class Failure implements Exception {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// 401 — missing/invalid service token or missing actor identity (X-User-Id).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired']);
}

/// 403 — maker-checker: the author may not approve/reject their own version.
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'Not permitted']);
}

/// 404 — no such journey/version (or never published).
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

/// 409 — lifecycle conflict: second editable draft, wrong status for the
/// action, or a concurrent checker won the race.
class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'Conflicting change']);
}

/// 422 — the §7 graph failed the AUTHORITATIVE server validation. [issues]
/// carries the designer-vocabulary findings so the validation panel renders
/// them directly (jump-to-node included), never a generic toast.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.issues = const <ValidationIssue>[]});
  final List<ValidationIssue> issues;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;
}
