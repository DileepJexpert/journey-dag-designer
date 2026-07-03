// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuditEntry {
  String get id => throw _privateConstructorUsedError;
  String get journeyId => throw _privateConstructorUsedError;
  int? get version => throw _privateConstructorUsedError;
  AuditAction get action => throw _privateConstructorUsedError;
  String get actorId => throw _privateConstructorUsedError;
  DateTime get at => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of AuditEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuditEntryCopyWith<AuditEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditEntryCopyWith<$Res> {
  factory $AuditEntryCopyWith(
          AuditEntry value, $Res Function(AuditEntry) then) =
      _$AuditEntryCopyWithImpl<$Res, AuditEntry>;
  @useResult
  $Res call(
      {String id,
      String journeyId,
      int? version,
      AuditAction action,
      String actorId,
      DateTime at,
      String? note});
}

/// @nodoc
class _$AuditEntryCopyWithImpl<$Res, $Val extends AuditEntry>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuditEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? journeyId = null,
    Object? version = freezed,
    Object? action = null,
    Object? actorId = null,
    Object? at = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      journeyId: null == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as AuditAction,
      actorId: null == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String,
      at: null == at
          ? _value.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditEntryImplCopyWith<$Res>
    implements $AuditEntryCopyWith<$Res> {
  factory _$$AuditEntryImplCopyWith(
          _$AuditEntryImpl value, $Res Function(_$AuditEntryImpl) then) =
      __$$AuditEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String journeyId,
      int? version,
      AuditAction action,
      String actorId,
      DateTime at,
      String? note});
}

/// @nodoc
class __$$AuditEntryImplCopyWithImpl<$Res>
    extends _$AuditEntryCopyWithImpl<$Res, _$AuditEntryImpl>
    implements _$$AuditEntryImplCopyWith<$Res> {
  __$$AuditEntryImplCopyWithImpl(
      _$AuditEntryImpl _value, $Res Function(_$AuditEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuditEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? journeyId = null,
    Object? version = freezed,
    Object? action = null,
    Object? actorId = null,
    Object? at = null,
    Object? note = freezed,
  }) {
    return _then(_$AuditEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      journeyId: null == journeyId
          ? _value.journeyId
          : journeyId // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as AuditAction,
      actorId: null == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String,
      at: null == at
          ? _value.at
          : at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuditEntryImpl implements _AuditEntry {
  const _$AuditEntryImpl(
      {required this.id,
      required this.journeyId,
      this.version,
      required this.action,
      required this.actorId,
      required this.at,
      this.note});

  @override
  final String id;
  @override
  final String journeyId;
  @override
  final int? version;
  @override
  final AuditAction action;
  @override
  final String actorId;
  @override
  final DateTime at;
  @override
  final String? note;

  @override
  String toString() {
    return 'AuditEntry(id: $id, journeyId: $journeyId, version: $version, action: $action, actorId: $actorId, at: $at, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.journeyId, journeyId) ||
                other.journeyId == journeyId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.at, at) || other.at == at) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, journeyId, version, action, actorId, at, note);

  /// Create a copy of AuditEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditEntryImplCopyWith<_$AuditEntryImpl> get copyWith =>
      __$$AuditEntryImplCopyWithImpl<_$AuditEntryImpl>(this, _$identity);
}

abstract class _AuditEntry implements AuditEntry {
  const factory _AuditEntry(
      {required final String id,
      required final String journeyId,
      final int? version,
      required final AuditAction action,
      required final String actorId,
      required final DateTime at,
      final String? note}) = _$AuditEntryImpl;

  @override
  String get id;
  @override
  String get journeyId;
  @override
  int? get version;
  @override
  AuditAction get action;
  @override
  String get actorId;
  @override
  DateTime get at;
  @override
  String? get note;

  /// Create a copy of AuditEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuditEntryImplCopyWith<_$AuditEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
