// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'binding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Binding {
  String get businessLine => throw _privateConstructorUsedError;
  String get product => throw _privateConstructorUsedError;

  /// Partner code, or null for the unscoped/assisted (no-partner) default.
  String? get partner => throw _privateConstructorUsedError;
  String get journeyId => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Create a copy of Binding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BindingCopyWith<Binding> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BindingCopyWith<$Res> {
  factory $BindingCopyWith(Binding value, $Res Function(Binding) then) =
      _$BindingCopyWithImpl<$Res, Binding>;
  @useResult
  $Res call(
      {String businessLine,
      String product,
      String? partner,
      String journeyId,
      int version});
}

/// @nodoc
class _$BindingCopyWithImpl<$Res, $Val extends Binding>
    implements $BindingCopyWith<$Res> {
  _$BindingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Binding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessLine = null,
    Object? product = null,
    Object? partner = freezed,
    Object? journeyId = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      businessLine: null == businessLine
          ? _value.businessLine
          : businessLine // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as String,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String?,
      journeyId: null == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BindingImplCopyWith<$Res> implements $BindingCopyWith<$Res> {
  factory _$$BindingImplCopyWith(
          _$BindingImpl value, $Res Function(_$BindingImpl) then) =
      __$$BindingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String businessLine,
      String product,
      String? partner,
      String journeyId,
      int version});
}

/// @nodoc
class __$$BindingImplCopyWithImpl<$Res>
    extends _$BindingCopyWithImpl<$Res, _$BindingImpl>
    implements _$$BindingImplCopyWith<$Res> {
  __$$BindingImplCopyWithImpl(
      _$BindingImpl _value, $Res Function(_$BindingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Binding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessLine = null,
    Object? product = null,
    Object? partner = freezed,
    Object? journeyId = null,
    Object? version = null,
  }) {
    return _then(_$BindingImpl(
      businessLine: null == businessLine
          ? _value.businessLine
          : businessLine // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as String,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String?,
      journeyId: null == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BindingImpl implements _Binding {
  const _$BindingImpl(
      {required this.businessLine,
      required this.product,
      this.partner,
      required this.journeyId,
      required this.version});

  @override
  final String businessLine;
  @override
  final String product;

  /// Partner code, or null for the unscoped/assisted (no-partner) default.
  @override
  final String? partner;
  @override
  final String journeyId;
  @override
  final int version;

  @override
  String toString() {
    return 'Binding(businessLine: $businessLine, product: $product, partner: $partner, journeyId: $journeyId, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BindingImpl &&
            (identical(other.businessLine, businessLine) ||
                other.businessLine == businessLine) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.partner, partner) || other.partner == partner) &&
            (identical(other.journeyId, journeyId) ||
                other.journeyId == journeyId) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, businessLine, product, partner, journeyId, version);

  /// Create a copy of Binding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BindingImplCopyWith<_$BindingImpl> get copyWith =>
      __$$BindingImplCopyWithImpl<_$BindingImpl>(this, _$identity);
}

abstract class _Binding implements Binding {
  const factory _Binding(
      {required final String businessLine,
      required final String product,
      final String? partner,
      required final String journeyId,
      required final int version}) = _$BindingImpl;

  @override
  String get businessLine;
  @override
  String get product;

  /// Partner code, or null for the unscoped/assisted (no-partner) default.
  @override
  String? get partner;
  @override
  String get journeyId;
  @override
  int get version;

  /// Create a copy of Binding
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BindingImplCopyWith<_$BindingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
