/// Domain-facing failure type (build doc §4 core/error). Network/transport
/// errors are mapped into these by the dio error interceptor so the UI never
/// sees a raw DioException.
library;

sealed class Failure {
  const Failure(this.message);
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired']);
}

/// Maker == checker (or any other policy rejection): backend returns 403.
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'Not permitted']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;
}
