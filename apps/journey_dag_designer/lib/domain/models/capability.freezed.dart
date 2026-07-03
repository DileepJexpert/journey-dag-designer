// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CapabilityPort {
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of CapabilityPort
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CapabilityPortCopyWith<CapabilityPort> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CapabilityPortCopyWith<$Res> {
  factory $CapabilityPortCopyWith(
          CapabilityPort value, $Res Function(CapabilityPort) then) =
      _$CapabilityPortCopyWithImpl<$Res, CapabilityPort>;
  @useResult
  $Res call({String name, String? description});
}

/// @nodoc
class _$CapabilityPortCopyWithImpl<$Res, $Val extends CapabilityPort>
    implements $CapabilityPortCopyWith<$Res> {
  _$CapabilityPortCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CapabilityPort
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CapabilityPortImplCopyWith<$Res>
    implements $CapabilityPortCopyWith<$Res> {
  factory _$$CapabilityPortImplCopyWith(_$CapabilityPortImpl value,
          $Res Function(_$CapabilityPortImpl) then) =
      __$$CapabilityPortImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? description});
}

/// @nodoc
class __$$CapabilityPortImplCopyWithImpl<$Res>
    extends _$CapabilityPortCopyWithImpl<$Res, _$CapabilityPortImpl>
    implements _$$CapabilityPortImplCopyWith<$Res> {
  __$$CapabilityPortImplCopyWithImpl(
      _$CapabilityPortImpl _value, $Res Function(_$CapabilityPortImpl) _then)
      : super(_value, _then);

  /// Create a copy of CapabilityPort
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_$CapabilityPortImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CapabilityPortImpl implements _CapabilityPort {
  const _$CapabilityPortImpl({required this.name, this.description});

  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'CapabilityPort(name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CapabilityPortImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, description);

  /// Create a copy of CapabilityPort
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CapabilityPortImplCopyWith<_$CapabilityPortImpl> get copyWith =>
      __$$CapabilityPortImplCopyWithImpl<_$CapabilityPortImpl>(
          this, _$identity);
}

abstract class _CapabilityPort implements CapabilityPort {
  const factory _CapabilityPort(
      {required final String name,
      final String? description}) = _$CapabilityPortImpl;

  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of CapabilityPort
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CapabilityPortImplCopyWith<_$CapabilityPortImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Capability {
  String get key => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Business area that OWNS this capability — an ownership label only, NOT a
  /// scope axis (build doc §0): e.g. "Lending", "KYC", "Payments".
  String? get domain => throw _privateConstructorUsedError;
  List<CapabilityPort> get ports => throw _privateConstructorUsedError;

  /// The operations this capability exposes (Charter §7 task `operation`, BRD
  /// §2). The editor offers these in the task inspector so a maker picks a real
  /// operation; mirrors the backend capability's CapabilityOperation set.
  List<String> get operations => throw _privateConstructorUsedError;

  /// Money/booking nodes (e.g. lending-origination) MUST declare a
  /// compensation in any DAG that uses them — enforced by [DagValidator].
  bool get isMoneyOrBookingNode => throw _privateConstructorUsedError;

  /// Create a copy of Capability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CapabilityCopyWith<Capability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CapabilityCopyWith<$Res> {
  factory $CapabilityCopyWith(
          Capability value, $Res Function(Capability) then) =
      _$CapabilityCopyWithImpl<$Res, Capability>;
  @useResult
  $Res call(
      {String key,
      String name,
      String? domain,
      List<CapabilityPort> ports,
      List<String> operations,
      bool isMoneyOrBookingNode});
}

/// @nodoc
class _$CapabilityCopyWithImpl<$Res, $Val extends Capability>
    implements $CapabilityCopyWith<$Res> {
  _$CapabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Capability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? domain = freezed,
    Object? ports = null,
    Object? operations = null,
    Object? isMoneyOrBookingNode = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      domain: freezed == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String?,
      ports: null == ports
          ? _value.ports
          : ports // ignore: cast_nullable_to_non_nullable
              as List<CapabilityPort>,
      operations: null == operations
          ? _value.operations
          : operations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isMoneyOrBookingNode: null == isMoneyOrBookingNode
          ? _value.isMoneyOrBookingNode
          : isMoneyOrBookingNode // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CapabilityImplCopyWith<$Res>
    implements $CapabilityCopyWith<$Res> {
  factory _$$CapabilityImplCopyWith(
          _$CapabilityImpl value, $Res Function(_$CapabilityImpl) then) =
      __$$CapabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String name,
      String? domain,
      List<CapabilityPort> ports,
      List<String> operations,
      bool isMoneyOrBookingNode});
}

/// @nodoc
class __$$CapabilityImplCopyWithImpl<$Res>
    extends _$CapabilityCopyWithImpl<$Res, _$CapabilityImpl>
    implements _$$CapabilityImplCopyWith<$Res> {
  __$$CapabilityImplCopyWithImpl(
      _$CapabilityImpl _value, $Res Function(_$CapabilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of Capability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? domain = freezed,
    Object? ports = null,
    Object? operations = null,
    Object? isMoneyOrBookingNode = null,
  }) {
    return _then(_$CapabilityImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      domain: freezed == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String?,
      ports: null == ports
          ? _value._ports
          : ports // ignore: cast_nullable_to_non_nullable
              as List<CapabilityPort>,
      operations: null == operations
          ? _value._operations
          : operations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isMoneyOrBookingNode: null == isMoneyOrBookingNode
          ? _value.isMoneyOrBookingNode
          : isMoneyOrBookingNode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CapabilityImpl extends _Capability {
  const _$CapabilityImpl(
      {required this.key,
      required this.name,
      this.domain,
      final List<CapabilityPort> ports = const <CapabilityPort>[],
      final List<String> operations = const <String>[],
      this.isMoneyOrBookingNode = false})
      : _ports = ports,
        _operations = operations,
        super._();

  @override
  final String key;
  @override
  final String name;

  /// Business area that OWNS this capability — an ownership label only, NOT a
  /// scope axis (build doc §0): e.g. "Lending", "KYC", "Payments".
  @override
  final String? domain;
  final List<CapabilityPort> _ports;
  @override
  @JsonKey()
  List<CapabilityPort> get ports {
    if (_ports is EqualUnmodifiableListView) return _ports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ports);
  }

  /// The operations this capability exposes (Charter §7 task `operation`, BRD
  /// §2). The editor offers these in the task inspector so a maker picks a real
  /// operation; mirrors the backend capability's CapabilityOperation set.
  final List<String> _operations;

  /// The operations this capability exposes (Charter §7 task `operation`, BRD
  /// §2). The editor offers these in the task inspector so a maker picks a real
  /// operation; mirrors the backend capability's CapabilityOperation set.
  @override
  @JsonKey()
  List<String> get operations {
    if (_operations is EqualUnmodifiableListView) return _operations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_operations);
  }

  /// Money/booking nodes (e.g. lending-origination) MUST declare a
  /// compensation in any DAG that uses them — enforced by [DagValidator].
  @override
  @JsonKey()
  final bool isMoneyOrBookingNode;

  @override
  String toString() {
    return 'Capability(key: $key, name: $name, domain: $domain, ports: $ports, operations: $operations, isMoneyOrBookingNode: $isMoneyOrBookingNode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CapabilityImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.domain, domain) || other.domain == domain) &&
            const DeepCollectionEquality().equals(other._ports, _ports) &&
            const DeepCollectionEquality()
                .equals(other._operations, _operations) &&
            (identical(other.isMoneyOrBookingNode, isMoneyOrBookingNode) ||
                other.isMoneyOrBookingNode == isMoneyOrBookingNode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      key,
      name,
      domain,
      const DeepCollectionEquality().hash(_ports),
      const DeepCollectionEquality().hash(_operations),
      isMoneyOrBookingNode);

  /// Create a copy of Capability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CapabilityImplCopyWith<_$CapabilityImpl> get copyWith =>
      __$$CapabilityImplCopyWithImpl<_$CapabilityImpl>(this, _$identity);
}

abstract class _Capability extends Capability {
  const factory _Capability(
      {required final String key,
      required final String name,
      final String? domain,
      final List<CapabilityPort> ports,
      final List<String> operations,
      final bool isMoneyOrBookingNode}) = _$CapabilityImpl;
  const _Capability._() : super._();

  @override
  String get key;
  @override
  String get name;

  /// Business area that OWNS this capability — an ownership label only, NOT a
  /// scope axis (build doc §0): e.g. "Lending", "KYC", "Payments".
  @override
  String? get domain;
  @override
  List<CapabilityPort> get ports;

  /// The operations this capability exposes (Charter §7 task `operation`, BRD
  /// §2). The editor offers these in the task inspector so a maker picks a real
  /// operation; mirrors the backend capability's CapabilityOperation set.
  @override
  List<String> get operations;

  /// Money/booking nodes (e.g. lending-origination) MUST declare a
  /// compensation in any DAG that uses them — enforced by [DagValidator].
  @override
  bool get isMoneyOrBookingNode;

  /// Create a copy of Capability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CapabilityImplCopyWith<_$CapabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
