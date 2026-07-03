/// Seed data for the mock backend (Charter §1, §7). Lets the app run end-to-end
/// before the registry backend exists.
///
/// IMPORTANT (frontend<->backend alignment): capability keys mirror the REAL
/// backend module names under `idfc-integration-platform/capabilities/`:
/// bureau, customer-party, kyc, lending-origination, lending-servicing,
/// payments, scoring. These journeys are authored in the §7 DSL shape (the
/// canonical contract the engine loads).
library;

// The canonical §7 DAGs (seedLoanDag & friends) live in dag_core's
// fixtures — shared with the contract lock and the Ops View.

import 'package:dag_core/dag_core.dart';

import '../domain/models/capability.dart';
import '../domain/models/journey.dart';
import '../domain/models/scope_dimensions.dart';

/// Registered capabilities — keys == backend module names. Money/booking nodes
/// flagged so the validator can enforce compensation (§9.6).
const seedCapabilities = <Capability>[
  Capability(
      key: 'customer-party',
      name: 'Customer / Party',
      domain: 'Customer',
      operations: ['resolve']),
  Capability(key: 'kyc', name: 'KYC', domain: 'KYC', operations: ['verify']),
  Capability(key: 'bureau', name: 'Bureau', domain: 'Lending', operations: ['pull']),
  Capability(
      key: 'scoring',
      name: 'Scoring / Decisioning',
      domain: 'Lending',
      operations: ['decide']),
  Capability(
      key: 'lending-origination',
      name: 'Lending Origination (booking)',
      domain: 'Lending',
      isMoneyOrBookingNode: true,
      // hosts the brand device-financing validation adapter (BRD §5)
      operations: ['book', 'reverseBooking', 'validateDeviceFinancing']),
  Capability(
      key: 'lending-servicing',
      name: 'Lending Servicing',
      domain: 'Lending',
      operations: [
        'processMaturedLoan',
        'processClosedLoan',
        'processExcessAmount',
        'batchClosure',
        'getMaruti',
      ]),
  Capability(
      key: 'payments',
      name: 'Payments',
      domain: 'Payments',
      operations: ['validate', 'executeImps', 'executeMandate', 'executeBillPay', 'confirm']),
  Capability(
      key: 'mandate',
      name: 'Mandate (e-mandate lifecycle)',
      domain: 'Payments',
      operations: [
        'register',
        'verifyEnach',
        'setupAutopayLink',
        'cancel',
        'handleVendorCallback',
      ]),
  Capability(key: 'echo', name: 'Echo (framework demo)', operations: ['echo']),
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

// ---------------------------------------------------------------------------
// E-mandate journeys (BRD §8) — the two e-mandate flows authored as §7 config
// over the Mandate capability, NOT as services. This is the consolidation thesis
// in action: emandate-management collapses into Mandate capability + journey JSON.
// ---------------------------------------------------------------------------

Journey seedAutopaySetupJourney(DateTime now) => Journey(
      id: 'jr_emandate_autopay',
      key: 'emandate-autopay-setup',
      name: 'E-mandate Autopay Setup',
      businessLine: 'PAYMENTS',
      versions: [
        JourneyVersion(
          version: 1,
          status: ApprovalStatus.published,
          dag: seedAutopaySetupDag(),
          authorId: 'maker-1',
          approverId: 'checker-1',
          updatedAt: now,
          note: 'E-mandate autopay link setup (BRD §8)',
        ),
      ],
      activeVersion: 1,
    );

Journey seedCancelJourney(DateTime now) => Journey(
      id: 'jr_emandate_cancel',
      key: 'emandate-cancel',
      name: 'E-mandate Cancel',
      businessLine: 'PAYMENTS',
      versions: [
        JourneyVersion(
          version: 1,
          status: ApprovalStatus.published,
          dag: seedCancelDag(),
          authorId: 'maker-1',
          approverId: 'checker-1',
          updatedAt: now,
          note: 'E-mandate cancellation via CBS NACH (BRD §8)',
        ),
      ],
      activeVersion: 1,
    );
