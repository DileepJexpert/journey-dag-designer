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
  String get expression => throw _privateConstructorUsedError;
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
  $Res call({String expression, String next});
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
    Object? expression = null,
    Object? next = null,
  }) {
    return _then(_value.copyWith(
      expression: null == expression
          ? _value.expression
          : expression // ignore: cast_nullable_to_non_nullable
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
  $Res call({String expression, String next});
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
    Object? expression = null,
    Object? next = null,
  }) {
    return _then(_$BranchArmImpl(
      expression: null == expression
          ? _value.expression
          : expression // ignore: cast_nullable_to_non_nullable
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
  const _$BranchArmImpl({required this.expression, required this.next});

  @override
  final String expression;
  @override
  final String next;

  @override
  String toString() {
    return 'BranchArm(expression: $expression, next: $next)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchArmImpl &&
            (identical(other.expression, expression) ||
                other.expression == expression) &&
            (identical(other.next, next) || other.next == next));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expression, next);

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
      {required final String expression,
      required final String next}) = _$BranchArmImpl;

  @override
  String get expression;
  @override
  String get next;

  /// Create a copy of BranchArm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchArmImplCopyWith<_$BranchArmImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
