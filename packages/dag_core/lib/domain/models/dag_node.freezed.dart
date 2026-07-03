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
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
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
      String capability,
      String? operation,
      String? input,
      String? output,
      List<String> next,
      String? condition,
      String? onFailure,
      NodePolicies? policies,
      Compensation? compensation,
      bool optional});

  $NodePoliciesCopyWith<$Res>? get policies;
  $CompensationCopyWith<$Res>? get compensation;
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
    Object? capability = null,
    Object? operation = freezed,
    Object? input = freezed,
    Object? output = freezed,
    Object? next = null,
    Object? condition = freezed,
    Object? onFailure = freezed,
    Object? policies = freezed,
    Object? compensation = freezed,
    Object? optional = null,
  }) {
    return _then(_$TaskNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      capability: null == capability
          ? _value.capability
          : capability // ignore: cast_nullable_to_non_nullable
              as String,
      operation: freezed == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String?,
      input: freezed == input
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String?,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      next: null == next
          ? _value._next
          : next // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
      onFailure: freezed == onFailure
          ? _value.onFailure
          : onFailure // ignore: cast_nullable_to_non_nullable
              as String?,
      policies: freezed == policies
          ? _value.policies
          : policies // ignore: cast_nullable_to_non_nullable
              as NodePolicies?,
      compensation: freezed == compensation
          ? _value.compensation
          : compensation // ignore: cast_nullable_to_non_nullable
              as Compensation?,
      optional: null == optional
          ? _value.optional
          : optional // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NodePoliciesCopyWith<$Res>? get policies {
    if (_value.policies == null) {
      return null;
    }

    return $NodePoliciesCopyWith<$Res>(_value.policies!, (value) {
      return _then(_value.copyWith(policies: value));
    });
  }

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompensationCopyWith<$Res>? get compensation {
    if (_value.compensation == null) {
      return null;
    }

    return $CompensationCopyWith<$Res>(_value.compensation!, (value) {
      return _then(_value.copyWith(compensation: value));
    });
  }
}

/// @nodoc

class _$TaskNodeImpl extends TaskNode {
  const _$TaskNodeImpl(
      {required this.id,
      required this.capability,
      this.operation,
      this.input,
      this.output,
      final List<String> next = const <String>[],
      this.condition,
      this.onFailure,
      this.policies,
      this.compensation,
      this.optional = false})
      : _next = next,
        super._();

  @override
  final String id;
  @override
  final String capability;
  @override
  final String? operation;
  @override
  final String? input;
// expression map -> capability input
  @override
  final String? output;
// context key to write the result into
  final List<String> _next;
// context key to write the result into
  @override
  @JsonKey()
  List<String> get next {
    if (_next is EqualUnmodifiableListView) return _next;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_next);
  }

  @override
  final String? condition;
// run only if true, else skip to next
  @override
  final String? onFailure;
