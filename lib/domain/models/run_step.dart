/// One step of a simulated run (build doc §6 SimulationEngine, §1.7).
///
/// A [RunStep] is the set of nodes that fire together as one parallel group.
/// PREVIEW ONLY: the simulation models ORDER and STRUCTURE (which nodes fire, in
/// what parallel groups, down which branch) — never real capability behavior,
/// timing, or failures. It must never become a second execution engine.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_step.freezed.dart';

@freezed
class RunStep with _$RunStep {
  const factory RunStep({
    /// 0-based ordinal of this parallel group within the run.
    required int order,

    /// Node ids that fire together in this group.
    required List<String> nodeIds,

    /// True if any node in this group carries a `meter` (backpressure note in UI).
    @Default(false) bool hasMeter,
  }) = _RunStep;
}

/// The result of planning a simulated run.
@freezed
class SimulationPlan with _$SimulationPlan {
  const SimulationPlan._();

  const factory SimulationPlan({
    @Default(<RunStep>[]) List<RunStep> steps,

    /// Node ids reached on a compensation (failure) path, if a failure was
    /// injected via the input form.
    @Default(<String>[]) List<String> compensated,
  }) = _SimulationPlan;

  List<String> get firedOrder => [for (final s in steps) ...s.nodeIds];
}
