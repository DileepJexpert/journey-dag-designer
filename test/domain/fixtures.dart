/// Shared test fixtures: the canonical loan-origination DAG from build doc §5
/// and the capability registry it references (real backend module names).
library;

import 'package:journey_dag_designer/domain/models/branch_arm.dart';
import 'package:journey_dag_designer/domain/models/capability.dart';
import 'package:journey_dag_designer/domain/models/dag.dart';
import 'package:journey_dag_designer/domain/models/dag_node.dart';
import 'package:journey_dag_designer/domain/models/node_layout.dart';

/// Capability registry keyed by the REAL backend module names
/// (capabilities/ in idfc-integration-platform). Note: scoring is `scoring`
/// (NOT "scoring-decisioning"), and the booking capability is
/// `lending-origination` (money/booking => requires compensation).
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

/// The §5 reference journey, exactly as documented:
/// customer -> kyc -> bureau -> scoring -> decide(branch) -> book | reject;
/// book -> done. `n_book` is metered + money-booking and declares a
/// compensation `n_reverse` — a terminal reachable only via the saga edge. This
/// DAG is fully valid.
Dag canonicalLoanDag() => const Dag(
      startNodeId: 'n_customer',
      nodes: [
        DagNode.task(
            id: 'n_customer', capabilityKey: 'customer-party', next: ['n_kyc']),
        DagNode.task(id: 'n_kyc', capabilityKey: 'kyc', next: ['n_bureau']),
        DagNode.task(id: 'n_bureau', capabilityKey: 'bureau', next: ['n_score']),
        DagNode.task(id: 'n_score', capabilityKey: 'scoring', next: ['n_decide']),
        DagNode.branch(id: 'n_decide', arms: [
          BranchArm(expression: "decision == 'APPROVED'", next: 'n_book'),
          BranchArm(expression: "decision == 'REJECTED'", next: 'n_reject'),
        ]),
        DagNode.task(
          id: 'n_book',
          capabilityKey: 'lending-origination',
          meter: 'finnone_pool',
          compensation: 'n_reverse',
          next: ['n_done'],
        ),
        DagNode.terminal(
            id: 'n_done', action: 'push_decision_to_channel', emit: ['LoanBooked']),
        DagNode.terminal(
            id: 'n_reject',
            action: 'push_decision_to_channel',
            emit: ['LoanRejected']),
        DagNode.terminal(
            id: 'n_reverse',
            action: 'reverse_booking',
            emit: ['BookingReversed']),
      ],
      layout: {
        'n_customer': NodeLayout(x: 80, y: 200),
        'n_kyc': NodeLayout(x: 240, y: 200),
      },
    );
