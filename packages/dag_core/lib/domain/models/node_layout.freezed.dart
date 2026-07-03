// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NodeLayout {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  /// Create a copy of NodeLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeLayoutCopyWith<NodeLayout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeLayoutCopyWith<$Res> {
  factory $NodeLayoutCopyWith(
          NodeLayout value, $Res Function(NodeLayout) then) =
      _$NodeLayoutCopyWithImpl<$Res, NodeLayout>;
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class _$NodeLayoutCopyWithImpl<$Res, $Val extends NodeLayout>
    implements $NodeLayoutCopyWith<$Res> {
  _$NodeLayoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeLayoutImplCopyWith<$Res>
    implements $NodeLayoutCopyWith<$Res> {
  factory _$$NodeLayoutImplCopyWith(
          _$NodeLayoutImpl value, $Res Function(_$NodeLayoutImpl) then) =
      __$$NodeLayoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class __$$NodeLayoutImplCopyWithImpl<$Res>
    extends _$NodeLayoutCopyWithImpl<$Res, _$NodeLayoutImpl>
    implements _$$NodeLayoutImplCopyWith<$Res> {
  __$$NodeLayoutImplCopyWithImpl(
      _$NodeLayoutImpl _value, $Res Function(_$NodeLayoutImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodeLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_$NodeLayoutImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$NodeLayoutImpl implements _NodeLayout {
  const _$NodeLayoutImpl({required this.x, required this.y});

  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'NodeLayout(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeLayoutImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Create a copy of NodeLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeLayoutImplCopyWith<_$NodeLayoutImpl> get copyWith =>
      __$$NodeLayoutImplCopyWithImpl<_$NodeLayoutImpl>(this, _$identity);
}

abstract class _NodeLayout implements NodeLayout {
  const factory _NodeLayout(
      {required final double x, required final double y}) = _$NodeLayoutImpl;

  @override
  double get x;
  @override
  double get y;

  /// Create a copy of NodeLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeLayoutImplCopyWith<_$NodeLayoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
