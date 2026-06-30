/// Per-node policies (Charter §3) — the cross-cutting, declarative constraints
/// attached to a task: retry, timeout, circuitBreaker, meter. Plus the saga
/// `compensation` operation (§4). These are part of the §7 contract: the
/// Designer authors them, the engine enforces them (tier by tier).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_policies.freezed.dart';

@freezed
class BackoffSpec with _$BackoffSpec {
  const factory BackoffSpec({
    @Default('exponential') String type,
    required String base, // duration, e.g. "2s"
    required String max, // duration, e.g. "30s"
  }) = _BackoffSpec;
}

@freezed
class RetryPolicy with _$RetryPolicy {
  const factory RetryPolicy({
    required int maxAttempts,
    BackoffSpec? backoff,
    @Default(false) bool jitter,

    /// Error classes that are retryable (e.g. ["TRANSIENT"]). Money ops must NOT
    /// retry without an idempotency key (enforced by the capability).
    @Default(<String>[]) List<String> retryOn,
  }) = _RetryPolicy;
}

@freezed
class TimeoutPolicy with _$TimeoutPolicy {
  const factory TimeoutPolicy({
    required String duration, // e.g. "20s"
  }) = _TimeoutPolicy;
}

@freezed
class CircuitBreakerPolicy with _$CircuitBreakerPolicy {
  const factory CircuitBreakerPolicy({
    required double failureThreshold, // 0..1
    required String openDuration, // e.g. "60s"
    int? halfOpenTrial,
  }) = _CircuitBreakerPolicy;
}

@freezed
class MeterPolicy with _$MeterPolicy {
  const factory MeterPolicy({
    required String pool, // named pool (see Dag.pools)
    int? maxConcurrent, // optional inline cap; pool's cap wins if both set
  }) = _MeterPolicy;
}

@freezed
class NodePolicies with _$NodePolicies {
  const NodePolicies._();

  const factory NodePolicies({
    RetryPolicy? retry,
    TimeoutPolicy? timeout,
    CircuitBreakerPolicy? circuitBreaker,
    MeterPolicy? meter,
  }) = _NodePolicies;

  bool get isEmpty =>
      retry == null && timeout == null && circuitBreaker == null && meter == null;
}

/// A registered undo operation on the SAME capability as the task (saga, §4).
@freezed
class Compensation with _$Compensation {
  const factory Compensation({
    required String operation,
    String? input, // expression map
  }) = _Compensation;
}

/// A named backpressure pool (Charter §7 `pools`): caps concurrent executions of
/// every node metered to it, across all instances.
@freezed
class PoolSpec with _$PoolSpec {
  const factory PoolSpec({
    required int maxConcurrent,
  }) = _PoolSpec;
}
