// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RunStep {
  /// 0-based ordinal of this parallel group within the run.
  int get order => throw _privateConstructorUsedError;

  /// Node ids that fire together in this group.
  List<String> get nodeIds => throw _privateConstructorUsedError;

  /// True if any node in this group carries a `meter` (backpressure note in UI).
  bool get hasMeter => throw _privateConstructorUsedError;

  /// Create a copy of RunStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RunStepCopyWith<RunStep> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RunStepCopyWith<$Res> {
  factory $RunStepCopyWith(RunStep value, $Res Function(RunStep) then) =
      _$RunStepCopyWithImpl<$Res, RunStep>;
  @useResult
  $Res call({int order, List<String> nodeIds, bool hasMeter});
}

/// @nodoc
class _$RunStepCopyWithImpl<$Res, $Val extends RunStep>
    implements $RunStepCopyWith<$Res> {
  _$RunStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RunStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? nodeIds = null,
    Object? hasMeter = null,
  }) {
    return _then(_value.copyWith(
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      nodeIds: null == nodeIds
          ? _value.nodeIds
          : nodeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasMeter: null == hasMeter
          ? _value.hasMeter
          : hasMeter // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RunStepImplCopyWith<$Res> implements $RunStepCopyWith<$Res> {
  factory _$$RunStepImplCopyWith(
          _$RunStepImpl value, $Res Function(_$RunStepImpl) then) =
      __$$RunStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int order, List<String> nodeIds, bool hasMeter});
}

/// @nodoc
class __$$RunStepImplCopyWithImpl<$Res>
    extends _$RunStepCopyWithImpl<$Res, _$RunStepImpl>
    implements _$$RunStepImplCopyWith<$Res> {
  __$$RunStepImplCopyWithImpl(
      _$RunStepImpl _value, $Res Function(_$RunStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of RunStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? nodeIds = null,
    Object? hasMeter = null,
  }) {
    return _then(_$RunStepImpl(
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      nodeIds: null == nodeIds
          ? _value._nodeIds
          : nodeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasMeter: null == hasMeter
          ? _value.hasMeter
          : hasMeter // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RunStepImpl implements _RunStep {
  const _$RunStepImpl(
      {required this.order,
      required final List<String> nodeIds,
      this.hasMeter = false})
      : _nodeIds = nodeIds;

  /// 0-based ordinal of this parallel group within the run.
  @override
  final int order;

  /// Node ids that fire together in this group.
  final List<String> _nodeIds;

  /// Node ids that fire together in this group.
  @override
  List<String> get nodeIds {
    if (_nodeIds is EqualUnmodifiableListView) return _nodeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodeIds);
  }

  /// True if any node in this group carries a `meter` (backpressure note in UI).
  @override
  @JsonKey()
  final bool hasMeter;

  @override
  String toString() {
    return 'RunStep(order: $order, nodeIds: $nodeIds, hasMeter: $hasMeter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RunStepImpl &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality().equals(other._nodeIds, _nodeIds) &&
            (identical(other.hasMeter, hasMeter) ||
                other.hasMeter == hasMeter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, order,
      const DeepCollectionEquality().hash(_nodeIds), hasMeter);

  /// Create a copy of RunStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RunStepImplCopyWith<_$RunStepImpl> get copyWith =>
      __$$RunStepImplCopyWithImpl<_$RunStepImpl>(this, _$identity);
}

abstract class _RunStep implements RunStep {
  const factory _RunStep(
      {required final int order,
      required final List<String> nodeIds,
      final bool hasMeter}) = _$RunStepImpl;

  /// 0-based ordinal of this parallel group within the run.
  @override
  int get order;

  /// Node ids that fire together in this group.
  @override
  List<String> get nodeIds;

  /// True if any node in this group carries a `meter` (backpressure note in UI).
  @override
  bool get hasMeter;

  /// Create a copy of RunStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RunStepImplCopyWith<_$RunStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SimulationPlan {
  List<RunStep> get steps => throw _privateConstructorUsedError;

  /// Node ids reached on a compensation (failure) path, if a failure was
  /// injected via the input form.
  List<String> get compensated => throw _privateConstructorUsedError;

  /// Create a copy of SimulationPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SimulationPlanCopyWith<SimulationPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimulationPlanCopyWith<$Res> {
  factory $SimulationPlanCopyWith(
          SimulationPlan value, $Res Function(SimulationPlan) then) =
      _$SimulationPlanCopyWithImpl<$Res, SimulationPlan>;
  @useResult
  $Res call({List<RunStep> steps, List<String> compensated});
}

/// @nodoc
class _$SimulationPlanCopyWithImpl<$Res, $Val extends SimulationPlan>
    implements $SimulationPlanCopyWith<$Res> {
  _$SimulationPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SimulationPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? steps = null,
    Object? compensated = null,
  }) {
    return _then(_value.copyWith(
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RunStep>,
      compensated: null == compensated
          ? _value.compensated
          : compensated // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SimulationPlanImplCopyWith<$Res>
    implements $SimulationPlanCopyWith<$Res> {
  factory _$$SimulationPlanImplCopyWith(_$SimulationPlanImpl value,
          $Res Function(_$SimulationPlanImpl) then) =
      __$$SimulationPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RunStep> steps, List<String> compensated});
}

/// @nodoc
class __$$SimulationPlanImplCopyWithImpl<$Res>
    extends _$SimulationPlanCopyWithImpl<$Res, _$SimulationPlanImpl>
    implements _$$SimulationPlanImplCopyWith<$Res> {
  __$$SimulationPlanImplCopyWithImpl(
      _$SimulationPlanImpl _value, $Res Function(_$SimulationPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of SimulationPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? steps = null,
    Object? compensated = null,
  }) {
    return _then(_$SimulationPlanImpl(
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RunStep>,
      compensated: null == compensated
          ? _value._compensated
          : compensated // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$SimulationPlanImpl extends _SimulationPlan {
  const _$SimulationPlanImpl(
      {final List<RunStep> steps = const <RunStep>[],
      final List<String> compensated = const <String>[]})
      : _steps = steps,
        _compensated = compensated,
        super._();

  final List<RunStep> _steps;
  @override
  @JsonKey()
  List<RunStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  /// Node ids reached on a compensation (failure) path, if a failure was
  /// injected via the input form.
  final List<String> _compensated;

  /// Node ids reached on a compensation (failure) path, if a failure was
  /// injected via the input form.
  @override
  @JsonKey()
  List<String> get compensated {
    if (_compensated is EqualUnmodifiableListView) return _compensated;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_compensated);
  }

  @override
  String toString() {
    return 'SimulationPlan(steps: $steps, compensated: $compensated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimulationPlanImpl &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            const DeepCollectionEquality()
                .equals(other._compensated, _compensated));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_steps),
      const DeepCollectionEquality().hash(_compensated));

  /// Create a copy of SimulationPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimulationPlanImplCopyWith<_$SimulationPlanImpl> get copyWith =>
      __$$SimulationPlanImplCopyWithImpl<_$SimulationPlanImpl>(
          this, _$identity);
}

abstract class _SimulationPlan extends SimulationPlan {
  const factory _SimulationPlan(
      {final List<RunStep> steps,
      final List<String> compensated}) = _$SimulationPlanImpl;
  const _SimulationPlan._() : super._();

  @override
  List<RunStep> get steps;

  /// Node ids reached on a compensation (failure) path, if a failure was
  /// injected via the input form.
  @override
  List<String> get compensated;

  /// Create a copy of SimulationPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimulationPlanImplCopyWith<_$SimulationPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
