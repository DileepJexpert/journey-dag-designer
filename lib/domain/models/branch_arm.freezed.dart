// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_arm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BranchArm {
  /// Expression over `context`, e.g. `context.decision.approved == true`.
  String get when => throw _privateConstructorUsedError;
  String get next => throw _privateConstructorUsedError;

  /// Create a copy of BranchArm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchArmCopyWith<BranchArm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchArmCopyWith<$Res> {
  factory $BranchArmCopyWith(BranchArm value, $Res Function(BranchArm) then) =
      _$BranchArmCopyWithImpl<$Res, BranchArm>;
  @useResult
  $Res call({String when, String next});
}

/// @nodoc
class _$BranchArmCopyWithImpl<$Res, $Val extends BranchArm>
    implements $BranchArmCopyWith<$Res> {
  _$BranchArmCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BranchArm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? when = null,
    Object? next = null,
  }) {
    return _then(_value.copyWith(
      when: null == when
          ? _value.when
          : when // ignore: cast_nullable_to_non_nullable
              as String,
      next: null == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BranchArmImplCopyWith<$Res>
    implements $BranchArmCopyWith<$Res> {
  factory _$$BranchArmImplCopyWith(
          _$BranchArmImpl value, $Res Function(_$BranchArmImpl) then) =
      __$$BranchArmImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String when, String next});
}

/// @nodoc
class __$$BranchArmImplCopyWithImpl<$Res>
    extends _$BranchArmCopyWithImpl<$Res, _$BranchArmImpl>
    implements _$$BranchArmImplCopyWith<$Res> {
  __$$BranchArmImplCopyWithImpl(
      _$BranchArmImpl _value, $Res Function(_$BranchArmImpl) _then)
      : super(_value, _then);

  /// Create a copy of BranchArm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? when = null,
    Object? next = null,
  }) {
    return _then(_$BranchArmImpl(
      when: null == when
          ? _value.when
          : when // ignore: cast_nullable_to_non_nullable
              as String,
      next: null == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BranchArmImpl implements _BranchArm {
  const _$BranchArmImpl({required this.when, required this.next});

  /// Expression over `context`, e.g. `context.decision.approved == true`.
  @override
  final String when;
  @override
  final String next;

  @override
  String toString() {
    return 'BranchArm(when: $when, next: $next)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchArmImpl &&
            (identical(other.when, when) || other.when == when) &&
            (identical(other.next, next) || other.next == next));
  }

  @override
  int get hashCode => Object.hash(runtimeType, when, next);

  /// Create a copy of BranchArm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchArmImplCopyWith<_$BranchArmImpl> get copyWith =>
      __$$BranchArmImplCopyWithImpl<_$BranchArmImpl>(this, _$identity);
}

abstract class _BranchArm implements BranchArm {
  const factory _BranchArm(
      {required final String when,
      required final String next}) = _$BranchArmImpl;

  /// Expression over `context`, e.g. `context.decision.approved == true`.
  @override
  String get when;
  @override
  String get next;

  /// Create a copy of BranchArm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchArmImplCopyWith<_$BranchArmImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HumanOutcome {
  String get value => throw _privateConstructorUsedError;
  String get next => throw _privateConstructorUsedError;

  /// Create a copy of HumanOutcome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HumanOutcomeCopyWith<HumanOutcome> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HumanOutcomeCopyWith<$Res> {
  factory $HumanOutcomeCopyWith(
          HumanOutcome value, $Res Function(HumanOutcome) then) =
      _$HumanOutcomeCopyWithImpl<$Res, HumanOutcome>;
  @useResult
  $Res call({String value, String next});
}

/// @nodoc
class _$HumanOutcomeCopyWithImpl<$Res, $Val extends HumanOutcome>
    implements $HumanOutcomeCopyWith<$Res> {
  _$HumanOutcomeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HumanOutcome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? next = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      next: null == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HumanOutcomeImplCopyWith<$Res>
    implements $HumanOutcomeCopyWith<$Res> {
  factory _$$HumanOutcomeImplCopyWith(
          _$HumanOutcomeImpl value, $Res Function(_$HumanOutcomeImpl) then) =
      __$$HumanOutcomeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value, String next});
}

/// @nodoc
class __$$HumanOutcomeImplCopyWithImpl<$Res>
    extends _$HumanOutcomeCopyWithImpl<$Res, _$HumanOutcomeImpl>
    implements _$$HumanOutcomeImplCopyWith<$Res> {
  __$$HumanOutcomeImplCopyWithImpl(
      _$HumanOutcomeImpl _value, $Res Function(_$HumanOutcomeImpl) _then)
      : super(_value, _then);

  /// Create a copy of HumanOutcome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? next = null,
  }) {
    return _then(_$HumanOutcomeImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      next: null == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HumanOutcomeImpl implements _HumanOutcome {
  const _$HumanOutcomeImpl({required this.value, required this.next});

  @override
  final String value;
  @override
  final String next;

  @override
  String toString() {
    return 'HumanOutcome(value: $value, next: $next)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HumanOutcomeImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.next, next) || other.next == next));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value, next);

  /// Create a copy of HumanOutcome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HumanOutcomeImplCopyWith<_$HumanOutcomeImpl> get copyWith =>
      __$$HumanOutcomeImplCopyWithImpl<_$HumanOutcomeImpl>(this, _$identity);
}

abstract class _HumanOutcome implements HumanOutcome {
  const factory _HumanOutcome(
      {required final String value,
      required final String next}) = _$HumanOutcomeImpl;

  @override
  String get value;
  @override
  String get next;

  /// Create a copy of HumanOutcome
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HumanOutcomeImplCopyWith<_$HumanOutcomeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
