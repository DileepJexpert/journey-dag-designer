/// THE single source of §7 DAG config output (Charter §7). The canonical config
/// JSON is the **shared contract** between this app's [ConfigSerializer] and the
/// orchestration ENGINE's loader: they must agree byte-for-byte.
///
/// Top-level shape (schema v2 / Charter §7):
/// ```json
/// {
///   "journeyKey": "loan-origination",
///   "version": 1,
///   "context": { "schemaRef": "loan-origination-context@1" },
///   "pools": { "finnone_pool": { "maxConcurrent": 20 } },
///   "startNodeId": "customer",
///   "nodes": [ { "id": "...", "type": "task", "capability": "...", ... } ],
///   "layout": { "customer": { "x": 80, "y": 200 } }
/// }
/// ```
///
/// We hand-emit so the wire shape is fully under our control. Field/array order
/// here is the contract — do not reorder lightly. Round-trip invariant:
/// `fromJson(toJson(dag)) == dag`.
library;

import 'dart:convert';

import '../models/branch_arm.dart';
import '../models/dag.dart';
import '../models/dag_node.dart';
import '../models/node_layout.dart';
import '../models/node_policies.dart';

class ConfigSerializer {
  const ConfigSerializer();

  /// DSL schema generation stamped into the config.
  static const int schemaVersion = 2;

  // ---------------------------------------------------------------------------
  // Dag -> JSON (canonical, stored)
  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson(Dag dag, {required String key, int version = 1}) {
    return {
      'journeyKey': key,
      'version': version,
      if (dag.contextSchemaRef != null)
        'context': {'schemaRef': dag.contextSchemaRef},
      if (dag.pools.isNotEmpty)
        'pools': {
          for (final e in dag.pools.entries)
            e.key: {'maxConcurrent': e.value.maxConcurrent},
        },
      'startNodeId': dag.startNodeId,
      'nodes': [for (final n in dag.nodes) _nodeToJson(n)],
      'layout': {
        for (final e in dag.layout.entries)
          e.key: {'x': e.value.x, 'y': e.value.y},
      },
    };
  }

  String toJsonString(Dag dag, {required String key, int version = 1}) =>
      const JsonEncoder.withIndent('  ')
          .convert(toJson(dag, key: key, version: version));

  Map<String, dynamic> _nodeToJson(DagNode node) {
    final base = <String, dynamic>{'id': node.id, 'type': node.typeName};
    if (node.condition != null) base['condition'] = node.condition;
    switch (node) {
      case TaskNode():
        base['capability'] = node.capability;
        if (node.operation != null) base['operation'] = node.operation;
        if (node.input != null) base['input'] = node.input;
        if (node.output != null) base['output'] = node.output;
        if (node.next.isNotEmpty) base['next'] = node.next;
        if (node.onFailure != null) base['onFailure'] = node.onFailure;
        if (node.policies != null && !node.policies!.isEmpty) {
          base['policies'] = _policiesToJson(node.policies!);
        }
        if (node.compensation != null) {
          base['compensation'] = {
            'operation': node.compensation!.operation,
            if (node.compensation!.input != null)
              'input': node.compensation!.input,
          };
        }
        if (node.optional) base['optional'] = true;
      case BranchNode():
        base['arms'] = [
          for (final a in node.arms) {'when': a.when, 'next': a.next},
        ];
        if (node.defaultNext != null) base['default'] = node.defaultNext;
      case ParallelNode():
        base['branches'] = node.branches;
      case JoinNode():
        base['joinOn'] = node.joinOn;
        base['policy'] = node.policy == JoinPolicy.quorum && node.quorum != null
            ? 'quorum(${node.quorum})'
            : node.policy.name;
        if (node.next.isNotEmpty) base['next'] = node.next;
      case WaitNode():
        base['waitFor'] = node.waitFor;
        if (node.correlation != null) base['correlation'] = node.correlation;
        if (node.timeout != null) base['timeout'] = node.timeout;
        if (node.onTimeout != null) base['onTimeout'] = node.onTimeout;
        if (node.output != null) base['output'] = node.output;
        if (node.next.isNotEmpty) base['next'] = node.next;
      case TimerNode():
        if (node.delay != null) base['delay'] = node.delay;
        if (node.at != null) base['at'] = node.at;
        if (node.next.isNotEmpty) base['next'] = node.next;
      case HumanNode():
        if (node.assignTo != null) base['assignTo'] = node.assignTo;
        if (node.form != null) base['form'] = node.form;
        base['outcomes'] = [
          for (final o in node.outcomes) {'value': o.value, 'next': o.next},
        ];
        if (node.timeout != null) base['timeout'] = node.timeout;
      case ForeachNode():
        base['items'] = node.items;
        base['body'] = node.body;
        base['mode'] =
            node.mode == ForeachMode.parallel && node.parallelism != null
                ? 'parallel(${node.parallelism})'
                : node.mode.name;
        if (node.next.isNotEmpty) base['next'] = node.next;
      case SubjourneyNode():
        base['journey'] = {
          'key': node.journeyKey,
          if (node.journeyVersion != null) 'version': node.journeyVersion,
        };
        if (node.input != null) base['input'] = node.input;
        if (node.output != null) base['output'] = node.output;
        if (node.next.isNotEmpty) base['next'] = node.next;
      case TerminalNode():
        if (node.action != null) base['action'] = node.action;
        if (node.emit.isNotEmpty) base['emit'] = node.emit;
        base['status'] = node.status.name;
    }
    return base;
  }

