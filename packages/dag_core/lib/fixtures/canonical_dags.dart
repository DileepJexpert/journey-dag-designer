/// The CANONICAL journey DAGs in the §7 DSL shape — the artifacts the schema
/// lock (contract fixtures + engine loader test) is built on. Moved verbatim
/// from the Designer's seed data (D16: byte-identical serializer output); the
/// Designer's mock backend wraps these in Journey/versions, the emit tool
/// serializes them into `contract/`.
///
/// Capability keys mirror the REAL backend module names under
/// `idfc-integration-platform/capabilities/`.
library;

import '../domain/models/branch_arm.dart';
import '../domain/models/dag.dart';
import '../domain/models/dag_node.dart';
import '../domain/models/node_layout.dart';
import '../domain/models/node_policies.dart';

/// The loan-origination journey in the §7 DSL shape: capability+operation tasks,
/// a branch with a mandatory default, and a metered booking node with a
/// compensation operation (saga). Topology kept linear so the engine's full-flow
/// choreography runs it unchanged.
Dag seedLoanDag() => const Dag(
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
          compensation: Compensation(
              operation: 'reverseBooking', input: '{ loanId: context.loan.id }'),
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
        'n_kyc': NodeLayout(x: 260, y: 200),
        'n_bureau': NodeLayout(x: 440, y: 200),
        'n_score': NodeLayout(x: 620, y: 200),
        'n_decide': NodeLayout(x: 800, y: 200),
        'n_book': NodeLayout(x: 980, y: 120),
        'n_done': NodeLayout(x: 1160, y: 120),
        'n_reject': NodeLayout(x: 980, y: 300),
      },
    );

/// The payment-execution journey (third channel) in §7 shape: validate ->
/// branch(rail, with default) -> execute(IMPS|UPI|bill) -> confirm -> notify.
Dag seedPaymentDag() => const Dag(
      startNodeId: 'n_validate',
      contextSchemaRef: 'payment-execution-context@1',
      nodes: [
        DagNode.task(
            id: 'n_validate',
            capability: 'payments',
            operation: 'validate',
            output: 'context.validation',
            next: ['n_route']),
        DagNode.branch(id: 'n_route', arms: [
          BranchArm(when: "context.request.rail == 'IMPS'", next: 'n_imps'),
          BranchArm(
              when: "context.request.rail == 'UPI_MANDATE'", next: 'n_mandate'),
          BranchArm(when: "context.request.rail == 'BILL_PAY'", next: 'n_bill'),
        ], defaultNext: 'n_unsupported'),
        DagNode.task(
            id: 'n_imps',
            capability: 'payments',
            operation: 'executeImps',
            next: ['n_confirm']),
        DagNode.task(
            id: 'n_mandate',
            capability: 'payments',
            operation: 'executeMandate',
            next: ['n_confirm']),
        DagNode.task(
            id: 'n_bill',
            capability: 'payments',
            operation: 'executeBillPay',
            next: ['n_confirm']),
        DagNode.task(
            id: 'n_confirm',
            capability: 'payments',
            operation: 'confirm',
            output: 'context.confirmation',
            next: ['n_notify']),
        DagNode.terminal(
            id: 'n_notify', action: 'notify_channel', emit: ['PaymentExecuted']),
        DagNode.terminal(
            id: 'n_unsupported',
            status: TerminalStatus.rejected,
            action: 'notify_channel',
            emit: ['PaymentRailUnsupported']),
      ],
      layout: {
        'n_validate': NodeLayout(x: 80, y: 220),
        'n_route': NodeLayout(x: 280, y: 220),
        'n_imps': NodeLayout(x: 500, y: 100),
        'n_mandate': NodeLayout(x: 500, y: 220),
        'n_bill': NodeLayout(x: 500, y: 340),
        'n_confirm': NodeLayout(x: 720, y: 220),
        'n_notify': NodeLayout(x: 920, y: 220),
        'n_unsupported': NodeLayout(x: 500, y: 460),
      },
    );

/// autopay-setup: one task (setupAutopayLink) -> terminal (BRD §8).
Dag seedAutopaySetupDag() => const Dag(
      startNodeId: 'n_setup',
      contextSchemaRef: 'emandate-context@1',
      nodes: [
        DagNode.task(
            id: 'n_setup',
            capability: 'mandate',
            operation: 'setupAutopayLink',
            output: 'context.autopay',
            next: ['n_done']),
        DagNode.terminal(
            id: 'n_done', action: 'notify_channel', emit: ['AutopayLinkSent']),
      ],
      layout: {
        'n_setup': NodeLayout(x: 80, y: 160),
        'n_done': NodeLayout(x: 320, y: 160),
      },
    );

/// cancel: cancel task -> branch(found?) -> cancelled | not-found (BRD §8).
Dag seedCancelDag() => const Dag(
      startNodeId: 'n_cancel',
      contextSchemaRef: 'emandate-context@1',
      nodes: [
        DagNode.task(
            id: 'n_cancel',
            capability: 'mandate',
            operation: 'cancel',
            output: 'context.cancel',
            next: ['n_decide']),
        DagNode.branch(id: 'n_decide', arms: [
          BranchArm(when: 'context.cancel.found == true', next: 'n_done'),
        ], defaultNext: 'n_notFound'),
        DagNode.terminal(
            id: 'n_done', action: 'notify_channel', emit: ['MandateCancelled']),
        DagNode.terminal(
            id: 'n_notFound',
            status: TerminalStatus.rejected,
            action: 'notify_channel',
            emit: ['MandateNotFound']),
      ],
      layout: {
        'n_cancel': NodeLayout(x: 80, y: 200),
        'n_decide': NodeLayout(x: 320, y: 200),
        'n_done': NodeLayout(x: 560, y: 120),
        'n_notFound': NodeLayout(x: 560, y: 300),
      },
    );
