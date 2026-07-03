/// Shared test fixtures: the canonical loan-origination DAG in the §7 DSL shape
/// and the capability registry it references (real backend module names).
library;

import 'package:dag_core/dag_core.dart';
import 'package:journey_dag_designer/domain/models/capability.dart';

/// Capability registry keyed by the REAL backend module names. `scoring` (not
/// "scoring-decisioning"); `lending-origination` is money/booking => requires
/// compensation.
final loanCapabilities = <Capability>[
  const Capability(key: 'customer-party', name: 'Customer / Party'),
  const Capability(key: 'kyc', name: 'KYC'),
  const Capability(key: 'bureau', name: 'Bureau'),
  const Capability(key: 'scoring', name: 'Scoring'),
  const Capability(
    key: 'lending-origination',
    name: 'Lending Origination',
    isMoneyOrBookingNode: true,
  ),
];

/// The §7 reference journey: customer -> kyc -> bureau -> scoring ->
/// decide(branch, with default) -> book | reject. `n_book` is metered + money,
/// so it declares a compensation operation (saga). Fully valid.
Dag canonicalLoanDag() => const Dag(
      startNodeId: 'n_customer',
      contextSchemaRef: 'loan-origination-context@1',
      pools: {'finnone_pool': PoolSpec(maxConcurrent: 20)},
      nodes: [
        DagNode.task(
            id: 'n_customer',
            capability: 'customer-party',
            operation: 'resolve',
            output: 'context.customer',
            next: ['n_kyc']),
        DagNode.task(
            id: 'n_kyc',
            capability: 'kyc',
            operation: 'verify',
            output: 'context.kyc',
            next: ['n_bureau']),
        DagNode.task(
            id: 'n_bureau',
            capability: 'bureau',
            operation: 'pull',
            output: 'context.bureau',
            next: ['n_score']),
        DagNode.task(
            id: 'n_score',
            capability: 'scoring',
            operation: 'decide',
            output: 'context.scoring',
            next: ['n_decide']),
        DagNode.branch(id: 'n_decide', arms: [
          BranchArm(
              when: "context.scoring.decision == 'APPROVED'", next: 'n_book'),
        ], defaultNext: 'n_reject'),
        DagNode.task(
          id: 'n_book',
          capability: 'lending-origination',
          operation: 'book',
          output: 'context.loan',
          policies: NodePolicies(meter: MeterPolicy(pool: 'finnone_pool')),
          compensation: Compensation(operation: 'reverseBooking'),
          onFailure: 'compensate',
          next: ['n_done'],
        ),
        DagNode.terminal(
            id: 'n_done',
            action: 'push_decision_to_channel',
            emit: ['LoanBooked']),
        DagNode.terminal(
            id: 'n_reject',
            status: TerminalStatus.rejected,
            action: 'push_decision_to_channel',
            emit: ['LoanRejected']),
      ],
      layout: {
        'n_customer': NodeLayout(x: 80, y: 200),
        'n_kyc': NodeLayout(x: 240, y: 200),
      },
    );