  Map<String, dynamic> _policiesToJson(NodePolicies p) {
    final m = <String, dynamic>{};
    if (p.retry != null) {
      m['retry'] = {
        'maxAttempts': p.retry!.maxAttempts,
        if (p.retry!.backoff != null)
          'backoff': {
            'type': p.retry!.backoff!.type,
            'base': p.retry!.backoff!.base,
            'max': p.retry!.backoff!.max,
          },
        if (p.retry!.jitter) 'jitter': true,
        if (p.retry!.retryOn.isNotEmpty) 'retryOn': p.retry!.retryOn,
      };
    }
    if (p.timeout != null) m['timeout'] = p.timeout!.duration;
    if (p.circuitBreaker != null) {
      m['circuitBreaker'] = {
        'failureThreshold': p.circuitBreaker!.failureThreshold,
        'openDuration': p.circuitBreaker!.openDuration,
        if (p.circuitBreaker!.halfOpenTrial != null)
          'halfOpenTrial': p.circuitBreaker!.halfOpenTrial,
      };
    }
    if (p.meter != null) {
      m['meter'] = {
        'pool': p.meter!.pool,
        if (p.meter!.maxConcurrent != null)
          'maxConcurrent': p.meter!.maxConcurrent,
      };
    }
    return m;
  }

  // ---------------------------------------------------------------------------
  // JSON -> Dag (load)
  // ---------------------------------------------------------------------------

  Dag fromJson(Map<String, dynamic> json) {
    final nodes = [
      for (final raw in (json['nodes'] as List? ?? const []))
        _nodeFromJson(raw as Map<String, dynamic>),
    ];
    final layout = <String, NodeLayout>{
      for (final e in (json['layout'] as Map? ?? const {}).entries)
        e.key as String: NodeLayout(
          x: (e.value['x'] as num).toDouble(),
          y: (e.value['y'] as num).toDouble(),
        ),
    };
    final pools = <String, PoolSpec>{
      for (final e in (json['pools'] as Map? ?? const {}).entries)
        e.key as String:
            PoolSpec(maxConcurrent: (e.value['maxConcurrent'] as num).toInt()),
    };
    return Dag(
      startNodeId: json['startNodeId'] as String,
      nodes: nodes,
      pools: pools,
      contextSchemaRef: (json['context'] as Map?)?['schemaRef'] as String?,
      layout: layout,
    );
  }

  Dag fromJsonString(String source) =>
      fromJson(jsonDecode(source) as Map<String, dynamic>);

  String keyOf(Map<String, dynamic> json) => json['journeyKey'] as String;

  int versionOf(Map<String, dynamic> json) => (json['version'] as num).toInt();

