// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dag_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DagNode {
  String get id => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)
        task,
    required TResult Function(
            String id, List<String> joinOn, List<BranchArm> arms)
        branch,
    required TResult Function(String id, List<String> emit, String? action)
        terminal,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<String> joinOn, List<BranchArm> arms)?
        branch,
    TResult? Function(String id, List<String> emit, String? action)? terminal,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<String> joinOn, List<BranchArm> arms)?
        branch,
    TResult Function(String id, List<String> emit, String? action)? terminal,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(TerminalNode value) terminal,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(TerminalNode value)? terminal,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DagNodeCopyWith<DagNode> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DagNodeCopyWith<$Res> {
  factory $DagNodeCopyWith(DagNode value, $Res Function(DagNode) then) =
      _$DagNodeCopyWithImpl<$Res, DagNode>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$DagNodeCopyWithImpl<$Res, $Val extends DagNode>
    implements $DagNodeCopyWith<$Res> {
  _$DagNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskNodeImplCopyWith<$Res> implements $DagNodeCopyWith<$Res> {
  factory _$$TaskNodeImplCopyWith(
          _$TaskNodeImpl value, $Res Function(_$TaskNodeImpl) then) =
      __$$TaskNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String capabilityKey,
      List<String> next,
      List<String> joinOn,
      String? meter,
      String? compensation,
      bool optional});
}

/// @nodoc
class __$$TaskNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$TaskNodeImpl>
    implements _$$TaskNodeImplCopyWith<$Res> {
  __$$TaskNodeImplCopyWithImpl(
      _$TaskNodeImpl _value, $Res Function(_$TaskNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? capabilityKey = null,
    Object? next = null,
    Object? joinOn = null,
    Object? meter = freezed,
    Object? compensation = freezed,
    Object? optional = null,
  }) {
    return _then(_$TaskNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      capabilityKey: null == capabilityKey
          ? _value.capabilityKey
          : capabilityKey // ignore: cast_nullable_to_non_nullable
              as String,
      next: null == next
          ? _value._next
          : next // ignore: cast_nullable_to_non_nullable
              as List<String>,
      joinOn: null == joinOn
          ? _value._joinOn
          : joinOn // ignore: cast_nullable_to_non_nullable
              as List<String>,
      meter: freezed == meter
          ? _value.meter
          : meter // ignore: cast_nullable_to_non_nullable
              as String?,
      compensation: freezed == compensation
          ? _value.compensation
          : compensation // ignore: cast_nullable_to_non_nullable
              as String?,
      optional: null == optional
          ? _value.optional
          : optional // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TaskNodeImpl extends TaskNode {
  const _$TaskNodeImpl(
      {required this.id,
      required this.capabilityKey,
      final List<String> next = const <String>[],
      final List<String> joinOn = const <String>[],
      this.meter,
      this.compensation,
      this.optional = false})
      : _next = next,
        _joinOn = joinOn,
        super._();

  @override
  final String id;

  /// References a registered [Capability.key]. The palette only offers
  /// registered capabilities, so this can only be set to something real.
  @override
  final String capabilityKey;

  /// Outgoing edges. Fan-out (parallel successors) = length > 1.
  final List<String> _next;

  /// Outgoing edges. Fan-out (parallel successors) = length > 1.
  @override
  @JsonKey()
  List<String> get next {
    if (_next is EqualUnmodifiableListView) return _next;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_next);
  }

  /// Predecessors this node must wait for before running (join). Empty = run
  /// as soon as any inbound edge delivers.
  final List<String> _joinOn;

  /// Predecessors this node must wait for before running (join). Empty = run
  /// as soon as any inbound edge delivers.
  @override
  @JsonKey()
  List<String> get joinOn {
    if (_joinOn is EqualUnmodifiableListView) return _joinOn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_joinOn);
  }

  /// Backpressure marker, e.g. "finnone_pool".
  @override
  final String? meter;

  /// Node id to run on failure (saga compensation).
  @override
  final String? compensation;
  @override
  @JsonKey()
  final bool optional;

  @override
  String toString() {
    return 'DagNode.task(id: $id, capabilityKey: $capabilityKey, next: $next, joinOn: $joinOn, meter: $meter, compensation: $compensation, optional: $optional)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.capabilityKey, capabilityKey) ||
                other.capabilityKey == capabilityKey) &&
            const DeepCollectionEquality().equals(other._next, _next) &&
            const DeepCollectionEquality().equals(other._joinOn, _joinOn) &&
            (identical(other.meter, meter) || other.meter == meter) &&
            (identical(other.compensation, compensation) ||
                other.compensation == compensation) &&
            (identical(other.optional, optional) ||
                other.optional == optional));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      capabilityKey,
      const DeepCollectionEquality().hash(_next),
      const DeepCollectionEquality().hash(_joinOn),
      meter,
      compensation,
      optional);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskNodeImplCopyWith<_$TaskNodeImpl> get copyWith =>
      __$$TaskNodeImplCopyWithImpl<_$TaskNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)
        task,
    required TResult Function(
            String id, List<String> joinOn, List<BranchArm> arms)
        branch,
    required TResult Function(String id, List<String> emit, String? action)
        terminal,
  }) {
    return task(id, capabilityKey, next, joinOn, meter, compensation, optional);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<String> joinOn, List<BranchArm> arms)?
        branch,
    TResult? Function(String id, List<String> emit, String? action)? terminal,
  }) {
    return task?.call(
        id, capabilityKey, next, joinOn, meter, compensation, optional);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<String> joinOn, List<BranchArm> arms)?
        branch,
    TResult Function(String id, List<String> emit, String? action)? terminal,
    required TResult orElse(),
  }) {
    if (task != null) {
      return task(
          id, capabilityKey, next, joinOn, meter, compensation, optional);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return task(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return task?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (task != null) {
      return task(this);
    }
    return orElse();
  }
}

abstract class TaskNode extends DagNode {
  const factory TaskNode(
      {required final String id,
      required final String capabilityKey,
      final List<String> next,
      final List<String> joinOn,
      final String? meter,
      final String? compensation,
      final bool optional}) = _$TaskNodeImpl;
  const TaskNode._() : super._();

  @override
  String get id;

  /// References a registered [Capability.key]. The palette only offers
  /// registered capabilities, so this can only be set to something real.
  String get capabilityKey;

  /// Outgoing edges. Fan-out (parallel successors) = length > 1.
  List<String> get next;

  /// Predecessors this node must wait for before running (join). Empty = run
  /// as soon as any inbound edge delivers.
  List<String> get joinOn;

  /// Backpressure marker, e.g. "finnone_pool".
  String? get meter;

  /// Node id to run on failure (saga compensation).
  String? get compensation;
  bool get optional;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskNodeImplCopyWith<_$TaskNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BranchNodeImplCopyWith<$Res>
    implements $DagNodeCopyWith<$Res> {
  factory _$$BranchNodeImplCopyWith(
          _$BranchNodeImpl value, $Res Function(_$BranchNodeImpl) then) =
      __$$BranchNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, List<String> joinOn, List<BranchArm> arms});
}

