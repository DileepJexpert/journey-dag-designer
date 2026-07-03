/// DEMO + REFERENCE seed data for the legacy-patterns demo. Everything in this
/// file is demo scaffolding or a drawn reference — clearly labelled, never
/// production config:
///
/// - `device-financing` (PUBLISHED, runnable): the config-not-code proof. ONE
///   journey; per-brand behaviour (validate+block vs block-only, pass-logic
///   field path) lives in the demo capability's CONFIG ROWS on the platform
///   side, not in the DAG. Adding a brand = a config row + a vendor stub.
/// - `employee-lwd-update` (PUBLISHED, runnable): the per-record body of the
///   file-batch demo — the demo file edge starts ONE RUN PER CSV RECORD, so
///   per-record status/retry/DLQ ride the existing engine semantics.
/// - `reference-file-batch` (DRAFT, drawn NOT built): the full production
///   file-batch shape (SFTP edge → empty-check → foreach → per-record adapter
///   → email report). The `foreach` execution engine is census-gated (see
///   idfc-integration-platform docs/legacy-analysis-review.md §6/§8).
/// - `reference-sync-read` (DRAFT, drawn NOT built): where a sync read slots
///   IF journey-shaped; the blessed sync lane itself is call-and-return
///   without the engine — designed, not built.
library;

import 'package:dag_core/dag_core.dart';

import '../domain/models/journey.dart';

/// DEMO 1 — the brand-as-config device-financing journey (§7 shape, runnable).
/// The DAG never mentions a brand: `resolveBrand` returns the brand's CONFIG
/// ROW (validationRequired, auth type, pass-logic path) and the branch routes
/// on it. Samsung validates+blocks, Godrej blocks only — same drawing.
Dag demoDeviceFinancingDag() => const Dag(
      startNodeId: 'n_brand',
      contextSchemaRef: 'device-financing-context@1',
      nodes: [
        DagNode.task(
            id: 'n_brand',
            capability: 'device-financing',
            operation: 'resolveBrand',
            input: '{ brand: context.brand }',
            output: 'context.brandConfig',
            next: ['n_route']),
        DagNode.branch(id: 'n_route', arms: [
          BranchArm(
              when: 'context.brandConfig.validationRequired == true',
              next: 'n_validate'),
        ], defaultNext: 'n_block'),
        DagNode.task(
            id: 'n_validate',
            capability: 'device-financing',
            operation: 'validate',
            input: '{ brand: context.brand, deviceId: context.deviceId }',
            output: 'context.validation',
            next: ['n_vroute']),
        DagNode.branch(id: 'n_vroute', arms: [
          BranchArm(
              when: 'context.validation.approved == true', next: 'n_block'),
        ], defaultNext: 'n_reject'),
        DagNode.task(
            id: 'n_block',
            capability: 'device-financing',
            operation: 'block',
            input: '{ brand: context.brand, deviceId: context.deviceId }',
            output: 'context.block',
            next: ['n_decide']),
        DagNode.branch(id: 'n_decide', arms: [
          BranchArm(when: 'context.block.approved == true', next: 'n_approve'),
        ], defaultNext: 'n_reject'),
        DagNode.terminal(
            id: 'n_approve',
            action: 'push_decision_to_channel',
            emit: ['DeviceFinancingApproved']),
        DagNode.terminal(
            id: 'n_reject',
            status: TerminalStatus.rejected,
            action: 'push_decision_to_channel',
            emit: ['DeviceFinancingDeclined']),
      ],
      layout: {
        'n_brand': NodeLayout(x: 80, y: 200),
        'n_route': NodeLayout(x: 280, y: 200),
        'n_validate': NodeLayout(x: 480, y: 100),
        'n_vroute': NodeLayout(x: 680, y: 100),
        'n_block': NodeLayout(x: 680, y: 260),
        'n_decide': NodeLayout(x: 880, y: 200),
        'n_approve': NodeLayout(x: 1080, y: 120),
        'n_reject': NodeLayout(x: 1080, y: 300),
      },
    );

/// DEMO 2 — the per-record journey the demo file edge starts for each CSV row.
/// One record = one run: retry, failure classes, DLQ and the ops window all
/// apply per record, so one bad row never sinks the batch.
Dag demoEmployeeLwdDag() => const Dag(
      startNodeId: 'n_update',
      contextSchemaRef: 'employee-lwd-context@1',
      nodes: [
        DagNode.task(
            id: 'n_update',
            capability: 'fusion-hcm',
            operation: 'updateEmployee',
            input:
                '{ employeeId: context.employeeId, lastWorkingDay: context.lastWorkingDay }',
            output: 'context.fusion',
            next: ['n_done']),
        DagNode.terminal(
            id: 'n_done',
            action: 'push_decision_to_channel',
            emit: ['EmployeeLwdUpdated']),
      ],
      layout: {
        'n_update': NodeLayout(x: 120, y: 160),
        'n_done': NodeLayout(x: 400, y: 160),
      },
    );

