/// The HTTP seam against a scripted dio adapter: every request carries the
/// service token + REAL actor header, the §7 config round-trips through the
/// wire, and the registry's status codes map to the typed [Failure]s the UI
/// acts on (401/403/404/409/422-with-issues — the designer vocabulary, parsed
/// leniently so a newer server never crashes the panel).
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dag_core/dag_core.dart';
import 'package:journey_dag_designer/data/repositories/http_journey_repository.dart';
import 'package:journey_dag_designer/domain/models/journey.dart';

import '../domain/fixtures.dart';

/// Scripted adapter: (METHOD path) -> (status, json body). Records requests so
/// header/body expectations read naturally.
class _StubAdapter implements HttpClientAdapter {
  final Map<String, (int, Object?)> _routes = {};
  final List<RequestOptions> requests = [];

  void on(String method, String path, int status, Object? body) {
    _routes['$method $path'] = (status, body);
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final route = _routes['${options.method} ${options.uri.path}'];
    if (route == null) {
      return ResponseBody.fromString(
          '{"error":"NOT_FOUND","message":"no stub for ${options.method} '
          '${options.uri.path}","issues":[]}',
          404,
          headers: _json);
    }
    final (status, body) = route;
    return ResponseBody.fromString(jsonEncode(body), status, headers: _json);
  }

  static final _json = {
    Headers.contentTypeHeader: ['application/json'],
  };

  @override
  void close({bool force = false}) {}
}