/// @nodoc
class __$$BranchNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$BranchNodeImpl>
    implements _$$BranchNodeImplCopyWith<$Res> {
  __$$BranchNodeImplCopyWithImpl(
      _$BranchNodeImpl _value, $Res Function(_$BranchNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? joinOn = null,
    Object? arms = null,
  }) {
    return _then(_$BranchNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      joinOn: null == joinOn
          ? _value._joinOn
          : joinOn // ignore: cast_nullable_to_non_nullable
              as List<String>,
      arms: null == arms
          ? _value._arms
          : arms // ignore: cast_nullable_to_non_nullable
              as List<BranchArm>,
    ));
  }
}

/// @nodoc

class _$BranchNodeImpl extends BranchNode {
  const _$BranchNodeImpl(
      {required this.id,
      final List<String> joinOn = const <String>[],
      required final List<BranchArm> arms})
      : _joinOn = joinOn,
        _arms = arms,
        super._();

  @override
  final String id;
  final List<String> _joinOn;
  @override
  @JsonKey()
  List<String> get joinOn {
    if (_joinOn is EqualUnmodifiableListView) return _joinOn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_joinOn);
  }

  final List<BranchArm> _arms;
  @override
  List<BranchArm> get arms {
    if (_arms is EqualUnmodifiableListView) return _arms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_arms);
  }

  @override
  String toString() {
    return 'DagNode.branch(id: $id, joinOn: $joinOn, arms: $arms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._joinOn, _joinOn) &&
            const DeepCollectionEquality().equals(other._arms, _arms));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_joinOn),
      const DeepCollectionEquality().hash(_arms));

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchNodeImplCopyWith<_$BranchNodeImpl> get copyWith =>
      __$$BranchNodeImplCopyWithImpl<_$BranchNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)
        task,
    required TResult Function(
            String id, List<String> joinOn, List<BranchArm> arms)
        branch,
    required TResult Function(String id, List<String> emit, String? action)
        terminal,
  }) {
    return branch(id, joinOn, arms);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<String> joinOn, List<BranchArm> arms)?
        branch,
    TResult? Function(String id, List<String> emit, String? action)? terminal,
  }) {
    return branch?.call(id, joinOn, arms);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<String> joinOn, List<BranchArm> arms)?
        branch,
    TResult Function(String id, List<String> emit, String? action)? terminal,
    required TResult orElse(),
  }) {
    if (branch != null) {
      return branch(id, joinOn, arms);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return branch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return branch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (branch != null) {
      return branch(this);
    }
    return orElse();
  }
}

