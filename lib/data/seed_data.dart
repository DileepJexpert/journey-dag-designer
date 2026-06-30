/// Seed data for the mock backend (Charter §1, §7). Lets the app run end-to-end
/// before the registry backend exists.
///
/// IMPORTANT (frontend<->backend alignment): capability keys mirror the REAL
/// backend module names under `idfc-integration-platform/capabilities/`:
/// bureau, customer-party, kyc, lending-origination, lending-servicing,
/// payments, scoring. These journeys are authored in the §7 DSL shape (the
/// canonical contract the engine loads).
library;

import '../domain/models/branch_arm.dart';
import '../domain/models/capability.dart';
import '../domain/models/dag.dart';
import '../domain/models/dag_node.dart';
import '../domain/models/journey.dart';
import '../domain/models/node_layout.dart';
import '../domain/models/node_policies.dart';
import '../domain/models/scope_dimensions.dart';

/// Registered capabilities — keys == backend module names. Money/booking nodes
/// flagged so the validator can enforce compensation (§9.6).
const seedCapabilities = <Capability>[
  Capability(key: 'customer-party', name: 'Customer / Party', domain: 'Customer'),
  Capability(key: 'kyc', name: 'KYC', domain: 'KYC'),
  Capability(key: 'bureau', name: 'Bureau', domain: 'Lending'),
  Capability(key: 'scoring', name: 'Scoring / Decisioning', domain: 'Lending'),
  Capability(
      key: 'lending-origination',
      name: 'Lending Origination (booking)',
      domain: 'Lending',
      isMoneyOrBookingNode: true),
  Capability(
      key: 'lending-servicing', name: 'Lending Servicing', domain: 'Lending'),
  Capability(key: 'payments', name: 'Payments', domain: 'Payments'),
];

/// businessLine codes == the SFDC edge `type` values.
const seedBusinessLines = <BusinessLine>[
  BusinessLine(code: 'PERSONAL_LOAN', label: 'Personal Loan'),
  BusinessLine(code: 'LAP', label: 'Loan Against Property'),
  BusinessLine(code: 'BUSINESS_LOAN', label: 'Business Loan'),
  BusinessLine(code: 'COMMERCIAL', label: 'Commercial'),
];

const seedProducts = <Product>[
  Product(code: 'ACEPL', label: 'ACE Personal Loan'),
  Product(code: 'LAS', label: 'Loan Against Securities'),
];

const seedPartners = <Partner>[
  Partner(code: 'CRED', label: 'CRED'),
  Partner(code: 'FLIPKART', label: 'Flipkart'),
  Partner(code: 'GROWW', label: 'Groww'),
  Partner(code: 'EBC', label: 'EBC'),
  Partner(code: 'ASIRVAD', label: 'Asirvad'),
];

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

Journey seedLoanJourney(DateTime now) => Journey(
      id: 'jr_loan',
      key: 'loan-origination',
      name: 'Loan Origination',
      businessLine: 'PERSONAL_LOAN',
      product: 'ACEPL',
      versions: [
        JourneyVersion(
          version: 1,
          status: ApprovalStatus.published,
          dag: seedLoanDag(),
          authorId: 'maker-1',
          approverId: 'checker-1',
          updatedAt: now,
          note: 'Initial published journey (§7 DSL)',
        ),
      ],
      activeVersion: 1,
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

Journey seedPaymentJourney(DateTime now) => Journey(
      id: 'jr_payment',
      key: 'payment-execution',
      name: 'Payment Execution',
      businessLine: 'PAYMENTS',
      versions: [
        JourneyVersion(
          version: 1,
          status: ApprovalStatus.published,
          dag: seedPaymentDag(),
          authorId: 'maker-1',
          approverId: 'checker-1',
          updatedAt: now,
          note: 'Config showcase — third channel (shown, not run live)',
        ),
      ],
      activeVersion: 1,
    );
