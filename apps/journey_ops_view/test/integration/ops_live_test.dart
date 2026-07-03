/// LIVE smoke against a REAL engine ops window on localhost:8082 — proves the
/// wire shapes parse and the token really gates. SELF-SKIPPING when the engine
/// isn't running, so `flutter test` stays green without infrastructure:
///
///   cd idfc-integration-platform && SFDC_EDGE_TOKEN=... OPS_API_TOKEN=dev-ops-token \
///     ./gradlew :orchestration:origination-journey:bootRun   # then rerun
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/data/http_ops_api.dart';
import 'package:journey_ops_view/data/ops_api.dart';

const _baseUrl = 'http://localhost:8082';
const _devToken = 'dev-ops-token';

Future<bool> _opsUp() async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 2);
  try {
    final req = await client
        .getUrl(Uri.parse('$_baseUrl/ops/runs'))
        .timeout(const Duration(seconds: 2));
    req.headers.set('X-Ops-Token', _devToken);
    req.headers.set('X-User-Id', 'ops-live-test');
    final res = await req.close().timeout(const Duration(seconds: 2));
    return res.statusCode == 200;
  } catch (_) {
    return false;
  } finally {
    client.close(force: true);
  }
}

void main() {
  late bool up;

  setUpAll(() async {
    up = await _opsUp();
  });

  test('lists runs over real HTTP (wire shapes parse)', () async {
    if (!up) {
      markTestSkipped('engine ops API not running on $_baseUrl — skipped');
      return;
    }
    final api = HttpOpsApi(
        baseUrl: _baseUrl, opsToken: _devToken, actorId: () => 'ops-live-test');
    final page = await api.runs(size: 5);
    expect(page.page, 0);
    expect(page.size, 5);
    expect(page.totalItems, greaterThanOrEqualTo(page.items.length));
  });

  test('exact search misses politely on a made-up id', () async {
    if (!up) {
      markTestSkipped('engine ops API not running on $_baseUrl — skipped');
      return;
    }
    final api = HttpOpsApi(
        baseUrl: _baseUrl, opsToken: _devToken, actorId: () => 'ops-live-test');
    expect(await api.search('no-such-id-ever'), isEmpty);
  });

  test('the ops token really gates: wrong token -> 401/403, never data',
      () async {
    if (!up) {
      markTestSkipped('engine ops API not running on $_baseUrl — skipped');
      return;
    }
    final api = HttpOpsApi(
        baseUrl: _baseUrl,
        opsToken: 'wrong-token',
        actorId: () => 'ops-live-test');
    try {
      await api.runs(size: 1);
      fail('wrong token must not be served');
    } on OpsApiException catch (e) {
      expect(e.statusCode, anyOf(401, 403));
    }
  });
}