// node id | "compensate" | "dlq" | "fail"
  @override
  final NodePolicies? policies;
  @override
  final Compensation? compensation;
  @override
  @JsonKey()
  final bool optional;

  @override
  String toString() {
    return 'DagNode.task(id: $id, capability: $capability, operation: $operation, input: $input, output: $output, next: $next, condition: $condition, onFailure: $onFailure, policies: $policies, compensation: $compensation, optional: $optional)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.capability, capability) ||
                other.capability == capability) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.input, input) || other.input == input) &&
            (identical(other.output, output) || other.output == output) &&
            const DeepCollectionEquality().equals(other._next, _next) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.onFailure, onFailure) ||
                other.onFailure == onFailure) &&
            (identical(other.policies, policies) ||
                other.policies == policies) &&
            (identical(other.compensation, compensation) ||
                other.compensation == compensation) &&
            (identical(other.optional, optional) ||
                other.optional == optional));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      capability,
      operation,
      input,
      output,
      const DeepCollectionEquality().hash(_next),
      condition,
      onFailure,
      policies,
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
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return task(id, capability, operation, input, output, next, condition,
        onFailure, policies, compensation, optional);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return task?.call(id, capability, operation, input, output, next, condition,
        onFailure, policies, compensation, optional);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (task != null) {
      return task(id, capability, operation, input, output, next, condition,
          onFailure, policies, compensation, optional);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return task(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return task?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
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
      required final String capability,
      final String? operation,
      final String? input,
      final String? output,
      final List<String> next,
      final String? condition,
      final String? onFailure,
      final NodePolicies? policies,
      final Compensation? compensation,
      final bool optional}) = _$TaskNodeImpl;
  const TaskNode._() : super._();

  @override
  String get id;
  String get capability;
  String? get operation;
  String? get input; // expression map -> capability input
  String? get output; // context key to write the result into
  List<String> get next;
  String? get condition; // run only if true, else skip to next
  String? get onFailure; // node id | "compensate" | "dlq" | "fail"
  NodePolicies? get policies;
  Compensation? get compensation;
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
  $Res call(
      {String id,
      List<BranchArm> arms,
      String? defaultNext,
      String? condition});
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
    Object? arms = null,
    Object? defaultNext = freezed,
    Object? condition = freezed,
  }) {
    return _then(_$BranchNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      arms: null == arms
          ? _value._arms
          : arms // ignore: cast_nullable_to_non_nullable
              as List<BranchArm>,
      defaultNext: freezed == defaultNext
          ? _value.defaultNext
          : defaultNext // ignore: cast_nullable_to_non_nullable
              as String?,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BranchNodeImpl extends BranchNode {
  const _$BranchNodeImpl(
      {required this.id,
      final List<BranchArm> arms = const <BranchArm>[],
      this.defaultNext,
      this.condition})
      : _arms = arms,
        super._();

  @override
  final String id;
  final List<BranchArm> _arms;
  @override
  @JsonKey()
  List<BranchArm> get arms {
    if (_arms is EqualUnmodifiableListView) return _arms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_arms);
  }

  @override
  final String? defaultNext;
// JSON: "default"
  @override
  final String? condition;

  @override
  String toString() {
    return 'DagNode.branch(id: $id, arms: $arms, defaultNext: $defaultNext, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._arms, _arms) &&
            (identical(other.defaultNext, defaultNext) ||
                other.defaultNext == defaultNext) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id,
      const DeepCollectionEquality().hash(_arms), defaultNext, condition);

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
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return branch(id, arms, defaultNext, condition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return branch?.call(id, arms, defaultNext, condition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (branch != null) {
      return branch(id, arms, defaultNext, condition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return branch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return branch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
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
      final List<BranchArm> arms,
      final String? defaultNext,
      final String? condition}) = _$BranchNodeImpl;
  const BranchNode._() : super._();

  @override
  String get id;
  List<BranchArm> get arms;
  String? get defaultNext; // JSON: "default"
  String? get condition;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchNodeImplCopyWith<_$BranchNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParallelNodeImplCopyWith<$Res>
    implements $DagNodeCopyWith<$Res> {
  factory _$$ParallelNodeImplCopyWith(
          _$ParallelNodeImpl value, $Res Function(_$ParallelNodeImpl) then) =
      __$$ParallelNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, List<String> branches, String? condition});
}

/// @nodoc
class __$$ParallelNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$ParallelNodeImpl>
    implements _$$ParallelNodeImplCopyWith<$Res> {
  __$$ParallelNodeImplCopyWithImpl(
      _$ParallelNodeImpl _value, $Res Function(_$ParallelNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branches = null,
    Object? condition = freezed,
  }) {
    return _then(_$ParallelNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branches: null == branches
          ? _value._branches
          : branches // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ParallelNodeImpl extends ParallelNode {
  const _$ParallelNodeImpl(
      {required this.id,
      final List<String> branches = const <String>[],
      this.condition})
      : _branches = branches,
        super._();

  @override
  final String id;
  final List<String> _branches;
  @override
  @JsonKey()
  List<String> get branches {
    if (_branches is EqualUnmodifiableListView) return _branches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branches);
  }

  @override
  final String? condition;

  @override
  String toString() {
    return 'DagNode.parallel(id: $id, branches: $branches, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParallelNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._branches, _branches) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id,
      const DeepCollectionEquality().hash(_branches), condition);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParallelNodeImplCopyWith<_$ParallelNodeImpl> get copyWith =>
      __$$ParallelNodeImplCopyWithImpl<_$ParallelNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return parallel(id, branches, condition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return parallel?.call(id, branches, condition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (parallel != null) {
      return parallel(id, branches, condition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return parallel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return parallel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (parallel != null) {
      return parallel(this);
    }
    return orElse();
  }
}

abstract class ParallelNode extends DagNode {
  const factory ParallelNode(
      {required final String id,
      final List<String> branches,
      final String? condition}) = _$ParallelNodeImpl;
  const ParallelNode._() : super._();

  @override
  String get id;
  List<String> get branches;
  String? get condition;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParallelNodeImplCopyWith<_$ParallelNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JoinNodeImplCopyWith<$Res> implements $DagNodeCopyWith<$Res> {
  factory _$$JoinNodeImplCopyWith(
          _$JoinNodeImpl value, $Res Function(_$JoinNodeImpl) then) =
      __$$JoinNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<String> joinOn,
      JoinPolicy policy,
      int? quorum,
      List<String> next,
      String? condition});
}

/// @nodoc
class __$$JoinNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$JoinNodeImpl>
    implements _$$JoinNodeImplCopyWith<$Res> {
  __$$JoinNodeImplCopyWithImpl(
      _$JoinNodeImpl _value, $Res Function(_$JoinNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? joinOn = null,
    Object? policy = null,
    Object? quorum = freezed,
    Object? next = null,
    Object? condition = freezed,
  }) {
    return _then(_$JoinNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      joinOn: null == joinOn
          ? _value._joinOn
          : joinOn // ignore: cast_nullable_to_non_nullable
              as List<String>,
      policy: null == policy
          ? _value.policy
          : policy // ignore: cast_nullable_to_non_nullable
              as JoinPolicy,
      quorum: freezed == quorum
          ? _value.quorum
          : quorum // ignore: cast_nullable_to_non_nullable
              as int?,
      next: null == next
          ? _value._next
          : next // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$JoinNodeImpl extends JoinNode {
  const _$JoinNodeImpl(
      {required this.id,
      final List<String> joinOn = const <String>[],
      this.policy = JoinPolicy.allOf,
      this.quorum,
      final List<String> next = const <String>[],
      this.condition})
      : _joinOn = joinOn,
        _next = next,
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

  @override
  @JsonKey()
  final JoinPolicy policy;
  @override
  final int? quorum;
// required when policy == quorum
  final List<String> _next;
// required when policy == quorum
  @override
  @JsonKey()
  List<String> get next {
    if (_next is EqualUnmodifiableListView) return _next;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_next);
  }

  @override
  final String? condition;

  @override
  String toString() {
    return 'DagNode.join(id: $id, joinOn: $joinOn, policy: $policy, quorum: $quorum, next: $next, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._joinOn, _joinOn) &&
            (identical(other.policy, policy) || other.policy == policy) &&
            (identical(other.quorum, quorum) || other.quorum == quorum) &&
            const DeepCollectionEquality().equals(other._next, _next) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_joinOn),
      policy,
      quorum,
      const DeepCollectionEquality().hash(_next),
      condition);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinNodeImplCopyWith<_$JoinNodeImpl> get copyWith =>
      __$$JoinNodeImplCopyWithImpl<_$JoinNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return join(id, joinOn, policy, quorum, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return join?.call(id, joinOn, policy, quorum, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (join != null) {
      return join(id, joinOn, policy, quorum, next, condition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return join(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return join?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (join != null) {
      return join(this);
    }
    return orElse();
  }
}

abstract class JoinNode extends DagNode {
  const factory JoinNode(
      {required final String id,
      final List<String> joinOn,
      final JoinPolicy policy,
      final int? quorum,
      final List<String> next,
      final String? condition}) = _$JoinNodeImpl;
  const JoinNode._() : super._();

  @override
  String get id;
  List<String> get joinOn;
  JoinPolicy get policy;
  int? get quorum; // required when policy == quorum
  List<String> get next;
  String? get condition;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinNodeImplCopyWith<_$JoinNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WaitNodeImplCopyWith<$Res> implements $DagNodeCopyWith<$Res> {
  factory _$$WaitNodeImplCopyWith(
          _$WaitNodeImpl value, $Res Function(_$WaitNodeImpl) then) =
      __$$WaitNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String waitFor,
      String? correlation,
      String? timeout,
      String? onTimeout,
      String? output,
      List<String> next,
      String? condition});
}

/// @nodoc
class __$$WaitNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$WaitNodeImpl>
    implements _$$WaitNodeImplCopyWith<$Res> {
  __$$WaitNodeImplCopyWithImpl(
      _$WaitNodeImpl _value, $Res Function(_$WaitNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? waitFor = null,
    Object? correlation = freezed,
    Object? timeout = freezed,
    Object? onTimeout = freezed,
    Object? output = freezed,
    Object? next = null,
    Object? condition = freezed,
  }) {
    return _then(_$WaitNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      waitFor: null == waitFor
          ? _value.waitFor
          : waitFor // ignore: cast_nullable_to_non_nullable
              as String,
      correlation: freezed == correlation
          ? _value.correlation
          : correlation // ignore: cast_nullable_to_non_nullable
              as String?,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as String?,
      onTimeout: freezed == onTimeout
          ? _value.onTimeout
          : onTimeout // ignore: cast_nullable_to_non_nullable
              as String?,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      next: null == next
          ? _value._next
          : next // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$WaitNodeImpl extends WaitNode {
  const _$WaitNodeImpl(
      {required this.id,
      required this.waitFor,
      this.correlation,
      this.timeout,
      this.onTimeout,
      this.output,
      final List<String> next = const <String>[],
      this.condition})
      : _next = next,
        super._();

  @override
  final String id;
  @override
  final String waitFor;
// event name
  @override
  final String? correlation;
// expression -> correlation key
  @override
  final String? timeout;
// duration; required by validation
  @override
  final String? onTimeout;
// node id; required by validation
  @override
  final String? output;
// context key for the bound event
  final List<String> _next;
// context key for the bound event
  @override
  @JsonKey()
  List<String> get next {
    if (_next is EqualUnmodifiableListView) return _next;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_next);
  }

  @override
  final String? condition;

  @override
  String toString() {
    return 'DagNode.wait(id: $id, waitFor: $waitFor, correlation: $correlation, timeout: $timeout, onTimeout: $onTimeout, output: $output, next: $next, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.waitFor, waitFor) || other.waitFor == waitFor) &&
            (identical(other.correlation, correlation) ||
                other.correlation == correlation) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.onTimeout, onTimeout) ||
                other.onTimeout == onTimeout) &&
            (identical(other.output, output) || other.output == output) &&
            const DeepCollectionEquality().equals(other._next, _next) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      waitFor,
      correlation,
      timeout,
      onTimeout,
      output,
      const DeepCollectionEquality().hash(_next),
      condition);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitNodeImplCopyWith<_$WaitNodeImpl> get copyWith =>
      __$$WaitNodeImplCopyWithImpl<_$WaitNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return wait(
        id, waitFor, correlation, timeout, onTimeout, output, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return wait?.call(
        id, waitFor, correlation, timeout, onTimeout, output, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (wait != null) {
      return wait(id, waitFor, correlation, timeout, onTimeout, output, next,
          condition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return wait(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return wait?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (wait != null) {
      return wait(this);
    }
    return orElse();
  }
}

abstract class WaitNode extends DagNode {
  const factory WaitNode(
      {required final String id,
      required final String waitFor,
      final String? correlation,
      final String? timeout,
      final String? onTimeout,
      final String? output,
      final List<String> next,
      final String? condition}) = _$WaitNodeImpl;
  const WaitNode._() : super._();

  @override
  String get id;
  String get waitFor; // event name
  String? get correlation; // expression -> correlation key
  String? get timeout; // duration; required by validation
  String? get onTimeout; // node id; required by validation
  String? get output; // context key for the bound event
  List<String> get next;
  String? get condition;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitNodeImplCopyWith<_$WaitNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerNodeImplCopyWith<$Res>
    implements $DagNodeCopyWith<$Res> {
  factory _$$TimerNodeImplCopyWith(
          _$TimerNodeImpl value, $Res Function(_$TimerNodeImpl) then) =
      __$$TimerNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? delay,
      String? at,
      List<String> next,
      String? condition});
}

/// @nodoc
class __$$TimerNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$TimerNodeImpl>
    implements _$$TimerNodeImplCopyWith<$Res> {
  __$$TimerNodeImplCopyWithImpl(
      _$TimerNodeImpl _value, $Res Function(_$TimerNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? delay = freezed,
    Object? at = freezed,
    Object? next = null,
    Object? condition = freezed,
  }) {
    return _then(_$TimerNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      delay: freezed == delay
          ? _value.delay
          : delay // ignore: cast_nullable_to_non_nullable
              as String?,
      at: freezed == at
          ? _value.at
          : at // ignore: cast_nullable_to_non_nullable
              as String?,
      next: null == next
          ? _value._next
          : next // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TimerNodeImpl extends TimerNode {
  const _$TimerNodeImpl(
      {required this.id,
      this.delay,
      this.at,
      final List<String> next = const <String>[],
      this.condition})
      : _next = next,
        super._();

  @override
  final String id;
  @override
  final String? delay;
// duration, e.g. "2h"
  @override
  final String? at;
// cron
  final List<String> _next;
// cron
  @override
  @JsonKey()
  List<String> get next {
    if (_next is EqualUnmodifiableListView) return _next;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_next);
  }

  @override
  final String? condition;

  @override
  String toString() {
    return 'DagNode.timer(id: $id, delay: $delay, at: $at, next: $next, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.delay, delay) || other.delay == delay) &&
            (identical(other.at, at) || other.at == at) &&
            const DeepCollectionEquality().equals(other._next, _next) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, delay, at,
      const DeepCollectionEquality().hash(_next), condition);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerNodeImplCopyWith<_$TimerNodeImpl> get copyWith =>
      __$$TimerNodeImplCopyWithImpl<_$TimerNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return timer(id, delay, at, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return timer?.call(id, delay, at, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (timer != null) {
      return timer(id, delay, at, next, condition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return timer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return timer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (timer != null) {
      return timer(this);
    }
    return orElse();
  }
}

abstract class TimerNode extends DagNode {
  const factory TimerNode(
      {required final String id,
      final String? delay,
      final String? at,
      final List<String> next,
      final String? condition}) = _$TimerNodeImpl;
  const TimerNode._() : super._();

  @override
  String get id;
  String? get delay; // duration, e.g. "2h"
  String? get at; // cron
  List<String> get next;
  String? get condition;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerNodeImplCopyWith<_$TimerNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HumanNodeImplCopyWith<$Res>
    implements $DagNodeCopyWith<$Res> {
  factory _$$HumanNodeImplCopyWith(
          _$HumanNodeImpl value, $Res Function(_$HumanNodeImpl) then) =
      __$$HumanNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? assignTo,
      String? form,
      List<HumanOutcome> outcomes,
      String? timeout,
      String? condition});
}

/// @nodoc
class __$$HumanNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$HumanNodeImpl>
    implements _$$HumanNodeImplCopyWith<$Res> {
  __$$HumanNodeImplCopyWithImpl(
      _$HumanNodeImpl _value, $Res Function(_$HumanNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assignTo = freezed,
    Object? form = freezed,
    Object? outcomes = null,
    Object? timeout = freezed,
    Object? condition = freezed,
  }) {
    return _then(_$HumanNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assignTo: freezed == assignTo
          ? _value.assignTo
          : assignTo // ignore: cast_nullable_to_non_nullable
              as String?,
      form: freezed == form
          ? _value.form
          : form // ignore: cast_nullable_to_non_nullable
              as String?,
      outcomes: null == outcomes
          ? _value._outcomes
          : outcomes // ignore: cast_nullable_to_non_nullable
              as List<HumanOutcome>,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as String?,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HumanNodeImpl extends HumanNode {
  const _$HumanNodeImpl(
      {required this.id,
      this.assignTo,
      this.form,
      final List<HumanOutcome> outcomes = const <HumanOutcome>[],
      this.timeout,
      this.condition})
      : _outcomes = outcomes,
        super._();

  @override
  final String id;
  @override
  final String? assignTo;
// role
  @override
  final String? form;
  final List<HumanOutcome> _outcomes;
  @override
  @JsonKey()
  List<HumanOutcome> get outcomes {
    if (_outcomes is EqualUnmodifiableListView) return _outcomes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outcomes);
  }

  @override
  final String? timeout;
  @override
  final String? condition;

  @override
  String toString() {
    return 'DagNode.human(id: $id, assignTo: $assignTo, form: $form, outcomes: $outcomes, timeout: $timeout, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HumanNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assignTo, assignTo) ||
                other.assignTo == assignTo) &&
            (identical(other.form, form) || other.form == form) &&
            const DeepCollectionEquality().equals(other._outcomes, _outcomes) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, assignTo, form,
      const DeepCollectionEquality().hash(_outcomes), timeout, condition);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HumanNodeImplCopyWith<_$HumanNodeImpl> get copyWith =>
      __$$HumanNodeImplCopyWithImpl<_$HumanNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return human(id, assignTo, form, outcomes, timeout, condition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return human?.call(id, assignTo, form, outcomes, timeout, condition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (human != null) {
      return human(id, assignTo, form, outcomes, timeout, condition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return human(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return human?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (human != null) {
      return human(this);
    }
    return orElse();
  }
}

abstract class HumanNode extends DagNode {
  const factory HumanNode(
      {required final String id,
      final String? assignTo,
      final String? form,
      final List<HumanOutcome> outcomes,
      final String? timeout,
      final String? condition}) = _$HumanNodeImpl;
  const HumanNode._() : super._();

  @override
  String get id;
  String? get assignTo; // role
  String? get form;
  List<HumanOutcome> get outcomes;
  String? get timeout;
  String? get condition;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HumanNodeImplCopyWith<_$HumanNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ForeachNodeImplCopyWith<$Res>
    implements $DagNodeCopyWith<$Res> {
  factory _$$ForeachNodeImplCopyWith(
          _$ForeachNodeImpl value, $Res Function(_$ForeachNodeImpl) then) =
      __$$ForeachNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String items,
      List<String> body,
      ForeachMode mode,
      int? parallelism,
      List<String> next,
      String? condition});
}

/// @nodoc
class __$$ForeachNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$ForeachNodeImpl>
    implements _$$ForeachNodeImplCopyWith<$Res> {
  __$$ForeachNodeImplCopyWithImpl(
      _$ForeachNodeImpl _value, $Res Function(_$ForeachNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? body = null,
    Object? mode = null,
    Object? parallelism = freezed,
    Object? next = null,
    Object? condition = freezed,
  }) {
    return _then(_$ForeachNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value._body
          : body // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ForeachMode,
      parallelism: freezed == parallelism
          ? _value.parallelism
          : parallelism // ignore: cast_nullable_to_non_nullable
              as int?,
      next: null == next
          ? _value._next
          : next // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ForeachNodeImpl extends ForeachNode {
  const _$ForeachNodeImpl(
      {required this.id,
      required this.items,
      final List<String> body = const <String>[],
      this.mode = ForeachMode.seq,
      this.parallelism,
      final List<String> next = const <String>[],
      this.condition})
      : _body = body,
        _next = next,
        super._();

  @override
  final String id;
  @override
  final String items;
// expression -> collection
  final List<String> _body;
// expression -> collection
  @override
  @JsonKey()
  List<String> get body {
    if (_body is EqualUnmodifiableListView) return _body;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_body);
  }

// body subgraph entry node id(s)
  @override
  @JsonKey()
  final ForeachMode mode;
  @override
  final int? parallelism;
// when mode == parallel
  final List<String> _next;
// when mode == parallel
  @override
  @JsonKey()
  List<String> get next {
    if (_next is EqualUnmodifiableListView) return _next;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_next);
  }

  @override
  final String? condition;

  @override
  String toString() {
    return 'DagNode.foreach(id: $id, items: $items, body: $body, mode: $mode, parallelism: $parallelism, next: $next, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForeachNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.items, items) || other.items == items) &&
            const DeepCollectionEquality().equals(other._body, _body) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.parallelism, parallelism) ||
                other.parallelism == parallelism) &&
            const DeepCollectionEquality().equals(other._next, _next) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      items,
      const DeepCollectionEquality().hash(_body),
      mode,
      parallelism,
      const DeepCollectionEquality().hash(_next),
      condition);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForeachNodeImplCopyWith<_$ForeachNodeImpl> get copyWith =>
      __$$ForeachNodeImplCopyWithImpl<_$ForeachNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return foreach(id, items, body, mode, parallelism, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return foreach?.call(id, items, body, mode, parallelism, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (foreach != null) {
      return foreach(id, items, body, mode, parallelism, next, condition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return foreach(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return foreach?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (foreach != null) {
      return foreach(this);
    }
    return orElse();
  }
}

abstract class ForeachNode extends DagNode {
  const factory ForeachNode(
      {required final String id,
      required final String items,
      final List<String> body,
      final ForeachMode mode,
      final int? parallelism,
      final List<String> next,
      final String? condition}) = _$ForeachNodeImpl;
  const ForeachNode._() : super._();

  @override
  String get id;
  String get items; // expression -> collection
  List<String> get body; // body subgraph entry node id(s)
  ForeachMode get mode;
  int? get parallelism; // when mode == parallel
  List<String> get next;
  String? get condition;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForeachNodeImplCopyWith<_$ForeachNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SubjourneyNodeImplCopyWith<$Res>
    implements $DagNodeCopyWith<$Res> {
  factory _$$SubjourneyNodeImplCopyWith(_$SubjourneyNodeImpl value,
          $Res Function(_$SubjourneyNodeImpl) then) =
      __$$SubjourneyNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String journeyKey,
      int? journeyVersion,
      String? input,
      String? output,
      List<String> next,
      String? condition});
}

/// @nodoc
class __$$SubjourneyNodeImplCopyWithImpl<$Res>
    extends _$DagNodeCopyWithImpl<$Res, _$SubjourneyNodeImpl>
    implements _$$SubjourneyNodeImplCopyWith<$Res> {
  __$$SubjourneyNodeImplCopyWithImpl(
      _$SubjourneyNodeImpl _value, $Res Function(_$SubjourneyNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? journeyKey = null,
    Object? journeyVersion = freezed,
    Object? input = freezed,
    Object? output = freezed,
    Object? next = null,
    Object? condition = freezed,
  }) {
    return _then(_$SubjourneyNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      journeyKey: null == journeyKey
          ? _value.journeyKey
          : journeyKey // ignore: cast_nullable_to_non_nullable
              as String,
      journeyVersion: freezed == journeyVersion
          ? _value.journeyVersion
          : journeyVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      input: freezed == input
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String?,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      next: null == next
          ? _value._next
          : next // ignore: cast_nullable_to_non_nullable
              as List<String>,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SubjourneyNodeImpl extends SubjourneyNode {
  const _$SubjourneyNodeImpl(
      {required this.id,
      required this.journeyKey,
      this.journeyVersion,
      this.input,
      this.output,
      final List<String> next = const <String>[],
      this.condition})
      : _next = next,
        super._();

  @override
  final String id;
  @override
  final String journeyKey;
  @override
  final int? journeyVersion;
  @override
  final String? input;
  @override
  final String? output;
  final List<String> _next;
  @override
  @JsonKey()
  List<String> get next {
    if (_next is EqualUnmodifiableListView) return _next;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_next);
  }

  @override
  final String? condition;

  @override
  String toString() {
    return 'DagNode.subjourney(id: $id, journeyKey: $journeyKey, journeyVersion: $journeyVersion, input: $input, output: $output, next: $next, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubjourneyNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.journeyKey, journeyKey) ||
                other.journeyKey == journeyKey) &&
            (identical(other.journeyVersion, journeyVersion) ||
                other.journeyVersion == journeyVersion) &&
            (identical(other.input, input) || other.input == input) &&
            (identical(other.output, output) || other.output == output) &&
            const DeepCollectionEquality().equals(other._next, _next) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, journeyKey, journeyVersion,
      input, output, const DeepCollectionEquality().hash(_next), condition);

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubjourneyNodeImplCopyWith<_$SubjourneyNodeImpl> get copyWith =>
      __$$SubjourneyNodeImplCopyWithImpl<_$SubjourneyNodeImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return subjourney(
        id, journeyKey, journeyVersion, input, output, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return subjourney?.call(
        id, journeyKey, journeyVersion, input, output, next, condition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (subjourney != null) {
      return subjourney(
          id, journeyKey, journeyVersion, input, output, next, condition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return subjourney(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return subjourney?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
    TResult Function(TerminalNode value)? terminal,
    required TResult orElse(),
  }) {
    if (subjourney != null) {
      return subjourney(this);
    }
    return orElse();
  }
}

abstract class SubjourneyNode extends DagNode {
  const factory SubjourneyNode(
      {required final String id,
      required final String journeyKey,
      final int? journeyVersion,
      final String? input,
      final String? output,
      final List<String> next,
      final String? condition}) = _$SubjourneyNodeImpl;
  const SubjourneyNode._() : super._();

  @override
  String get id;
  String get journeyKey;
  int? get journeyVersion;
  String? get input;
  String? get output;
  List<String> get next;
  String? get condition;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubjourneyNodeImplCopyWith<_$SubjourneyNodeImpl> get copyWith =>
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
  $Res call(
      {String id, List<String> emit, String? action, TerminalStatus status});
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
    Object? status = null,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TerminalStatus,
    ));
  }
}

/// @nodoc

class _$TerminalNodeImpl extends TerminalNode {
  const _$TerminalNodeImpl(
      {required this.id,
      final List<String> emit = const <String>[],
      this.action,
      this.status = TerminalStatus.completed})
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

  @override
  final String? action;
  @override
  @JsonKey()
  final TerminalStatus status;

  @override
  String toString() {
    return 'DagNode.terminal(id: $id, emit: $emit, action: $action, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TerminalNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._emit, _emit) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id,
      const DeepCollectionEquality().hash(_emit), action, status);

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
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)
        task,
    required TResult Function(String id, List<BranchArm> arms,
            String? defaultNext, String? condition)
        branch,
    required TResult Function(
            String id, List<String> branches, String? condition)
        parallel,
    required TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)
        join,
    required TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)
        wait,
    required TResult Function(String id, String? delay, String? at,
            List<String> next, String? condition)
        timer,
    required TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)
        human,
    required TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)
        foreach,
    required TResult Function(String id, String journeyKey, int? journeyVersion,
            String? input, String? output, List<String> next, String? condition)
        subjourney,
    required TResult Function(
            String id, List<String> emit, String? action, TerminalStatus status)
        terminal,
  }) {
    return terminal(id, emit, action, status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult? Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult? Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult? Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult? Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult? Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult? Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult? Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult? Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult? Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
  }) {
    return terminal?.call(id, emit, action, status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String capability,
            String? operation,
            String? input,
            String? output,
            List<String> next,
            String? condition,
            String? onFailure,
            NodePolicies? policies,
            Compensation? compensation,
            bool optional)?
        task,
    TResult Function(String id, List<BranchArm> arms, String? defaultNext,
            String? condition)?
        branch,
    TResult Function(String id, List<String> branches, String? condition)?
        parallel,
    TResult Function(String id, List<String> joinOn, JoinPolicy policy,
            int? quorum, List<String> next, String? condition)?
        join,
    TResult Function(
            String id,
            String waitFor,
            String? correlation,
            String? timeout,
            String? onTimeout,
            String? output,
            List<String> next,
            String? condition)?
        wait,
    TResult Function(String id, String? delay, String? at, List<String> next,
            String? condition)?
        timer,
    TResult Function(String id, String? assignTo, String? form,
            List<HumanOutcome> outcomes, String? timeout, String? condition)?
        human,
    TResult Function(
            String id,
            String items,
            List<String> body,
            ForeachMode mode,
            int? parallelism,
            List<String> next,
            String? condition)?
        foreach,
    TResult Function(
            String id,
            String journeyKey,
            int? journeyVersion,
            String? input,
            String? output,
            List<String> next,
            String? condition)?
        subjourney,
    TResult Function(String id, List<String> emit, String? action,
            TerminalStatus status)?
        terminal,
    required TResult orElse(),
  }) {
    if (terminal != null) {
      return terminal(id, emit, action, status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskNode value) task,
    required TResult Function(BranchNode value) branch,
    required TResult Function(ParallelNode value) parallel,
    required TResult Function(JoinNode value) join,
    required TResult Function(WaitNode value) wait,
    required TResult Function(TimerNode value) timer,
    required TResult Function(HumanNode value) human,
    required TResult Function(ForeachNode value) foreach,
    required TResult Function(SubjourneyNode value) subjourney,
    required TResult Function(TerminalNode value) terminal,
  }) {
    return terminal(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskNode value)? task,
    TResult? Function(BranchNode value)? branch,
    TResult? Function(ParallelNode value)? parallel,
    TResult? Function(JoinNode value)? join,
    TResult? Function(WaitNode value)? wait,
    TResult? Function(TimerNode value)? timer,
    TResult? Function(HumanNode value)? human,
    TResult? Function(ForeachNode value)? foreach,
    TResult? Function(SubjourneyNode value)? subjourney,
    TResult? Function(TerminalNode value)? terminal,
  }) {
    return terminal?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskNode value)? task,
    TResult Function(BranchNode value)? branch,
    TResult Function(ParallelNode value)? parallel,
    TResult Function(JoinNode value)? join,
    TResult Function(WaitNode value)? wait,
    TResult Function(TimerNode value)? timer,
    TResult Function(HumanNode value)? human,
    TResult Function(ForeachNode value)? foreach,
    TResult Function(SubjourneyNode value)? subjourney,
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
      final String? action,
      final TerminalStatus status}) = _$TerminalNodeImpl;
  const TerminalNode._() : super._();

  @override
  String get id;
  List<String> get emit;
  String? get action;
  TerminalStatus get status;

  /// Create a copy of DagNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TerminalNodeImplCopyWith<_$TerminalNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
