// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Dag {
  String get startNodeId => throw _privateConstructorUsedError;
  List<DagNode> get nodes => throw _privateConstructorUsedError;

  /// Named backpressure pools (Charter §7 `pools`): pool name -> cap.
  Map<String, PoolSpec> get pools => throw _privateConstructorUsedError;

  /// The typed context schema reference, e.g. "loan-origination-context@1".
  String? get contextSchemaRef => throw _privateConstructorUsedError;

  /// nodeId -> persisted canvas position (Designer-only, not engine config).
  Map<String, NodeLayout> get layout => throw _privateConstructorUsedError;

  /// Create a copy of Dag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DagCopyWith<Dag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DagCopyWith<$Res> {
  factory $DagCopyWith(Dag value, $Res Function(Dag) then) =
      _$DagCopyWithImpl<$Res, Dag>;
  @useResult
  $Res call(
      {String startNodeId,
      List<DagNode> nodes,
      Map<String, PoolSpec> pools,
      String? contextSchemaRef,
      Map<String, NodeLayout> layout});
}

/// @nodoc
class _$DagCopyWithImpl<$Res, $Val extends Dag> implements $DagCopyWith<$Res> {
  _$DagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startNodeId = null,
    Object? nodes = null,
    Object? pools = null,
    Object? contextSchemaRef = freezed,
    Object? layout = null,
  }) {
    return _then(_value.copyWith(
      startNodeId: null == startNodeId
          ? _value.startNodeId
          : startNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<DagNode>,
      pools: null == pools
          ? _value.pools
          : pools // ignore: cast_nullable_to_non_nullable
              as Map<String, PoolSpec>,
      contextSchemaRef: freezed == contextSchemaRef
          ? _value.contextSchemaRef
          : contextSchemaRef // ignore: cast_nullable_to_non_nullable
              as String?,
      layout: null == layout
          ? _value.layout
          : layout // ignore: cast_nullable_to_non_nullable
              as Map<String, NodeLayout>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DagImplCopyWith<$Res> implements $DagCopyWith<$Res> {
  factory _$$DagImplCopyWith(_$DagImpl value, $Res Function(_$DagImpl) then) =
      __$$DagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String startNodeId,
      List<DagNode> nodes,
      Map<String, PoolSpec> pools,
      String? contextSchemaRef,
      Map<String, NodeLayout> layout});
}

/// @nodoc
class __$$DagImplCopyWithImpl<$Res> extends _$DagCopyWithImpl<$Res, _$DagImpl>
    implements _$$DagImplCopyWith<$Res> {
  __$$DagImplCopyWithImpl(_$DagImpl _value, $Res Function(_$DagImpl) _then)
      : super(_value, _then);

  /// Create a copy of Dag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startNodeId = null,
    Object? nodes = null,
    Object? pools = null,
    Object? contextSchemaRef = freezed,
    Object? layout = null,
  }) {
    return _then(_$DagImpl(
      startNodeId: null == startNodeId
          ? _value.startNodeId
          : startNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<DagNode>,
      pools: null == pools
          ? _value._pools
          : pools // ignore: cast_nullable_to_non_nullable
              as Map<String, PoolSpec>,
      contextSchemaRef: freezed == contextSchemaRef
          ? _value.contextSchemaRef
          : contextSchemaRef // ignore: cast_nullable_to_non_nullable
              as String?,
      layout: null == layout
          ? _value._layout
          : layout // ignore: cast_nullable_to_non_nullable
              as Map<String, NodeLayout>,
    ));
  }
}

/// @nodoc

class _$DagImpl extends _Dag {
  const _$DagImpl(
      {required this.startNodeId,
      required final List<DagNode> nodes,
      final Map<String, PoolSpec> pools = const <String, PoolSpec>{},
      this.contextSchemaRef,
      final Map<String, NodeLayout> layout = const <String, NodeLayout>{}})
      : _nodes = nodes,
        _pools = pools,
        _layout = layout,
        super._();

  @override
  final String startNodeId;
  final List<DagNode> _nodes;
  @override
  List<DagNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  /// Named backpressure pools (Charter §7 `pools`): pool name -> cap.
  final Map<String, PoolSpec> _pools;

  /// Named backpressure pools (Charter §7 `pools`): pool name -> cap.
  @override
  @JsonKey()
  Map<String, PoolSpec> get pools {
    if (_pools is EqualUnmodifiableMapView) return _pools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pools);
  }

  /// The typed context schema reference, e.g. "loan-origination-context@1".
  @override
  final String? contextSchemaRef;

  /// nodeId -> persisted canvas position (Designer-only, not engine config).
  final Map<String, NodeLayout> _layout;

  /// nodeId -> persisted canvas position (Designer-only, not engine config).
  @override
  @JsonKey()
  Map<String, NodeLayout> get layout {
    if (_layout is EqualUnmodifiableMapView) return _layout;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_layout);
  }

  @override
  String toString() {
    return 'Dag(startNodeId: $startNodeId, nodes: $nodes, pools: $pools, contextSchemaRef: $contextSchemaRef, layout: $layout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DagImpl &&
            (identical(other.startNodeId, startNodeId) ||
                other.startNodeId == startNodeId) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._pools, _pools) &&
            (identical(other.contextSchemaRef, contextSchemaRef) ||
                other.contextSchemaRef == contextSchemaRef) &&
            const DeepCollectionEquality().equals(other._layout, _layout));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      startNodeId,
      const DeepCollectionEquality().hash(_nodes),
      const DeepCollectionEquality().hash(_pools),
      contextSchemaRef,
      const DeepCollectionEquality().hash(_layout));

  /// Create a copy of Dag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DagImplCopyWith<_$DagImpl> get copyWith =>
      __$$DagImplCopyWithImpl<_$DagImpl>(this, _$identity);
}

abstract class _Dag extends Dag {
  const factory _Dag(
      {required final String startNodeId,
      required final List<DagNode> nodes,
      final Map<String, PoolSpec> pools,
      final String? contextSchemaRef,
      final Map<String, NodeLayout> layout}) = _$DagImpl;
  const _Dag._() : super._();

  @override
  String get startNodeId;
  @override
  List<DagNode> get nodes;

  /// Named backpressure pools (Charter §7 `pools`): pool name -> cap.
  @override
  Map<String, PoolSpec> get pools;

  /// The typed context schema reference, e.g. "loan-origination-context@1".
  @override
  String? get contextSchemaRef;

  /// nodeId -> persisted canvas position (Designer-only, not engine config).
  @override
  Map<String, NodeLayout> get layout;

  /// Create a copy of Dag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DagImplCopyWith<_$DagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
