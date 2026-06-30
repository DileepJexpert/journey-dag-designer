/// Seed data for the mock backend (build doc §9 — "MockJourneyRepository
/// in-memory, seeded"). Lets the app run end-to-end before the registry backend
/// exists.
///
/// IMPORTANT (frontend<->backend alignment): capability keys mirror the REAL
/// backend module names under `idfc-integration-platform/capabilities/`:
/// bureau, customer-party, kyc, lending-origination, lending-servicing,
/// payments, scoring. The build doc §5 example used "scoring-decisioning" —
/// that is NOT a real module; the correct key is "scoring".
library;

import '../domain/models/branch_arm.dart';
import '../domain/models/capability.dart';
import '../domain/models/dag.dart';
import '../domain/models/dag_node.dart';
import '../domain/models/journey.dart';
import '../domain/models/node_layout.dart';
import '../domain/models/scope_dimensions.dart';

/// Registered capabilities — keys == backend module names (ownership domain set
/// where known). Money/booking nodes flagged so the validator can enforce
/// compensation.
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
  // Payments is a ROUTER over rail adapters (IMPS/BillDesk/Montran); IDFC owns no
  // money-movement SoR in this layer, so the capability node itself is not a
  // booking node (the rail settles). Reversal/compensation is a later refinement.
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

/// The §5 loan-origination DAG (with real capability keys).
Dag seedLoanDag() => const Dag(
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
        // Saga compensation for the booking node: if FinnOne booking fails, the
        // engine runs this to reverse it. Reachable only via n_book.compensation.
        DagNode.terminal(
            id: 'n_reverse', action: 'reverse_booking', emit: ['BookingReversed']),
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
        'n_reverse': NodeLayout(x: 1160, y: 300),
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
          note: 'Initial published journey',
        ),
      ],
      activeVersion: 1,
    );

/// The payment-execution journey — the THIRD channel shown as config-not-code
/// (DEMO_PAYMENTS_CONFIG_SHOWCASE): validate -> [branch: rail?] ->
/// execute (IMPS | UPI-mandate | bill-pay) -> confirm -> notify. Same engine,
/// same Designer; the rails are adapter choices inside the payments capability.
Dag seedPaymentDag() => const Dag(
      startNodeId: 'n_validate',
      nodes: [
        DagNode.task(
            id: 'n_validate', capabilityKey: 'payments', next: ['n_route']),
        DagNode.branch(id: 'n_route', arms: [
          BranchArm(expression: "rail == 'IMPS'", next: 'n_imps'),
          BranchArm(expression: "rail == 'UPI_MANDATE'", next: 'n_mandate'),
          BranchArm(expression: "rail == 'BILL_PAY'", next: 'n_bill'),
        ]),
        DagNode.task(id: 'n_imps', capabilityKey: 'payments', next: ['n_confirm']),
        DagNode.task(
            id: 'n_mandate', capabilityKey: 'payments', next: ['n_confirm']),
        DagNode.task(id: 'n_bill', capabilityKey: 'payments', next: ['n_confirm']),
        DagNode.task(
            id: 'n_confirm', capabilityKey: 'payments', next: ['n_notify']),
        DagNode.terminal(
            id: 'n_notify', action: 'notify_channel', emit: ['PaymentExecuted']),
      ],
      layout: {
        'n_validate': NodeLayout(x: 80, y: 220),
        'n_route': NodeLayout(x: 280, y: 220),
        'n_imps': NodeLayout(x: 500, y: 100),
        'n_mandate': NodeLayout(x: 500, y: 220),
        'n_bill': NodeLayout(x: 500, y: 340),
        'n_confirm': NodeLayout(x: 720, y: 220),
        'n_notify': NodeLayout(x: 920, y: 220),
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
