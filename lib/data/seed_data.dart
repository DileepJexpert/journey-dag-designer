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
  Capability(
      key: 'payments',
      name: 'Payments',
      domain: 'Payments',
      isMoneyOrBookingNode: true),
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
          note: 'Initial published journey',
        ),
      ],
      activeVersion: 1,
    );