abstract class BranchNode extends DagNode {
  const factory BranchNode(
      {required final String id,
      final List<String> joinOn,
      required final List<BranchArm> arms}) = _$BranchNodeImpl;
  const BranchNode._() : super._();

  @override
  String get id;
  List<String> get joinOn;
  List<BranchArm> get arms;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchNodeImplCopyWith<_$BranchNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TerminalNodeImplCopyWith<$Res>
    implements $DagNodeCopyWith<$Res> {
  factory _$$TerminalNodeImplCopyWith(
          _$TerminalNodeImpl value, $Res Function(_$TerminalNodeImpl) then) =
      __$$TerminalNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, List<String> emit, String? action});
}

/// @nodoc
class __$$TerminalNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$TerminalNodeImpl>
    implements _$$TerminalNodeImplCopyWith<$Res> {
  __$$TerminalNodeImplCopyWithImpl(
      _$TerminalNodeImpl _value, $Res Function(_$TerminalNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? emit = null,
    Object? action = freezed,
  }) {
    return _then(_$TerminalNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      emit: null == emit
          ? _value._emit
          : emit // ignore: cast_nullable_to_non_nullable
              as List<String>,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TerminalNodeImpl extends TerminalNode {
  const _$TerminalNodeImpl(
      {required this.id,
      final List<String> emit = const <String>[],
      this.action})
      : _emit = emit,
        super._();

  @override
  final String id;
  final List<String> _emit;
  @override
  @JsonKey()
  List<String> get emit {
    if (_emit is EqualUnmodifiableListView) return _emit;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emit);
  }

  /// e.g. "push_decision_to_channel".
  @override
  final String? action;

  @override
  String toString() {
    return 'DagNode.terminal(id: $id, emit: $emit, action: $action)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TerminalNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._emit, _emit) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, const DeepCollectionEquality().hash(_emit), action);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TerminalNodeImplCopyWith<_$TerminalNodeImpl> get copyWith =>
      __$$TerminalNodeImplCopyWithImpl<_$TerminalNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)
        task,
    required TResult Function(
            String id, List<String> joinOn, List<BranchArm> arms)
        branch,
    required TResult Function(String id, List<String> emit, String? action)
        terminal,
  }) {
    return terminal(id, emit, action);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<String> joinOn, List<BranchArm> arms)?
        branch,
    TResult? Function(String id, List<String> emit, String? action)? terminal,
  }) {
    return terminal?.call(id, emit, action);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capabilityKey,
            List<String> next,
            List<String> joinOn,
            String? meter,
            String? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<String> joinOn, List<BranchArm> arms)?
        branch,
    TResult Function(String id, List<String> emit, String? action)? terminal,
    required TResult orElse(),
  }) {
    if (terminal != null) {
      return terminal(id, emit, action);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return terminal(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return terminal?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (terminal != null) {
      return terminal(this);
    }
    return orElse();
  }
}

abstract class TerminalNode extends DagNode {
  const factory TerminalNode(
      {required final String id,
      final List<String> emit,
      final String? action}) = _$TerminalNodeImpl;
  const TerminalNode._() : super._();

  @override
  String get id;
  List<String> get emit;

  /// e.g. "push_decision_to_channel".
  String? get action;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TerminalNodeImplCopyWith<_$TerminalNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