  DagNode _nodeFromJson(Map<String, dynamic> j) {
    final type = j['type'] as String;
    final id = j['id'] as String;
    final condition = j['condition'] as String?;
    switch (type) {
      case 'task':
        return DagNode.task(
          id: id,
          capability: j['capability'] as String,
          operation: j['operation'] as String?,
          input: j['input'] as String?,
          output: j['output'] as String?,
          next: _strs(j['next']),
          condition: condition,
          onFailure: j['onFailure'] as String?,
          policies: _policiesFromJson(j['policies'] as Map<String, dynamic>?),
          compensation: j['compensation'] == null
              ? null
              : Compensation(
                  operation: j['compensation']['operation'] as String,
                  input: j['compensation']['input'] as String?,
                ),
          optional: j['optional'] as bool? ?? false,
        );
      case 'branch':
        return DagNode.branch(
          id: id,
          condition: condition,
          arms: [
            for (final a in (j['arms'] as List? ?? const []))
              BranchArm(when: a['when'] as String, next: a['next'] as String),
          ],
          defaultNext: j['default'] as String?,
        );
      case 'parallel':
        return DagNode.parallel(
            id: id, condition: condition, branches: _strs(j['branches']));
      case 'join':
        final (policy, quorum) = _parseJoinPolicy(j['policy'] as String?);
        return DagNode.join(
          id: id,
          condition: condition,
          joinOn: _strs(j['joinOn']),
          policy: policy,
          quorum: quorum,
          next: _strs(j['next']),
        );
      case 'wait':
        return DagNode.wait(
          id: id,
          condition: condition,
          waitFor: j['waitFor'] as String,
          correlation: j['correlation'] as String?,
          timeout: j['timeout'] as String?,
          onTimeout: j['onTimeout'] as String?,
          output: j['output'] as String?,
          next: _strs(j['next']),
        );
      case 'timer':
        return DagNode.timer(
          id: id,
          condition: condition,
          delay: j['delay'] as String?,
          at: j['at'] as String?,
          next: _strs(j['next']),
        );
      case 'human':
        return DagNode.human(
          id: id,
          condition: condition,
          assignTo: j['assignTo'] as String?,
          form: j['form'] as String?,
          outcomes: [
            for (final o in (j['outcomes'] as List? ?? const []))
              HumanOutcome(
                  value: o['value'] as String, next: o['next'] as String),
          ],
          timeout: j['timeout'] as String?,
        );
      case 'foreach':
        final (mode, parallelism) = _parseForeachMode(j['mode'] as String?);
        return DagNode.foreach(
          id: id,
          condition: condition,
          items: j['items'] as String,
          body: _strs(j['body']),
          mode: mode,
          parallelism: parallelism,
          next: _strs(j['next']),
        );
      case 'subjourney':
        final journey = j['journey'] as Map<String, dynamic>? ?? const {};
        return DagNode.subjourney(
          id: id,
          condition: condition,
          journeyKey: journey['key'] as String,
          journeyVersion: (journey['version'] as num?)?.toInt(),
          input: j['input'] as String?,
          output: j['output'] as String?,
          next: _strs(j['next']),
        );
      case 'terminal':
        return DagNode.terminal(
          id: id,
          action: j['action'] as String?,
          emit: _strs(j['emit']),
          status: _terminalStatus(j['status'] as String?),
        );
      default:
        throw FormatException('Unknown node type "$type" for node "$id"');
    }
  }

  NodePolicies? _policiesFromJson(Map<String, dynamic>? j) {
    if (j == null) return null;
    RetryPolicy? retry;
    if (j['retry'] != null) {
      final r = j['retry'] as Map<String, dynamic>;
      retry = RetryPolicy(
        maxAttempts: (r['maxAttempts'] as num).toInt(),
        backoff: r['backoff'] == null
            ? null
            : BackoffSpec(
                type: r['backoff']['type'] as String? ?? 'exponential',
                base: r['backoff']['base'] as String,
                max: r['backoff']['max'] as String,
              ),
        jitter: r['jitter'] as bool? ?? false,
        retryOn: _strs(r['retryOn']),
      );
    }
    final cb = j['circuitBreaker'] as Map<String, dynamic>?;
    final meter = j['meter'] as Map<String, dynamic>?;
    return NodePolicies(
      retry: retry,
      timeout: j['timeout'] == null
          ? null
          : TimeoutPolicy(duration: j['timeout'] as String),
      circuitBreaker: cb == null
          ? null
          : CircuitBreakerPolicy(
              failureThreshold: (cb['failureThreshold'] as num).toDouble(),
              openDuration: cb['openDuration'] as String,
              halfOpenTrial: (cb['halfOpenTrial'] as num?)?.toInt(),
            ),
      meter: meter == null
          ? null
          : MeterPolicy(
              pool: meter['pool'] as String,
              maxConcurrent: (meter['maxConcurrent'] as num?)?.toInt(),
            ),
    );
  }

  static (JoinPolicy, int?) _parseJoinPolicy(String? raw) {
    if (raw == null) return (JoinPolicy.allOf, null);
    final m = RegExp(r'^quorum\((\d+)\)$').firstMatch(raw);
    if (m != null) return (JoinPolicy.quorum, int.parse(m.group(1)!));
    return switch (raw) {
      'anyOf' => (JoinPolicy.anyOf, null),
      'quorum' => (JoinPolicy.quorum, null),
      _ => (JoinPolicy.allOf, null),
    };
  }

  static (ForeachMode, int?) _parseForeachMode(String? raw) {
    if (raw == null) return (ForeachMode.seq, null);
    final m = RegExp(r'^parallel\((\d+)\)$').firstMatch(raw);
    if (m != null) return (ForeachMode.parallel, int.parse(m.group(1)!));
    return raw == 'parallel'
        ? (ForeachMode.parallel, null)
        : (ForeachMode.seq, null);
  }

  static TerminalStatus _terminalStatus(String? raw) => switch (raw) {
        'rejected' => TerminalStatus.rejected,
        'failed' => TerminalStatus.failed,
        _ => TerminalStatus.completed,
      };

  static List<String> _strs(dynamic v) =>
      v == null ? const [] : [for (final e in v as List) e as String];
}
