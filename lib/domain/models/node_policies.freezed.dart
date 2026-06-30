// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_policies.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BackoffSpec {
  String get type => throw _privateConstructorUsedError;
  String get base => throw _privateConstructorUsedError; // duration, e.g. "2s"
  String get max => throw _privateConstructorUsedError;

  /// Create a copy of BackoffSpec
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackoffSpecCopyWith<BackoffSpec> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackoffSpecCopyWith<$Res> {
  factory $BackoffSpecCopyWith(
          BackoffSpec value, $Res Function(BackoffSpec) then) =
      _$BackoffSpecCopyWithImpl<$Res, BackoffSpec>;
  @useResult
  $Res call({String type, String base, String max});
}

/// @nodoc
class _$BackoffSpecCopyWithImpl<$Res, $Val extends BackoffSpec>
    implements $BackoffSpecCopyWith<$Res> {
  _$BackoffSpecCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackoffSpec
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? base = null,
    Object? max = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      base: null == base
          ? _value.base
          : base // ignore: cast_nullable_to_non_nullable
              as String,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackoffSpecImplCopyWith<$Res>
    implements $BackoffSpecCopyWith<$Res> {
  factory _$$BackoffSpecImplCopyWith(
          _$BackoffSpecImpl value, $Res Function(_$BackoffSpecImpl) then) =
      __$$BackoffSpecImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String base, String max});
}