void main() {
  const serializer = ConfigSerializer();
  late _StubAdapter adapter;
  late HttpJourneyRepository repo;
  var actor = 'maker-asha';

  Map<String, dynamic> config({int version = 1}) =>
      serializer.toJson(canonicalLoanDag(), key: 'pl-express', version: version);

  Map<String, dynamic> versionWire(int version, String status,
          {bool withConfig = true, String author = 'maker-asha'}) =>
      {
        'journeyKey': 'pl-express',
        'version': version,
        'status': status,
        'authorId': author,
        'approverId': status == 'published' ? 'checker-vikram' : null,
        'note': null,
        'createdAt': '2026-07-02T10:00:00Z',
        'updatedAt': '2026-07-02T10:05:00Z',
        if (withConfig) 'config': config(version: version) else 'config': null,
      };

  setUp(() {
    adapter = _StubAdapter();
    actor = 'maker-asha';
    final dio = buildDio(
      actorId: () => actor,
      baseUrl: 'http://registry.test',
      registryToken: 'test-token',
    );
    dio.httpClientAdapter = adapter;
    repo = HttpJourneyRepository(dio: dio, serializer: serializer);
  });

  group('headers', () {
    test('every call carries the service token AND the real actor', () async {
      adapter.on('GET', '/api/v1/journeys', 200, []);
      await repo.listJourneys();

      final headers = adapter.requests.single.headers;
      expect(headers[RegistryHeaders.token], 'test-token');
      expect(headers[RegistryHeaders.actor], 'maker-asha');
    });

    test('an empty actor is OMITTED — the server 401s, nothing papers over it',
        () async {
      actor = '';
      adapter.on('GET', '/api/v1/journeys', 200, []);
      await repo.listJourneys();

      expect(adapter.requests.single.headers.containsKey(RegistryHeaders.actor),
          isFalse);
    });
  });

  group('wire mapping', () {
    test('getJourney hydrates every version dag via the single-version reads',
        () async {
      adapter.on('GET', '/api/v1/journeys/pl-express', 200, {
        'id': 'pl-express',
        'key': 'pl-express',
        'name': 'PL Express',
        'businessLine': 'PL',
        'activeVersion': 1,
        'versions': [
          versionWire(1, 'published', withConfig: false),
          versionWire(2, 'draft', withConfig: false),
        ],
      });
      adapter.on('GET', '/api/v1/journeys/pl-express/versions/1', 200,
          versionWire(1, 'published'));
      adapter.on('GET', '/api/v1/journeys/pl-express/versions/2', 200,
          versionWire(2, 'draft'));

      final journey = await repo.getJourney('pl-express');

      expect(journey.activeVersion, 1);
      expect(journey.versions, hasLength(2));
      expect(journey.versions[0].status, ApprovalStatus.published);
      expect(journey.versions[0].approverId, 'checker-vikram');
      expect(journey.versions[1].status, ApprovalStatus.draft);
      // The hydrated dag is the REAL §7 artifact, canvas layout included.
      expect(journey.versions[1].dag.startNodeId, 'n_customer');
      expect(journey.versions[1].dag.layout, isNotEmpty);
    });

    test('createDraft sends the §7 config and parses the created version',
        () async {
      adapter.on('POST', '/api/v1/journeys/pl-express/versions', 201,
          versionWire(3, 'draft'));

      final draft = await repo.createDraft('pl-express', canonicalLoanDag(),
          note: 'first cut');

      expect(draft.version, 3);
      expect(draft.status, ApprovalStatus.draft);
      // At the adapter layer dio still holds the ORIGINAL body object.
      final sent = adapter.requests.single.data as Map<String, dynamic>;
      expect(sent['note'], 'first cut');
      expect((sent['config'] as Map)['startNodeId'], 'n_customer');
      expect((sent['config'] as Map)['nodes'], isA<List<dynamic>>());
    });

    test('an unknown wire status is vocabulary drift and fails loudly',
        () async {
      adapter.on('POST', '/api/v1/journeys/pl-express/versions', 201,
          versionWire(3, 'archived'));

      await expectLater(repo.createDraft('pl-express', canonicalLoanDag()),
          throwsA(isA<StateError>()));
    });
  });

  group('registry error semantics', () {
    test('403 self-approve maps to ForbiddenFailure with the server message',
        () async {
      adapter.on('POST', '/api/v1/journeys/pl-express/versions/1/approve', 403, {
        'error': 'FORBIDDEN',
        'message': "maker-checker: author 'maker-asha' may not approve/reject"
            ' their own version',
        'issues': [],
      });

      await expectLater(
        repo.approve('pl-express', 1),
        throwsA(isA<ForbiddenFailure>()
            .having((f) => f.message, 'message', contains('maker-checker'))),
      );
    });

    test('409 second draft maps to ConflictFailure', () async {
      adapter.on('POST', '/api/v1/journeys/pl-express/versions', 409, {
        'error': 'CONFLICT',
        'message': "journey 'pl-express' already has an editable version (v2)",
        'issues': [],
      });

      await expectLater(
        repo.createDraft('pl-express', canonicalLoanDag()),
        throwsA(isA<ConflictFailure>()),
      );
    });

    test('404 and 401 map to NotFound / Unauthorized', () async {
      adapter.on('GET', '/api/v1/journeys/ghost', 404,
          {'error': 'NOT_FOUND', 'message': "no journey 'ghost'", 'issues': []});
      await expectLater(
          repo.getJourney('ghost'), throwsA(isA<NotFoundFailure>()));

      adapter.on('POST', '/api/v1/journeys/pl-express/versions/1/submit', 401, {
        'error': 'UNAUTHENTICATED',
        'message': 'X-User-Id header is required for this operation',
        'issues': [],
      });
      await expectLater(repo.submitForApproval('pl-express', 1),
          throwsA(isA<UnauthorizedFailure>()));
    });

    test('422 carries designer-vocabulary issues; unknown codes stay renderable',
        () async {
      adapter.on('POST', '/api/v1/journeys/pl-express/versions/1/submit', 422, {
        'error': 'VALIDATION_FAILED',
        'message': "journey 'pl-express' v1 fails validation",
        'issues': [
          {
            'code': 'danglingEdge',
            'severity': 'error',
            'message': "node 'a' points at missing node 'ghost'",
            'nodeId': 'a',
          },
          {
            'code': 'quantumFluxImbalance', // a future server rule
            'severity': 'warning',
            'message': 'from a registry newer than this build',
            'nodeId': null,
          },
        ],
      });

      await expectLater(
        repo.submitForApproval('pl-express', 1),
        throwsA(isA<ValidationFailure>().having((f) => f.issues, 'issues', [
          isA<ValidationIssue>()
              .having((i) => i.code, 'code', ValidationCode.danglingEdge)
              .having((i) => i.severity, 'severity', ValidationSeverity.error)
              .having((i) => i.nodeId, 'nodeId', 'a'),
          isA<ValidationIssue>()
              .having((i) => i.code, 'code', ValidationCode.serverRule)
              .having((i) => i.severity, 'severity', ValidationSeverity.warning),
        ])),
      );
    });

    test('validateOnServer parses a clean and a dirty result', () async {
      adapter.on('POST', '/api/v1/journeys/pl-express/versions/1/validate', 200,
          {'issues': []});
      expect((await repo.validateOnServer('pl-express', 1)).isValid, isTrue);

      adapter.on('POST', '/api/v1/journeys/pl-express/versions/2/validate', 200, {
        'issues': [
          {
            'code': 'branchNoDefault',
            'severity': 'error',
            'message': "branch 'b' has no default arm (§9.5)",
            'nodeId': 'b',
          },
        ],
      });
      final dirty = await repo.validateOnServer('pl-express', 2);
      expect(dirty.isValid, isFalse);
      expect(dirty.errors.single.code, ValidationCode.branchNoDefault);
    });
  });
}
