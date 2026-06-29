// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ValidationIssue {
  ValidationCode get code => throw _privateConstructorUsedError;
  ValidationSeverity get severity => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// The node the issue is attached to, if any (drives the red ring in UI).
  String? get nodeId => throw _privateConstructorUsedError;

  /// Create a copy of ValidationIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidationIssueCopyWith<ValidationIssue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationIssueCopyWith<$Res> {
  factory $ValidationIssueCopyWith(
          ValidationIssue value, $Res Function(ValidationIssue) then) =
      _$ValidationIssueCopyWithImpl<$Res, ValidationIssue>;
  @useResult
  $Res call(
      {ValidationCode code,
      ValidationSeverity severity,
      String message,
      String? nodeId});
}

/// @nodoc
class _$ValidationIssueCopyWithImpl<$Res, $Val extends ValidationIssue>
    implements $ValidationIssueCopyWith<$Res> {
  _$ValidationIssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidationIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? severity = null,
    Object? message = null,
    Object? nodeId = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as ValidationCode,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ValidationSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      nodeId: freezed == nodeId
          ? _value.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationIssueImplCopyWith<$Res>
    implements $ValidationIssueCopyWith<$Res> {
  factory _$$ValidationIssueImplCopyWith(_$ValidationIssueImpl value,
          $Res Function(_$ValidationIssueImpl) then) =
      __$$ValidationIssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ValidationCode code,
      ValidationSeverity severity,
      String message,
      String? nodeId});
}

/// @nodoc
class __$$ValidationIssueImplCopyWithImpl<$Res>
    extends _$ValidationIssueCopyWithImpl<$Res, _$ValidationIssueImpl>
    implements _$$ValidationIssueImplCopyWith<$Res> {
  __$$ValidationIssueImplCopyWithImpl(
      _$ValidationIssueImpl _value, $Res Function(_$ValidationIssueImpl) _then)
      : super(_value, _then);

  /// Create a copy of ValidationIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? severity = null,
    Object? message = null,
    Object? nodeId = freezed,
  }) {
    return _then(_$ValidationIssueImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as ValidationCode,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ValidationSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      nodeId: freezed == nodeId
          ? _value.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ValidationIssueImpl implements _ValidationIssue {
  const _$ValidationIssueImpl(
      {required this.code,
      required this.severity,
      required this.message,
      this.nodeId});

  @override
  final ValidationCode code;
  @override
  final ValidationSeverity severity;
  @override
  final String message;

  /// The node the issue is attached to, if any (drives the red ring in UI).
  @override
  final String? nodeId;

  @override
  String toString() {
    return 'ValidationIssue(code: $code, severity: $severity, message: $message, nodeId: $nodeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationIssueImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, severity, message, nodeId);

  /// Create a copy of ValidationIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationIssueImplCopyWith<_$ValidationIssueImpl> get copyWith =>
      __$$ValidationIssueImplCopyWithImpl<_$ValidationIssueImpl>(
          this, _$identity);
}

abstract class _ValidationIssue implements ValidationIssue {
  const factory _ValidationIssue(
      {required final ValidationCode code,
      required final ValidationSeverity severity,
      required final String message,
      final String? nodeId}) = _$ValidationIssueImpl;

  @override
  ValidationCode get code;
  @override
  ValidationSeverity get severity;
  @override
  String get message;

  /// The node the issue is attached to, if any (drives the red ring in UI).
  @override
  String? get nodeId;

  /// Create a copy of ValidationIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationIssueImplCopyWith<_$ValidationIssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ValidationResult {
  List<ValidationIssue> get issues => throw _privateConstructorUsedError;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidationResultCopyWith<ValidationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationResultCopyWith<$Res> {
  factory $ValidationResultCopyWith(
          ValidationResult value, $Res Function(ValidationResult) then) =
      _$ValidationResultCopyWithImpl<$Res, ValidationResult>;
  @useResult
  $Res call({List<ValidationIssue> issues});
}

/// @nodoc
class _$ValidationResultCopyWithImpl<$Res, $Val extends ValidationResult>
    implements $ValidationResultCopyWith<$Res> {
  _$ValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? issues = null,
  }) {
    return _then(_value.copyWith(
      issues: null == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<ValidationIssue>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationResultImplCopyWith<$Res>
    implements $ValidationResultCopyWith<$Res> {
  factory _$$ValidationResultImplCopyWith(_$ValidationResultImpl value,
          $Res Function(_$ValidationResultImpl) then) =
      __$$ValidationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ValidationIssue> issues});
}

/// @nodoc
class __$$ValidationResultImplCopyWithImpl<$Res>
    extends _$ValidationResultCopyWithImpl<$Res, _$ValidationResultImpl>
    implements _$$ValidationResultImplCopyWith<$Res> {
  __$$ValidationResultImplCopyWithImpl(_$ValidationResultImpl _value,
      $Res Function(_$ValidationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? issues = null,
  }) {
    return _then(_$ValidationResultImpl(
      issues: null == issues
          ? _value._issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<ValidationIssue>,
    ));
  }
}

/// @nodoc

class _$ValidationResultImpl extends _ValidationResult {
  const _$ValidationResultImpl(
      {final List<ValidationIssue> issues = const <ValidationIssue>[]})
      : _issues = issues,
        super._();

  final List<ValidationIssue> _issues;
  @override
  @JsonKey()
  List<ValidationIssue> get issues {
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_issues);
  }

  @override
  String toString() {
    return 'ValidationResult(issues: $issues)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationResultImpl &&
            const DeepCollectionEquality().equals(other._issues, _issues));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_issues));

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationResultImplCopyWith<_$ValidationResultImpl> get copyWith =>
      __$$ValidationResultImplCopyWithImpl<_$ValidationResultImpl>(
          this, _$identity);
}

abstract class _ValidationResult extends ValidationResult {
  const factory _ValidationResult({final List<ValidationIssue> issues}) =
      _$ValidationResultImpl;
  const _ValidationResult._() : super._();

  @override
  List<ValidationIssue> get issues;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationResultImplCopyWith<_$ValidationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