/// @nodoc
class __$$BackoffSpecImplCopyWithImpl<$Res>
    extends _$BackoffSpecCopyWithImpl<$Res, _$BackoffSpecImpl>
    implements _$$BackoffSpecImplCopyWith<$Res> {
  __$$BackoffSpecImplCopyWithImpl(
      _$BackoffSpecImpl _value, $Res Function(_$BackoffSpecImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackoffSpec
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? base = null,
    Object? max = null,
  }) {
    return _then(_$BackoffSpecImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      base: null == base
          ? _value.base
          : base // ignore: cast_nullable_to_non_nullable
              as String,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BackoffSpecImpl implements _BackoffSpec {
  const _$BackoffSpecImpl(
      {this.type = 'exponential', required this.base, required this.max});

  @override
  @JsonKey()
  final String type;
  @override
  final String base;
// duration, e.g. "2s"
  @override
  final String max;

  @override
  String toString() {
    return 'BackoffSpec(type: $type, base: $base, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackoffSpecImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.max, max) || other.max == max));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, base, max);

  /// Create a copy of BackoffSpec
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackoffSpecImplCopyWith<_$BackoffSpecImpl> get copyWith =>
      __$$BackoffSpecImplCopyWithImpl<_$BackoffSpecImpl>(this, _$identity);
}

abstract class _BackoffSpec implements BackoffSpec {
  const factory _BackoffSpec(
      {final String type,
      required final String base,
      required final String max}) = _$BackoffSpecImpl;

  @override
  String get type;
  @override
  String get base; // duration, e.g. "2s"
  @override
  String get max;

  /// Create a copy of BackoffSpec
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackoffSpecImplCopyWith<_$BackoffSpecImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RetryPolicy {
  int get maxAttempts => throw _privateConstructorUsedError;
  BackoffSpec? get backoff => throw _privateConstructorUsedError;
  bool get jitter => throw _privateConstructorUsedError;

  /// Error classes that are retryable (e.g. ["TRANSIENT"]). Money ops must NOT
  /// retry without an idempotency key (enforced by the capability).
  List<String> get retryOn => throw _privateConstructorUsedError;

  /// Create a copy of RetryPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RetryPolicyCopyWith<RetryPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RetryPolicyCopyWith<$Res> {
  factory $RetryPolicyCopyWith(
          RetryPolicy value, $Res Function(RetryPolicy) then) =
      _$RetryPolicyCopyWithImpl<$Res, RetryPolicy>;
  @useResult
  $Res call(
      {int maxAttempts,
      BackoffSpec? backoff,
      bool jitter,
      List<String> retryOn});

  $BackoffSpecCopyWith<$Res>? get backoff;
}

/// @nodoc
class _$RetryPolicyCopyWithImpl<$Res, $Val extends RetryPolicy>
    implements $RetryPolicyCopyWith<$Res> {
  _$RetryPolicyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RetryPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxAttempts = null,
    Object? backoff = freezed,
    Object? jitter = null,
    Object? retryOn = null,
  }) {
    return _then(_value.copyWith(
      maxAttempts: null == maxAttempts
          ? _value.maxAttempts
          : maxAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      backoff: freezed == backoff
          ? _value.backoff
          : backoff // ignore: cast_nullable_to_non_nullable
              as BackoffSpec?,
      jitter: null == jitter
          ? _value.jitter
          : jitter // ignore: cast_nullable_to_non_nullable
              as bool,
      retryOn: null == retryOn
          ? _value.retryOn
          : retryOn // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of RetryPolicy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BackoffSpecCopyWith<$Res>? get backoff {
    if (_value.backoff == null) {
      return null;
    }

    return $BackoffSpecCopyWith<$Res>(_value.backoff!, (value) {
      return _then(_value.copyWith(backoff: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RetryPolicyImplCopyWith<$Res>
    implements $RetryPolicyCopyWith<$Res> {
  factory _$$RetryPolicyImplCopyWith(
          _$RetryPolicyImpl value, $Res Function(_$RetryPolicyImpl) then) =
      __$$RetryPolicyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int maxAttempts,
      BackoffSpec? backoff,
      bool jitter,
      List<String> retryOn});

  @override
  $BackoffSpecCopyWith<$Res>? get backoff;
}

/// @nodoc
class __$$RetryPolicyImplCopyWithImpl<$Res>
    extends _$RetryPolicyCopyWithImpl<$Res, _$RetryPolicyImpl>
    implements _$$RetryPolicyImplCopyWith<$Res> {
  __$$RetryPolicyImplCopyWithImpl(
      _$RetryPolicyImpl _value, $Res Function(_$RetryPolicyImpl) _then)
      : super(_value, _then);

  /// Create a copy of RetryPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxAttempts = null,
    Object? backoff = freezed,
    Object? jitter = null,
    Object? retryOn = null,
  }) {
    return _then(_$RetryPolicyImpl(
      maxAttempts: null == maxAttempts
          ? _value.maxAttempts
          : maxAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      backoff: freezed == backoff
          ? _value.backoff
          : backoff // ignore: cast_nullable_to_non_nullable
              as BackoffSpec?,
      jitter: null == jitter
          ? _value.jitter
          : jitter // ignore: cast_nullable_to_non_nullable
              as bool,
      retryOn: null == retryOn
          ? _value._retryOn
          : retryOn // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$RetryPolicyImpl implements _RetryPolicy {
  const _$RetryPolicyImpl(
      {required this.maxAttempts,
      this.backoff,
      this.jitter = false,
      final List<String> retryOn = const <String>[]})
      : _retryOn = retryOn;

  @override
  final int maxAttempts;
  @override
  final BackoffSpec? backoff;
  @override
  @JsonKey()
  final bool jitter;

  /// Error classes that are retryable (e.g. ["TRANSIENT"]). Money ops must NOT
  /// retry without an idempotency key (enforced by the capability).
  final List<String> _retryOn;

  /// Error classes that are retryable (e.g. ["TRANSIENT"]). Money ops must NOT
  /// retry without an idempotency key (enforced by the capability).
  @override
  @JsonKey()
  List<String> get retryOn {
    if (_retryOn is EqualUnmodifiableListView) return _retryOn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_retryOn);
  }

  @override
  String toString() {
    return 'RetryPolicy(maxAttempts: $maxAttempts, backoff: $backoff, jitter: $jitter, retryOn: $retryOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetryPolicyImpl &&
            (identical(other.maxAttempts, maxAttempts) ||
                other.maxAttempts == maxAttempts) &&
            (identical(other.backoff, backoff) || other.backoff == backoff) &&
            (identical(other.jitter, jitter) || other.jitter == jitter) &&
            const DeepCollectionEquality().equals(other._retryOn, _retryOn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, maxAttempts, backoff, jitter,
      const DeepCollectionEquality().hash(_retryOn));

  /// Create a copy of RetryPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetryPolicyImplCopyWith<_$RetryPolicyImpl> get copyWith =>
      __$$RetryPolicyImplCopyWithImpl<_$RetryPolicyImpl>(this, _$identity);
}

abstract class _RetryPolicy implements RetryPolicy {
  const factory _RetryPolicy(
      {required final int maxAttempts,
      final BackoffSpec? backoff,
      final bool jitter,
      final List<String> retryOn}) = _$RetryPolicyImpl;

  @override
  int get maxAttempts;
  @override
  BackoffSpec? get backoff;
  @override
  bool get jitter;

  /// Error classes that are retryable (e.g. ["TRANSIENT"]). Money ops must NOT
  /// retry without an idempotency key (enforced by the capability).
  @override
  List<String> get retryOn;

  /// Create a copy of RetryPolicy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetryPolicyImplCopyWith<_$RetryPolicyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TimeoutPolicy {
  String get duration => throw _privateConstructorUsedError;

  /// Create a copy of TimeoutPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeoutPolicyCopyWith<TimeoutPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeoutPolicyCopyWith<$Res> {
  factory $TimeoutPolicyCopyWith(
          TimeoutPolicy value, $Res Function(TimeoutPolicy) then) =
      _$TimeoutPolicyCopyWithImpl<$Res, TimeoutPolicy>;
  @useResult
  $Res call({String duration});
}

/// @nodoc
class _$TimeoutPolicyCopyWithImpl<$Res, $Val extends TimeoutPolicy>
    implements $TimeoutPolicyCopyWith<$Res> {
  _$TimeoutPolicyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeoutPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeoutPolicyImplCopyWith<$Res>
    implements $TimeoutPolicyCopyWith<$Res> {
  factory _$$TimeoutPolicyImplCopyWith(
          _$TimeoutPolicyImpl value, $Res Function(_$TimeoutPolicyImpl) then) =
      __$$TimeoutPolicyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String duration});
}

/// @nodoc
class __$$TimeoutPolicyImplCopyWithImpl<$Res>
    extends _$TimeoutPolicyCopyWithImpl<$Res, _$TimeoutPolicyImpl>
    implements _$$TimeoutPolicyImplCopyWith<$Res> {
  __$$TimeoutPolicyImplCopyWithImpl(
      _$TimeoutPolicyImpl _value, $Res Function(_$TimeoutPolicyImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeoutPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
  }) {
    return _then(_$TimeoutPolicyImpl(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TimeoutPolicyImpl implements _TimeoutPolicy {
  const _$TimeoutPolicyImpl({required this.duration});

  @override
  final String duration;

  @override
  String toString() {
    return 'TimeoutPolicy(duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeoutPolicyImpl &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration);

  /// Create a copy of TimeoutPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeoutPolicyImplCopyWith<_$TimeoutPolicyImpl> get copyWith =>
      __$$TimeoutPolicyImplCopyWithImpl<_$TimeoutPolicyImpl>(this, _$identity);
}

abstract class _TimeoutPolicy implements TimeoutPolicy {
  const factory _TimeoutPolicy({required final String duration}) =
      _$TimeoutPolicyImpl;

  @override
  String get duration;

  /// Create a copy of TimeoutPolicy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeoutPolicyImplCopyWith<_$TimeoutPolicyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CircuitBreakerPolicy {
  double get failureThreshold => throw _privateConstructorUsedError; // 0..1
  String get openDuration => throw _privateConstructorUsedError; // e.g. "60s"
  int? get halfOpenTrial => throw _privateConstructorUsedError;

  /// Create a copy of CircuitBreakerPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CircuitBreakerPolicyCopyWith<CircuitBreakerPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CircuitBreakerPolicyCopyWith<$Res> {
  factory $CircuitBreakerPolicyCopyWith(CircuitBreakerPolicy value,
          $Res Function(CircuitBreakerPolicy) then) =
      _$CircuitBreakerPolicyCopyWithImpl<$Res, CircuitBreakerPolicy>;
  @useResult
  $Res call({double failureThreshold, String openDuration, int? halfOpenTrial});
}

/// @nodoc
class _$CircuitBreakerPolicyCopyWithImpl<$Res,
        $Val extends CircuitBreakerPolicy>
    implements $CircuitBreakerPolicyCopyWith<$Res> {
  _$CircuitBreakerPolicyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CircuitBreakerPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failureThreshold = null,
    Object? openDuration = null,
    Object? halfOpenTrial = freezed,
  }) {
    return _then(_value.copyWith(
      failureThreshold: null == failureThreshold
          ? _value.failureThreshold
          : failureThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      openDuration: null == openDuration
          ? _value.openDuration
          : openDuration // ignore: cast_nullable_to_non_nullable
              as String,
      halfOpenTrial: freezed == halfOpenTrial
          ? _value.halfOpenTrial
          : halfOpenTrial // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CircuitBreakerPolicyImplCopyWith<$Res>
    implements $CircuitBreakerPolicyCopyWith<$Res> {
  factory _$$CircuitBreakerPolicyImplCopyWith(_$CircuitBreakerPolicyImpl value,
          $Res Function(_$CircuitBreakerPolicyImpl) then) =
      __$$CircuitBreakerPolicyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double failureThreshold, String openDuration, int? halfOpenTrial});
}

/// @nodoc
class __$$CircuitBreakerPolicyImplCopyWithImpl<$Res>
    extends _$CircuitBreakerPolicyCopyWithImpl<$Res, _$CircuitBreakerPolicyImpl>
    implements _$$CircuitBreakerPolicyImplCopyWith<$Res> {
  __$$CircuitBreakerPolicyImplCopyWithImpl(_$CircuitBreakerPolicyImpl _value,
      $Res Function(_$CircuitBreakerPolicyImpl) _then)
      : super(_value, _then);

  /// Create a copy of CircuitBreakerPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failureThreshold = null,
    Object? openDuration = null,
    Object? halfOpenTrial = freezed,
  }) {
    return _then(_$CircuitBreakerPolicyImpl(
      failureThreshold: null == failureThreshold
          ? _value.failureThreshold
          : failureThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      openDuration: null == openDuration
          ? _value.openDuration
          : openDuration // ignore: cast_nullable_to_non_nullable
              as String,
      halfOpenTrial: freezed == halfOpenTrial
          ? _value.halfOpenTrial
          : halfOpenTrial // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$CircuitBreakerPolicyImpl implements _CircuitBreakerPolicy {
  const _$CircuitBreakerPolicyImpl(
      {required this.failureThreshold,
      required this.openDuration,
      this.halfOpenTrial});

  @override
  final double failureThreshold;
// 0..1
  @override
  final String openDuration;
// e.g. "60s"
  @override
  final int? halfOpenTrial;

  @override
  String toString() {
    return 'CircuitBreakerPolicy(failureThreshold: $failureThreshold, openDuration: $openDuration, halfOpenTrial: $halfOpenTrial)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CircuitBreakerPolicyImpl &&
            (identical(other.failureThreshold, failureThreshold) ||
                other.failureThreshold == failureThreshold) &&
            (identical(other.openDuration, openDuration) ||
                other.openDuration == openDuration) &&
            (identical(other.halfOpenTrial, halfOpenTrial) ||
                other.halfOpenTrial == halfOpenTrial));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, failureThreshold, openDuration, halfOpenTrial);

  /// Create a copy of CircuitBreakerPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CircuitBreakerPolicyImplCopyWith<_$CircuitBreakerPolicyImpl>
      get copyWith =>
          __$$CircuitBreakerPolicyImplCopyWithImpl<_$CircuitBreakerPolicyImpl>(
              this, _$identity);
}

abstract class _CircuitBreakerPolicy implements CircuitBreakerPolicy {
  const factory _CircuitBreakerPolicy(
      {required final double failureThreshold,
      required final String openDuration,
      final int? halfOpenTrial}) = _$CircuitBreakerPolicyImpl;

  @override
  double get failureThreshold; // 0..1
  @override
  String get openDuration; // e.g. "60s"
  @override
  int? get halfOpenTrial;

  /// Create a copy of CircuitBreakerPolicy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CircuitBreakerPolicyImplCopyWith<_$CircuitBreakerPolicyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MeterPolicy {
  String get pool =>
      throw _privateConstructorUsedError; // named pool (see Dag.pools)
  int? get maxConcurrent => throw _privateConstructorUsedError;

  /// Create a copy of MeterPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeterPolicyCopyWith<MeterPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeterPolicyCopyWith<$Res> {
  factory $MeterPolicyCopyWith(
          MeterPolicy value, $Res Function(MeterPolicy) then) =
      _$MeterPolicyCopyWithImpl<$Res, MeterPolicy>;
  @useResult
  $Res call({String pool, int? maxConcurrent});
}

/// @nodoc
class _$MeterPolicyCopyWithImpl<$Res, $Val extends MeterPolicy>
    implements $MeterPolicyCopyWith<$Res> {
  _$MeterPolicyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeterPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pool = null,
    Object? maxConcurrent = freezed,
  }) {
    return _then(_value.copyWith(
      pool: null == pool
          ? _value.pool
          : pool // ignore: cast_nullable_to_non_nullable
              as String,
      maxConcurrent: freezed == maxConcurrent
          ? _value.maxConcurrent
          : maxConcurrent // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeterPolicyImplCopyWith<$Res>
    implements $MeterPolicyCopyWith<$Res> {
  factory _$$MeterPolicyImplCopyWith(
          _$MeterPolicyImpl value, $Res Function(_$MeterPolicyImpl) then) =
      __$$MeterPolicyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pool, int? maxConcurrent});
}

/// @nodoc
class __$$MeterPolicyImplCopyWithImpl<$Res>
    extends _$MeterPolicyCopyWithImpl<$Res, _$MeterPolicyImpl>
    implements _$$MeterPolicyImplCopyWith<$Res> {
  __$$MeterPolicyImplCopyWithImpl(
      _$MeterPolicyImpl _value, $Res Function(_$MeterPolicyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MeterPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pool = null,
    Object? maxConcurrent = freezed,
  }) {
    return _then(_$MeterPolicyImpl(
      pool: null == pool
          ? _value.pool
          : pool // ignore: cast_nullable_to_non_nullable
              as String,
      maxConcurrent: freezed == maxConcurrent
          ? _value.maxConcurrent
          : maxConcurrent // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$MeterPolicyImpl implements _MeterPolicy {
  const _$MeterPolicyImpl({required this.pool, this.maxConcurrent});

  @override
  final String pool;
// named pool (see Dag.pools)
  @override
  final int? maxConcurrent;

  @override
  String toString() {
    return 'MeterPolicy(pool: $pool, maxConcurrent: $maxConcurrent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeterPolicyImpl &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.maxConcurrent, maxConcurrent) ||
                other.maxConcurrent == maxConcurrent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pool, maxConcurrent);

  /// Create a copy of MeterPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeterPolicyImplCopyWith<_$MeterPolicyImpl> get copyWith =>
      __$$MeterPolicyImplCopyWithImpl<_$MeterPolicyImpl>(this, _$identity);
}

abstract class _MeterPolicy implements MeterPolicy {
  const factory _MeterPolicy(
      {required final String pool,
      final int? maxConcurrent}) = _$MeterPolicyImpl;

  @override
  String get pool; // named pool (see Dag.pools)
  @override
  int? get maxConcurrent;

  /// Create a copy of MeterPolicy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeterPolicyImplCopyWith<_$MeterPolicyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NodePolicies {
  RetryPolicy? get retry => throw _privateConstructorUsedError;
  TimeoutPolicy? get timeout => throw _privateConstructorUsedError;
  CircuitBreakerPolicy? get circuitBreaker =>
      throw _privateConstructorUsedError;
  MeterPolicy? get meter => throw _privateConstructorUsedError;

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodePoliciesCopyWith<NodePolicies> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodePoliciesCopyWith<$Res> {
  factory $NodePoliciesCopyWith(
          NodePolicies value, $Res Function(NodePolicies) then) =
      _$NodePoliciesCopyWithImpl<$Res, NodePolicies>;
  @useResult
  $Res call(
      {RetryPolicy? retry,
      TimeoutPolicy? timeout,
      CircuitBreakerPolicy? circuitBreaker,
      MeterPolicy? meter});

  $RetryPolicyCopyWith<$Res>? get retry;
  $TimeoutPolicyCopyWith<$Res>? get timeout;
  $CircuitBreakerPolicyCopyWith<$Res>? get circuitBreaker;
  $MeterPolicyCopyWith<$Res>? get meter;
}

/// @nodoc
class _$NodePoliciesCopyWithImpl<$Res, $Val extends NodePolicies>
    implements $NodePoliciesCopyWith<$Res> {
  _$NodePoliciesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retry = freezed,
    Object? timeout = freezed,
    Object? circuitBreaker = freezed,
    Object? meter = freezed,
  }) {
    return _then(_value.copyWith(
      retry: freezed == retry
          ? _value.retry
          : retry // ignore: cast_nullable_to_non_nullable
              as RetryPolicy?,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as TimeoutPolicy?,
      circuitBreaker: freezed == circuitBreaker
          ? _value.circuitBreaker
          : circuitBreaker // ignore: cast_nullable_to_non_nullable
              as CircuitBreakerPolicy?,
      meter: freezed == meter
          ? _value.meter
          : meter // ignore: cast_nullable_to_non_nullable
              as MeterPolicy?,
    ) as $Val);
  }

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RetryPolicyCopyWith<$Res>? get retry {
    if (_value.retry == null) {
      return null;
    }

    return $RetryPolicyCopyWith<$Res>(_value.retry!, (value) {
      return _then(_value.copyWith(retry: value) as $Val);
    });
  }

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeoutPolicyCopyWith<$Res>? get timeout {
    if (_value.timeout == null) {
      return null;
    }

    return $TimeoutPolicyCopyWith<$Res>(_value.timeout!, (value) {
      return _then(_value.copyWith(timeout: value) as $Val);
    });
  }

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CircuitBreakerPolicyCopyWith<$Res>? get circuitBreaker {
    if (_value.circuitBreaker == null) {
      return null;
    }

    return $CircuitBreakerPolicyCopyWith<$Res>(_value.circuitBreaker!, (value) {
      return _then(_value.copyWith(circuitBreaker: value) as $Val);
    });
  }

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MeterPolicyCopyWith<$Res>? get meter {
    if (_value.meter == null) {
      return null;
    }

    return $MeterPolicyCopyWith<$Res>(_value.meter!, (value) {
      return _then(_value.copyWith(meter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NodePoliciesImplCopyWith<$Res>
    implements $NodePoliciesCopyWith<$Res> {
  factory _$$NodePoliciesImplCopyWith(
          _$NodePoliciesImpl value, $Res Function(_$NodePoliciesImpl) then) =
      __$$NodePoliciesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RetryPolicy? retry,
      TimeoutPolicy? timeout,
      CircuitBreakerPolicy? circuitBreaker,
      MeterPolicy? meter});

  @override
  $RetryPolicyCopyWith<$Res>? get retry;
  @override
  $TimeoutPolicyCopyWith<$Res>? get timeout;
  @override
  $CircuitBreakerPolicyCopyWith<$Res>? get circuitBreaker;
  @override
  $MeterPolicyCopyWith<$Res>? get meter;
}

/// @nodoc
class __$$NodePoliciesImplCopyWithImpl<$Res>
    extends _$NodePoliciesCopyWithImpl<$Res, _$NodePoliciesImpl>
    implements _$$NodePoliciesImplCopyWith<$Res> {
  __$$NodePoliciesImplCopyWithImpl(
      _$NodePoliciesImpl _value, $Res Function(_$NodePoliciesImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retry = freezed,
    Object? timeout = freezed,
    Object? circuitBreaker = freezed,
    Object? meter = freezed,
  }) {
    return _then(_$NodePoliciesImpl(
      retry: freezed == retry
          ? _value.retry
          : retry // ignore: cast_nullable_to_non_nullable
              as RetryPolicy?,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as TimeoutPolicy?,
      circuitBreaker: freezed == circuitBreaker
          ? _value.circuitBreaker
          : circuitBreaker // ignore: cast_nullable_to_non_nullable
              as CircuitBreakerPolicy?,
      meter: freezed == meter
          ? _value.meter
          : meter // ignore: cast_nullable_to_non_nullable
              as MeterPolicy?,
    ));
  }
}

/// @nodoc

class _$NodePoliciesImpl extends _NodePolicies {
  const _$NodePoliciesImpl(
      {this.retry, this.timeout, this.circuitBreaker, this.meter})
      : super._();

  @override
  final RetryPolicy? retry;
  @override
  final TimeoutPolicy? timeout;
  @override
  final CircuitBreakerPolicy? circuitBreaker;
  @override
  final MeterPolicy? meter;

  @override
  String toString() {
    return 'NodePolicies(retry: $retry, timeout: $timeout, circuitBreaker: $circuitBreaker, meter: $meter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodePoliciesImpl &&
            (identical(other.retry, retry) || other.retry == retry) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.circuitBreaker, circuitBreaker) ||
                other.circuitBreaker == circuitBreaker) &&
            (identical(other.meter, meter) || other.meter == meter));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, retry, timeout, circuitBreaker, meter);

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodePoliciesImplCopyWith<_$NodePoliciesImpl> get copyWith =>
      __$$NodePoliciesImplCopyWithImpl<_$NodePoliciesImpl>(this, _$identity);
}

abstract class _NodePolicies extends NodePolicies {
  const factory _NodePolicies(
      {final RetryPolicy? retry,
      final TimeoutPolicy? timeout,
      final CircuitBreakerPolicy? circuitBreaker,
      final MeterPolicy? meter}) = _$NodePoliciesImpl;
  const _NodePolicies._() : super._();

  @override
  RetryPolicy? get retry;
  @override
  TimeoutPolicy? get timeout;
  @override
  CircuitBreakerPolicy? get circuitBreaker;
  @override
  MeterPolicy? get meter;

  /// Create a copy of NodePolicies
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodePoliciesImplCopyWith<_$NodePoliciesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Compensation {
  String get operation => throw _privateConstructorUsedError;
  String? get input => throw _privateConstructorUsedError;

  /// Create a copy of Compensation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompensationCopyWith<Compensation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompensationCopyWith<$Res> {
  factory $CompensationCopyWith(
          Compensation value, $Res Function(Compensation) then) =
      _$CompensationCopyWithImpl<$Res, Compensation>;
  @useResult
  $Res call({String operation, String? input});
}

/// @nodoc
class _$CompensationCopyWithImpl<$Res, $Val extends Compensation>
    implements $CompensationCopyWith<$Res> {
  _$CompensationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Compensation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operation = null,
    Object? input = freezed,
  }) {
    return _then(_value.copyWith(
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      input: freezed == input
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompensationImplCopyWith<$Res>
    implements $CompensationCopyWith<$Res> {
  factory _$$CompensationImplCopyWith(
          _$CompensationImpl value, $Res Function(_$CompensationImpl) then) =
      __$$CompensationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String operation, String? input});
}

/// @nodoc
class __$$CompensationImplCopyWithImpl<$Res>
    extends _$CompensationCopyWithImpl<$Res, _$CompensationImpl>
    implements _$$CompensationImplCopyWith<$Res> {
  __$$CompensationImplCopyWithImpl(
      _$CompensationImpl _value, $Res Function(_$CompensationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Compensation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operation = null,
    Object? input = freezed,
  }) {
    return _then(_$CompensationImpl(
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      input: freezed == input
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CompensationImpl implements _Compensation {
  const _$CompensationImpl({required this.operation, this.input});

  @override
  final String operation;
  @override
  final String? input;

  @override
  String toString() {
    return 'Compensation(operation: $operation, input: $input)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompensationImpl &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.input, input) || other.input == input));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operation, input);

  /// Create a copy of Compensation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompensationImplCopyWith<_$CompensationImpl> get copyWith =>
      __$$CompensationImplCopyWithImpl<_$CompensationImpl>(this, _$identity);
}

abstract class _Compensation implements Compensation {
  const factory _Compensation(
      {required final String operation,
      final String? input}) = _$CompensationImpl;

  @override
  String get operation;
  @override
  String? get input;

  /// Create a copy of Compensation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompensationImplCopyWith<_$CompensationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PoolSpec {
  int get maxConcurrent => throw _privateConstructorUsedError;

  /// Create a copy of PoolSpec
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolSpecCopyWith<PoolSpec> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolSpecCopyWith<$Res> {
  factory $PoolSpecCopyWith(PoolSpec value, $Res Function(PoolSpec) then) =
      _$PoolSpecCopyWithImpl<$Res, PoolSpec>;
  @useResult
  $Res call({int maxConcurrent});
}

/// @nodoc
class _$PoolSpecCopyWithImpl<$Res, $Val extends PoolSpec>
    implements $PoolSpecCopyWith<$Res> {
  _$PoolSpecCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolSpec
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxConcurrent = null,
  }) {
    return _then(_value.copyWith(
      maxConcurrent: null == maxConcurrent
          ? _value.maxConcurrent
          : maxConcurrent // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PoolSpecImplCopyWith<$Res>
    implements $PoolSpecCopyWith<$Res> {
  factory _$$PoolSpecImplCopyWith(
          _$PoolSpecImpl value, $Res Function(_$PoolSpecImpl) then) =
      __$$PoolSpecImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int maxConcurrent});
}

/// @nodoc
class __$$PoolSpecImplCopyWithImpl<$Res>
    extends _$PoolSpecCopyWithImpl<$Res, _$PoolSpecImpl>
    implements _$$PoolSpecImplCopyWith<$Res> {
  __$$PoolSpecImplCopyWithImpl(
      _$PoolSpecImpl _value, $Res Function(_$PoolSpecImpl) _then)
      : super(_value, _then);

  /// Create a copy of PoolSpec
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxConcurrent = null,
  }) {
    return _then(_$PoolSpecImpl(
      maxConcurrent: null == maxConcurrent
          ? _value.maxConcurrent
          : maxConcurrent // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PoolSpecImpl implements _PoolSpec {
  const _$PoolSpecImpl({required this.maxConcurrent});

  @override
  final int maxConcurrent;

  @override
  String toString() {
    return 'PoolSpec(maxConcurrent: $maxConcurrent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolSpecImpl &&
            (identical(other.maxConcurrent, maxConcurrent) ||
                other.maxConcurrent == maxConcurrent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, maxConcurrent);

  /// Create a copy of PoolSpec
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolSpecImplCopyWith<_$PoolSpecImpl> get copyWith =>
      __$$PoolSpecImplCopyWithImpl<_$PoolSpecImpl>(this, _$identity);
}

abstract class _PoolSpec implements PoolSpec {
  const factory _PoolSpec({required final int maxConcurrent}) = _$PoolSpecImpl;

  @override
  int get maxConcurrent;

  /// Create a copy of PoolSpec
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolSpecImplCopyWith<_$PoolSpecImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
