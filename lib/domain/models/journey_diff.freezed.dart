// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_diff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DagEdge {
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;

  /// Create a copy of DagEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DagEdgeCopyWith<DagEdge> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DagEdgeCopyWith<$Res> {
  factory $DagEdgeCopyWith(DagEdge value, $Res Function(DagEdge) then) =
      _$DagEdgeCopyWithImpl<$Res, DagEdge>;
  @useResult
  $Res call({String from, String to});
}

/// @nodoc
class _$DagEdgeCopyWithImpl<$Res, $Val extends DagEdge>
    implements $DagEdgeCopyWith<$Res> {
  _$DagEdgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DagEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
  }) {
    return _then(_value.copyWith(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DagEdgeImplCopyWith<$Res> implements $DagEdgeCopyWith<$Res> {
  factory _$$DagEdgeImplCopyWith(
          _$DagEdgeImpl value, $Res Function(_$DagEdgeImpl) then) =
      __$$DagEdgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String from, String to});
}

/// @nodoc
class __$$DagEdgeImplCopyWithImpl<$Res>
    extends _$DagEdgeCopyWithImpl<$Res, _$DagEdgeImpl>
    implements _$$DagEdgeImplCopyWith<$Res> {
  __$$DagEdgeImplCopyWithImpl(
      _$DagEdgeImpl _value, $Res Function(_$DagEdgeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
  }) {
    return _then(_$DagEdgeImpl(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DagEdgeImpl implements _DagEdge {
  const _$DagEdgeImpl({required this.from, required this.to});

  @override
  final String from;
  @override
  final String to;

  @override
  String toString() {
    return 'DagEdge(from: $from, to: $to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DagEdgeImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to);

  /// Create a copy of DagEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DagEdgeImplCopyWith<_$DagEdgeImpl> get copyWith =>
      __$$DagEdgeImplCopyWithImpl<_$DagEdgeImpl>(this, _$identity);
}

abstract class _DagEdge implements DagEdge {
  const factory _DagEdge(
      {required final String from, required final String to}) = _$DagEdgeImpl;

  @override
  String get from;
  @override
  String get to;

  /// Create a copy of DagEdge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DagEdgeImplCopyWith<_$DagEdgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DagDiff {
  List<String> get addedNodes => throw _privateConstructorUsedError;
  List<String> get removedNodes => throw _privateConstructorUsedError;

  /// Nodes present in both DAGs whose definition changed (config, not layout).
  List<String> get changedNodes => throw _privateConstructorUsedError;
  List<DagEdge> get addedEdges => throw _privateConstructorUsedError;
  List<DagEdge> get removedEdges => throw _privateConstructorUsedError;

  /// Create a copy of DagDiff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DagDiffCopyWith<DagDiff> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DagDiffCopyWith<$Res> {
  factory $DagDiffCopyWith(DagDiff value, $Res Function(DagDiff) then) =
      _$DagDiffCopyWithImpl<$Res, DagDiff>;
  @useResult
  $Res call(
      {List<String> addedNodes,
      List<String> removedNodes,
      List<String> changedNodes,
      List<DagEdge> addedEdges,
      List<DagEdge> removedEdges});
}

/// @nodoc
class _$DagDiffCopyWithImpl<$Res, $Val extends DagDiff>
    implements $DagDiffCopyWith<$Res> {
  _$DagDiffCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DagDiff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addedNodes = null,
    Object? removedNodes = null,
    Object? changedNodes = null,
    Object? addedEdges = null,
    Object? removedEdges = null,
  }) {
    return _then(_value.copyWith(
      addedNodes: null == addedNodes
          ? _value.addedNodes
          : addedNodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removedNodes: null == removedNodes
          ? _value.removedNodes
          : removedNodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      changedNodes: null == changedNodes
          ? _value.changedNodes
          : changedNodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addedEdges: null == addedEdges
          ? _value.addedEdges
          : addedEdges // ignore: cast_nullable_to_non_nullable
              as List<DagEdge>,
      removedEdges: null == removedEdges
          ? _value.removedEdges
          : removedEdges // ignore: cast_nullable_to_non_nullable
              as List<DagEdge>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DagDiffImplCopyWith<$Res> implements $DagDiffCopyWith<$Res> {
  factory _$$DagDiffImplCopyWith(
          _$DagDiffImpl value, $Res Function(_$DagDiffImpl) then) =
      __$$DagDiffImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> addedNodes,
      List<String> removedNodes,
      List<String> changedNodes,
      List<DagEdge> addedEdges,
      List<DagEdge> removedEdges});
}

/// @nodoc
class __$$DagDiffImplCopyWithImpl<$Res>
    extends _$DagDiffCopyWithImpl<$Res, _$DagDiffImpl>
    implements _$$DagDiffImplCopyWith<$Res> {
  __$$DagDiffImplCopyWithImpl(
      _$DagDiffImpl _value, $Res Function(_$DagDiffImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagDiff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addedNodes = null,
    Object? removedNodes = null,
    Object? changedNodes = null,
    Object? addedEdges = null,
    Object? removedEdges = null,
  }) {
    return _then(_$DagDiffImpl(
      addedNodes: null == addedNodes
          ? _value._addedNodes
          : addedNodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removedNodes: null == removedNodes
          ? _value._removedNodes
          : removedNodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      changedNodes: null == changedNodes
          ? _value._changedNodes
          : changedNodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addedEdges: null == addedEdges
          ? _value._addedEdges
          : addedEdges // ignore: cast_nullable_to_non_nullable
              as List<DagEdge>,
      removedEdges: null == removedEdges
          ? _value._removedEdges
          : removedEdges // ignore: cast_nullable_to_non_nullable
              as List<DagEdge>,
    ));
  }
}

/// @nodoc

class _$DagDiffImpl extends _DagDiff {
  const _$DagDiffImpl(
      {final List<String> addedNodes = const <String>[],
      final List<String> removedNodes = const <String>[],
      final List<String> changedNodes = const <String>[],
      final List<DagEdge> addedEdges = const <DagEdge>[],
      final List<DagEdge> removedEdges = const <DagEdge>[]})
      : _addedNodes = addedNodes,
        _removedNodes = removedNodes,
        _changedNodes = changedNodes,
        _addedEdges = addedEdges,
        _removedEdges = removedEdges,
        super._();

  final List<String> _addedNodes;
  @override
  @JsonKey()
  List<String> get addedNodes {
    if (_addedNodes is EqualUnmodifiableListView) return _addedNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addedNodes);
  }

  final List<String> _removedNodes;
  @override
  @JsonKey()
  List<String> get removedNodes {
    if (_removedNodes is EqualUnmodifiableListView) return _removedNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removedNodes);
  }

  /// Nodes present in both DAGs whose definition changed (config, not layout).
  final List<String> _changedNodes;

  /// Nodes present in both DAGs whose definition changed (config, not layout).
  @override
  @JsonKey()
  List<String> get changedNodes {
    if (_changedNodes is EqualUnmodifiableListView) return _changedNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_changedNodes);
  }

  final List<DagEdge> _addedEdges;
  @override
  @JsonKey()
  List<DagEdge> get addedEdges {
    if (_addedEdges is EqualUnmodifiableListView) return _addedEdges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addedEdges);
  }

  final List<DagEdge> _removedEdges;
  @override
  @JsonKey()
  List<DagEdge> get removedEdges {
    if (_removedEdges is EqualUnmodifiableListView) return _removedEdges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removedEdges);
  }

  @override
  String toString() {
    return 'DagDiff(addedNodes: $addedNodes, removedNodes: $removedNodes, changedNodes: $changedNodes, addedEdges: $addedEdges, removedEdges: $removedEdges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DagDiffImpl &&
            const DeepCollectionEquality()
                .equals(other._addedNodes, _addedNodes) &&
            const DeepCollectionEquality()
                .equals(other._removedNodes, _removedNodes) &&
            const DeepCollectionEquality()
                .equals(other._changedNodes, _changedNodes) &&
            const DeepCollectionEquality()
                .equals(other._addedEdges, _addedEdges) &&
            const DeepCollectionEquality()
                .equals(other._removedEdges, _removedEdges));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_addedNodes),
      const DeepCollectionEquality().hash(_removedNodes),
      const DeepCollectionEquality().hash(_changedNodes),
      const DeepCollectionEquality().hash(_addedEdges),
      const DeepCollectionEquality().hash(_removedEdges));

  /// Create a copy of DagDiff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DagDiffImplCopyWith<_$DagDiffImpl> get copyWith =>
      __$$DagDiffImplCopyWithImpl<_$DagDiffImpl>(this, _$identity);
}

abstract class _DagDiff extends DagDiff {
  const factory _DagDiff(
      {final List<String> addedNodes,
      final List<String> removedNodes,
      final List<String> changedNodes,
      final List<DagEdge> addedEdges,
      final List<DagEdge> removedEdges}) = _$DagDiffImpl;
  const _DagDiff._() : super._();

  @override
  List<String> get addedNodes;
  @override
  List<String> get removedNodes;

  /// Nodes present in both DAGs whose definition changed (config, not layout).
  @override
  List<String> get changedNodes;
  @override
  List<DagEdge> get addedEdges;
  @override
  List<DagEdge> get removedEdges;

  /// Create a copy of DagDiff
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DagDiffImplCopyWith<_$DagDiffImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
