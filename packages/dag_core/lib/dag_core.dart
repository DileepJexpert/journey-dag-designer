/// dag_core — the shared DAG foundation both apps stand on (Ops View C.1):
/// §7 models + the schema-locked [ConfigSerializer], the canvas view, the
/// registry dio client + actor/token plumbing, the validation vocabulary, the
/// status color tokens, and the canonical contract fixtures.
library;

export 'canvas/dag_canvas_view.dart';
export 'core/error/failure.dart';
export 'core/network/api_exception.dart';
export 'core/network/dio_client.dart';
export 'domain/models/branch_arm.dart';
export 'domain/models/dag.dart';
export 'domain/models/dag_node.dart';
export 'domain/models/node_layout.dart';
export 'domain/models/node_policies.dart';
export 'domain/models/validation.dart';
export 'domain/services/config_serializer.dart';
export 'fixtures/canonical_dags.dart';
export 'fixtures/contract_fixtures.dart';
export 'theme/status_colors.dart';
