// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JourneyVersion {
  int get version => throw _privateConstructorUsedError;
  ApprovalStatus get status => throw _privateConstructorUsedError;
  Dag get dag => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;

  /// Set once a checker acts. Maker != checker: [approverId] must differ from
  /// [authorId] — enforced in UI (RoleGate) AND backend (403).
  String? get approverId => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of JourneyVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JourneyVersionCopyWith<JourneyVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JourneyVersionCopyWith<$Res> {
  factory $JourneyVersionCopyWith(
          JourneyVersion value, $Res Function(JourneyVersion) then) =
      _$JourneyVersionCopyWithImpl<$Res, JourneyVersion>;
  @useResult
  $Res call(
      {int version,
      ApprovalStatus status,
      Dag dag,
      String authorId,
      String? approverId,
      DateTime updatedAt,
      String? note});

  $DagCopyWith<$Res> get dag;
}

/// @nodoc
class _$JourneyVersionCopyWithImpl<$Res, $Val extends JourneyVersion>
    implements $JourneyVersionCopyWith<$Res> {
  _$JourneyVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JourneyVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? status = null,
    Object? dag = null,
    Object? authorId = null,
    Object? approverId = freezed,
    Object? updatedAt = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApprovalStatus,
      dag: null == dag
          ? _value.dag
          : dag // ignore: cast_nullable_to_non_nullable
              as Dag,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      approverId: freezed == approverId
          ? _value.approverId
          : approverId // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of JourneyVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DagCopyWith<$Res> get dag {
    return $DagCopyWith<$Res>(_value.dag, (value) {
      return _then(_value.copyWith(dag: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JourneyVersionImplCopyWith<$Res>
    implements $JourneyVersionCopyWith<$Res> {
  factory _$$JourneyVersionImplCopyWith(_$JourneyVersionImpl value,
          $Res Function(_$JourneyVersionImpl) then) =
      __$$JourneyVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int version,
      ApprovalStatus status,
      Dag dag,
      String authorId,
      String? approverId,
      DateTime updatedAt,
      String? note});

  @override
  $DagCopyWith<$Res> get dag;
}

/// @nodoc
class __$$JourneyVersionImplCopyWithImpl<$Res>
    extends _$JourneyVersionCopyWithImpl<$Res, _$JourneyVersionImpl>
    implements _$$JourneyVersionImplCopyWith<$Res> {
  __$$JourneyVersionImplCopyWithImpl(
      _$JourneyVersionImpl _value, $Res Function(_$JourneyVersionImpl) _then)
      : super(_value, _then);

  /// Create a copy of JourneyVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? status = null,
    Object? dag = null,
    Object? authorId = null,
    Object? approverId = freezed,
    Object? updatedAt = null,
    Object? note = freezed,
  }) {
    return _then(_$JourneyVersionImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApprovalStatus,
      dag: null == dag
          ? _value.dag
          : dag // ignore: cast_nullable_to_non_nullable
              as Dag,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      approverId: freezed == approverId
          ? _value.approverId
          : approverId // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$JourneyVersionImpl implements _JourneyVersion {
  const _$JourneyVersionImpl(
      {required this.version,
      required this.status,
      required this.dag,
      required this.authorId,
      this.approverId,
      required this.updatedAt,
      this.note});

  @override
  final int version;
  @override
  final ApprovalStatus status;
  @override
  final Dag dag;
  @override
  final String authorId;

  /// Set once a checker acts. Maker != checker: [approverId] must differ from
  /// [authorId] — enforced in UI (RoleGate) AND backend (403).
  @override
  final String? approverId;
  @override
  final DateTime updatedAt;
  @override
  final String? note;

  @override
  String toString() {
    return 'JourneyVersion(version: $version, status: $status, dag: $dag, authorId: $authorId, approverId: $approverId, updatedAt: $updatedAt, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JourneyVersionImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dag, dag) || other.dag == dag) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.approverId, approverId) ||
                other.approverId == approverId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, version, status, dag, authorId, approverId, updatedAt, note);

  /// Create a copy of JourneyVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JourneyVersionImplCopyWith<_$JourneyVersionImpl> get copyWith =>
      __$$JourneyVersionImplCopyWithImpl<_$JourneyVersionImpl>(
          this, _$identity);
}

abstract class _JourneyVersion implements JourneyVersion {
  const factory _JourneyVersion(
      {required final int version,
      required final ApprovalStatus status,
      required final Dag dag,
      required final String authorId,
      final String? approverId,
      required final DateTime updatedAt,
      final String? note}) = _$JourneyVersionImpl;

  @override
  int get version;
  @override
  ApprovalStatus get status;
  @override
  Dag get dag;
  @override
  String get authorId;

  /// Set once a checker acts. Maker != checker: [approverId] must differ from
  /// [authorId] — enforced in UI (RoleGate) AND backend (403).
  @override
  String? get approverId;
  @override
  DateTime get updatedAt;
  @override
  String? get note;

  /// Create a copy of JourneyVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JourneyVersionImplCopyWith<_$JourneyVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Journey {
  String get id => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // Scoping (build doc §0) — null = global template. NO tenant.
  String? get businessLine => throw _privateConstructorUsedError;
  String? get product => throw _privateConstructorUsedError;
  String? get partner => throw _privateConstructorUsedError;
  List<JourneyVersion> get versions => throw _privateConstructorUsedError;

  /// The currently published version number serving new runs, if any.
  int? get activeVersion => throw _privateConstructorUsedError;

  /// Create a copy of Journey
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JourneyCopyWith<Journey> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JourneyCopyWith<$Res> {
  factory $JourneyCopyWith(Journey value, $Res Function(Journey) then) =
      _$JourneyCopyWithImpl<$Res, Journey>;
  @useResult
  $Res call(
      {String id,
      String key,
      String name,
      String? businessLine,
      String? product,
      String? partner,
      List<JourneyVersion> versions,
      int? activeVersion});
}

/// @nodoc
class _$JourneyCopyWithImpl<$Res, $Val extends Journey>
    implements $JourneyCopyWith<$Res> {
  _$JourneyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Journey
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? name = null,
    Object? businessLine = freezed,
    Object? product = freezed,
    Object? partner = freezed,
    Object? versions = null,
    Object? activeVersion = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      businessLine: freezed == businessLine
          ? _value.businessLine
          : businessLine // ignore: cast_nullable_to_non_nullable
              as String?,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as String?,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String?,
      versions: null == versions
          ? _value.versions
          : versions // ignore: cast_nullable_to_non_nullable
              as List<JourneyVersion>,
      activeVersion: freezed == activeVersion
          ? _value.activeVersion
          : activeVersion // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JourneyImplCopyWith<$Res> implements $JourneyCopyWith<$Res> {
  factory _$$JourneyImplCopyWith(
          _$JourneyImpl value, $Res Function(_$JourneyImpl) then) =
      __$$JourneyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String key,
      String name,
      String? businessLine,
      String? product,
      String? partner,
      List<JourneyVersion> versions,
      int? activeVersion});
}

/// @nodoc
class __$$JourneyImplCopyWithImpl<$Res>
    extends _$JourneyCopyWithImpl<$Res, _$JourneyImpl>
    implements _$$JourneyImplCopyWith<$Res> {
  __$$JourneyImplCopyWithImpl(
      _$JourneyImpl _value, $Res Function(_$JourneyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Journey
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? name = null,
    Object? businessLine = freezed,
    Object? product = freezed,
    Object? partner = freezed,
    Object? versions = null,
    Object? activeVersion = freezed,
  }) {
    return _then(_$JourneyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      businessLine: freezed == businessLine
          ? _value.businessLine
          : businessLine // ignore: cast_nullable_to_non_nullable
              as String?,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as String?,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String?,
      versions: null == versions
          ? _value._versions
          : versions // ignore: cast_nullable_to_non_nullable
              as List<JourneyVersion>,
      activeVersion: freezed == activeVersion
          ? _value.activeVersion
          : activeVersion // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$JourneyImpl extends _Journey {
  const _$JourneyImpl(
      {required this.id,
      required this.key,
      required this.name,
      this.businessLine,
      this.product,
      this.partner,
      final List<JourneyVersion> versions = const <JourneyVersion>[],
      this.activeVersion})
      : _versions = versions,
        super._();

  @override
  final String id;
  @override
  final String key;
  @override
  final String name;
// Scoping (build doc §0) — null = global template. NO tenant.
  @override
  final String? businessLine;
  @override
  final String? product;
  @override
  final String? partner;
  final List<JourneyVersion> _versions;
  @override
  @JsonKey()
  List<JourneyVersion> get versions {
    if (_versions is EqualUnmodifiableListView) return _versions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_versions);
  }

  /// The currently published version number serving new runs, if any.
  @override
  final int? activeVersion;

  @override
  String toString() {
    return 'Journey(id: $id, key: $key, name: $name, businessLine: $businessLine, product: $product, partner: $partner, versions: $versions, activeVersion: $activeVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JourneyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.businessLine, businessLine) ||
                other.businessLine == businessLine) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.partner, partner) || other.partner == partner) &&
            const DeepCollectionEquality().equals(other._versions, _versions) &&
            (identical(other.activeVersion, activeVersion) ||
                other.activeVersion == activeVersion));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      key,
      name,
      businessLine,
      product,
      partner,
      const DeepCollectionEquality().hash(_versions),
      activeVersion);

  /// Create a copy of Journey
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JourneyImplCopyWith<_$JourneyImpl> get copyWith =>
      __$$JourneyImplCopyWithImpl<_$JourneyImpl>(this, _$identity);
}

abstract class _Journey extends Journey {
  const factory _Journey(
      {required final String id,
      required final String key,
      required final String name,
      final String? businessLine,
      final String? product,
      final String? partner,
      final List<JourneyVersion> versions,
      final int? activeVersion}) = _$JourneyImpl;
  const _Journey._() : super._();

  @override
  String get id;
  @override
  String get key;
  @override
  String
      get name; // Scoping (build doc §0) — null = global template. NO tenant.
  @override
  String? get businessLine;
  @override
  String? get product;
  @override
  String? get partner;
  @override
  List<JourneyVersion> get versions;

  /// The currently published version number serving new runs, if any.
  @override
  int? get activeVersion;

  /// Create a copy of Journey
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JourneyImplCopyWith<_$JourneyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
