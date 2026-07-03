/// [JourneyRepository] over the journey-registry REST API (A1) — the live seam:
/// what this repository publishes is what the engine runs. One method per
/// endpoint, 1:1 with the registry's RegistryController; the §7 config travels
/// as real JSON via [ConfigSerializer] (the same artifact the engine loads,
/// layout included so the canvas round-trips).
///
/// Identity: the registry rewrites `journeyKey`/`version` server-side (anti-
/// spoof) and enforces maker-checker on the X-User-Id header the dio client
/// attaches — failures come back as typed [Failure]s via [mapDioError]
/// (401 token/actor, 403 self-approve, 404, 409 lifecycle, 422 validation with
/// designer-vocabulary issues).
library;

import 'package:dio/dio.dart';

import 'package:dag_core/dag_core.dart';
import '../../domain/models/journey.dart';
import '../../domain/repositories/journey_repository.dart';

class HttpJourneyRepository implements JourneyRepository {
  HttpJourneyRepository({required Dio dio, ConfigSerializer? serializer})
      : _dio = dio,
        _serializer = serializer ?? const ConfigSerializer();

  final Dio _dio;
  final ConfigSerializer _serializer;

  // ---- journeys --------------------------------------------------------------

  @override
  Future<List<Journey>> listJourneys({
    String? businessLine,
    String? product,
    String? partner,
  }) =>
      _call(() async {
        final res = await _dio.get<List<dynamic>>('/api/v1/journeys',
            queryParameters: {
              if (businessLine != null) 'businessLine': businessLine,
              if (product != null) 'product': product,
              if (partner != null) 'partner': partner,
            });
        // List view: version metadata only (configs are null in list DTOs) —
        // enough for the journeys screen; the editor loads via getJourney.
        return [
          for (final j in res.data ?? const [])
            _journeyFromWire(j as Map<String, dynamic>, withDags: false),
        ];
      });

  @override
  Future<Journey> getJourney(String id) => _call(() async {
        final res = await _dio.get<Map<String, dynamic>>('/api/v1/journeys/$id');
        final journey = _journeyFromWire(res.data!, withDags: false);
        // The editor works off journey.versions[*].dag — hydrate each version's
        // config with parallel single-version GETs (journeys have few versions;
        // the list DTO deliberately omits configs).
        final hydrated = await Future.wait([
          for (final v in journey.versions)
            _dio
                .get<Map<String, dynamic>>(
                    '/api/v1/journeys/$id/versions/${v.version}')
                .then((r) => _versionFromWire(r.data!)),
        ]);
        return journey.copyWith(versions: hydrated);
      });

  @override
  Future<Journey> createJourney({
    required String key,
    required String name,
    String? businessLine,
    String? product,
    String? partner,
  }) =>
      _call(() async {
        final res = await _dio.post<Map<String, dynamic>>('/api/v1/journeys',
            data: {
              'key': key,
              'name': name,
              'businessLine': businessLine,
              'product': product,
              'partner': partner,
            });
        return _journeyFromWire(res.data!, withDags: true);
      });

  // ---- versions (maker) --------------------------------------------------------

  @override
  Future<Dag> getVersionDag(String journeyId, int version) => _call(() async {
        final res = await _dio.get<Map<String, dynamic>>(
            '/api/v1/journeys/$journeyId/versions/$version');
        return _dagFromWire(res.data!) ??
            (throw StateError('version $version of $journeyId has no config'));
      });

  @override
  Future<JourneyVersion> createDraft(String journeyId, Dag dag, {String? note}) =>
      _call(() async {
        final res = await _dio.post<Map<String, dynamic>>(
            '/api/v1/journeys/$journeyId/versions',
            data: _draftBody(journeyId, dag, note));
        return _versionFromWire(res.data!);
      });

  @override
  Future<JourneyVersion> saveDraft(String journeyId, int version, Dag dag,
          {String? note}) =>
      _call(() async {
        final res = await _dio.put<Map<String, dynamic>>(
            '/api/v1/journeys/$journeyId/versions/$version',
            data: _draftBody(journeyId, dag, note, version: version));
        return _versionFromWire(res.data!);
      });

  @override
  Future<ValidationResult> validateOnServer(String journeyId, int version) =>
      _call(() async {
        final res = await _dio.post<Map<String, dynamic>>(
            '/api/v1/journeys/$journeyId/versions/$version/validate');
        return ValidationResult(issues: parseWireIssues(res.data));
      });

  @override
  Future<JourneyVersion> submitForApproval(String journeyId, int version) =>
      _lifecycle(journeyId, version, 'submit');

  // ---- versions (checker) --------------------------------------------------------

  @override
  Future<JourneyVersion> approve(String journeyId, int version) =>
      _lifecycle(journeyId, version, 'approve');

  @override
  Future<JourneyVersion> reject(String journeyId, int version, String comment) =>
      _call(() async {
        final res = await _dio.post<Map<String, dynamic>>(
            '/api/v1/journeys/$journeyId/versions/$version/reject',
            data: {'comment': comment});
        return _versionFromWire(res.data!);
      });

  Future<JourneyVersion> _lifecycle(String journeyId, int version, String action) =>
      _call(() async {
        final res = await _dio.post<Map<String, dynamic>>(
            '/api/v1/journeys/$journeyId/versions/$version/$action');
        return _versionFromWire(res.data!);
      });

  // ---- wire mapping ----------------------------------------------------------------

  Map<String, dynamic> _draftBody(String journeyId, Dag dag, String? note,
      {int version = 1}) {
    return {
      // The server stamps journeyKey/version authoritatively; these are echoes.
      'config': _serializer.toJson(dag, key: journeyId, version: version),
      if (note != null) 'note': note,
    };
  }

  Journey _journeyFromWire(Map<String, dynamic> j, {required bool withDags}) {
    final versions = [
      for (final v in (j['versions'] as List? ?? const []))
        _versionFromWire(v as Map<String, dynamic>),
    ];
    return Journey(
      id: j['id'] as String? ?? j['key'] as String,
      key: j['key'] as String,
      name: j['name'] as String? ?? j['key'] as String,
      businessLine: j['businessLine'] as String?,
      product: j['product'] as String?,
      partner: j['partner'] as String?,
      versions: versions,
      activeVersion: (j['activeVersion'] as num?)?.toInt(),
    );
  }

  JourneyVersion _versionFromWire(Map<String, dynamic> v) {
    return JourneyVersion(
      version: (v['version'] as num).toInt(),
      status: _statusFromWire(v['status'] as String?),
      dag: _dagFromWire(v) ?? const Dag(startNodeId: '', nodes: []),
      authorId: v['authorId'] as String? ?? '',
      approverId: v['approverId'] as String?,
      note: v['note'] as String?,
      updatedAt: DateTime.tryParse(v['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Dag? _dagFromWire(Map<String, dynamic> v) {
    final config = v['config'];
    if (config is! Map<String, dynamic>) return null;
    return _serializer.fromJson(config);
  }

  /// Wire statuses are the registry's camelCase names — the SAME vocabulary as
  /// [ApprovalStatus]. Unknown fails CLOSED to rejected-like visibility? No:
  /// unknown means a newer server; surface it loudly rather than mis-render.
  ApprovalStatus _statusFromWire(String? wire) {
    for (final s in ApprovalStatus.values) {
      if (s.name == wire) return s;
    }
    throw StateError("unknown version status '$wire' from the registry — "
        'update the designer (vocabulary drift)');
  }

  /// Every call maps DioException -> typed [Failure]; everything else bubbles.
  Future<T> _call<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