/// REFERENCE (drawn, NOT built) — the production file-batch shape. The SFTP
/// edge (unbuilt, census-gated) parses the file into `context.batch`; the
/// journey empty-checks, fans records through a bounded parallel `foreach`
/// (execution engine unbuilt), and emails the result report.
Dag referenceFileBatchDag() => const Dag(
      startNodeId: 'n_emptyCheck',
      contextSchemaRef: 'file-batch-context@1',
      nodes: [
        DagNode.branch(id: 'n_emptyCheck', arms: [
          BranchArm(when: 'context.batch.empty == true', next: 'n_alertEmpty'),
        ], defaultNext: 'n_each'),
        DagNode.task(
            id: 'n_alertEmpty',
            capability: 'communications',
            operation: 'sendEmailReport',
            input: '{ batchId: context.batch.id, kind: s_emptyFileAlert }',
            next: ['n_doneEmpty']),
        DagNode.terminal(id: 'n_doneEmpty', emit: ['BatchEmptyAlerted']),
        DagNode.foreach(
            id: 'n_each',
            items: 'context.batch.records',
            body: ['n_updateRecord'],
            mode: ForeachMode.parallel,
            parallelism: 5,
            next: ['n_report']),
        DagNode.task(
            id: 'n_updateRecord',
            capability: 'fusion-hcm',
            operation: 'updateEmployee',
            input:
                '{ employeeId: item.employeeId, lastWorkingDay: item.lastWorkingDay }',
            output: 'item.result',
            optional: true), // a failed record marks itself, never the batch
        DagNode.task(
            id: 'n_report',
            capability: 'communications',
            operation: 'sendEmailReport',
            input: '{ batchId: context.batch.id, kind: s_resultsCsv }',
            next: ['n_done']),
        DagNode.terminal(id: 'n_done', emit: ['BatchProcessed']),
      ],
      layout: {
        'n_emptyCheck': NodeLayout(x: 80, y: 220),
        'n_alertEmpty': NodeLayout(x: 300, y: 80),
        'n_doneEmpty': NodeLayout(x: 560, y: 80),
        'n_each': NodeLayout(x: 320, y: 260),
        'n_updateRecord': NodeLayout(x: 560, y: 340),
        'n_report': NodeLayout(x: 620, y: 200),
        'n_done': NodeLayout(x: 860, y: 200),
      },
    );

/// REFERENCE (drawn, NOT built) — where a sync read WOULD slot if
/// journey-shaped. The blessed sync lane is call-and-return WITHOUT the
/// engine; this drawing exists for the honesty slide, not to run.
Dag referenceSyncReadDag() => const Dag(
      startNodeId: 'n_read',
      contextSchemaRef: 'sync-read-context@1',
      nodes: [
        DagNode.task(
            id: 'n_read',
            capability: 'fusion-hcm',
            operation: 'getEmployee',
            input: '{ employeeId: context.employeeId }',
            output: 'context.employee',
            next: ['n_done']),
        DagNode.terminal(
            id: 'n_done',
            action: 'return_to_caller',
            emit: ['EmployeeRead']),
      ],
      layout: {
        'n_read': NodeLayout(x: 120, y: 160),
        'n_done': NodeLayout(x: 400, y: 160),
      },
    );

// ---------------------------------------------------------------------------
// Journey wrappers
// ---------------------------------------------------------------------------

Journey seedDeviceFinancingJourney(DateTime now) => Journey(
      id: 'jr_demo_device_financing',
      key: 'device-financing',
      name: 'Device Financing (DEMO — brand-as-config)',
      businessLine: 'DEVICE_FINANCING',
      versions: [
        JourneyVersion(
          version: 1,
          status: ApprovalStatus.published,
          dag: demoDeviceFinancingDag(),
          authorId: 'maker-1',
          approverId: 'checker-1',
          updatedAt: now,
          note: 'DEMO: 26-brands-as-config proof — brands are config rows in '
              'the demo capability, never nodes. Vendors mocked.',
        ),
      ],
      activeVersion: 1,
    );

Journey seedEmployeeLwdJourney(DateTime now) => Journey(
      id: 'jr_demo_employee_lwd',
      key: 'employee-lwd-update',
      name: 'Employee LWD Update (DEMO — file-batch record)',
      businessLine: 'HR_DEMO',
      versions: [
        JourneyVersion(
          version: 1,
          status: ApprovalStatus.published,
          dag: demoEmployeeLwdDag(),
          authorId: 'maker-1',
          approverId: 'checker-1',
          updatedAt: now,
          note: 'DEMO: per-record body of the file-batch scaffold — the demo '
              'file edge starts one run per CSV record (Fusion mocked).',
        ),
      ],
      activeVersion: 1,
    );

Journey seedReferenceFileBatchJourney(DateTime now) => Journey(
      id: 'jr_ref_file_batch',
      key: 'reference-file-batch',
      name: 'REFERENCE — File batch (SFTP → foreach → email; NOT built)',
      businessLine: 'HR_DEMO',
      versions: [
        JourneyVersion(
          version: 1,
          status: ApprovalStatus.draft,
          dag: referenceFileBatchDag(),
          authorId: 'maker-1',
          updatedAt: now,
          note: 'REFERENCE ONLY (honesty slide): production file-batch shape. '
              'SFTP edge + foreach execution are census-gated — drawn here so '
              'the unbuilt pattern has a visible slot.',
        ),
      ],
    );

Journey seedReferenceSyncReadJourney(DateTime now) => Journey(
      id: 'jr_ref_sync_read',
      key: 'reference-sync-read',
      name: 'REFERENCE — Sync read lane (NOT built)',
      businessLine: 'HR_DEMO',
      versions: [
        JourneyVersion(
          version: 1,
          status: ApprovalStatus.draft,
          dag: referenceSyncReadDag(),
          authorId: 'maker-1',
          updatedAt: now,
          note: 'REFERENCE ONLY (honesty slide): sync reads are call-and-return '
              'WITHOUT the engine — the lane is designed, not built; this '
              'drawing shows where it slots.',
        ),
      ],
    );
