/// Persisted canvas position for a node. Pan/zoom is view-only and NOT persisted;
/// per-node coordinates ARE (build doc §7).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_layout.freezed.dart';

@freezed
class NodeLayout with _$NodeLayout {
  const factory NodeLayout({
    required double x,
    required double y,
  }) = _NodeLayout;
}
