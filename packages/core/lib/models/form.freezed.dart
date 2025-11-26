// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HostelForm _$HostelFormFromJson(Map<String, dynamic> json) {
  return _HostelForm.fromJson(json);
}

/// @nodoc
mixin _$HostelForm {
  String get id => throw _privateConstructorUsedError;
  String get hostelId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get fields => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HostelForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HostelForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HostelFormCopyWith<HostelForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostelFormCopyWith<$Res> {
  factory $HostelFormCopyWith(
          HostelForm value, $Res Function(HostelForm) then) =
      _$HostelFormCopyWithImpl<$Res, HostelForm>;
  @useResult
  $Res call(
      {String id,
      String hostelId,
      String title,
      String? description,
      List<Map<String, dynamic>> fields,
      String? createdBy,
      DateTime? createdAt});
}

/// @nodoc
class _$HostelFormCopyWithImpl<$Res, $Val extends HostelForm>
    implements $HostelFormCopyWith<$Res> {
  _$HostelFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HostelForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostelId = null,
    Object? title = null,
    Object? description = freezed,
    Object? fields = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      fields: null == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HostelFormImplCopyWith<$Res>
    implements $HostelFormCopyWith<$Res> {
  factory _$$HostelFormImplCopyWith(
          _$HostelFormImpl value, $Res Function(_$HostelFormImpl) then) =
      __$$HostelFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String hostelId,
      String title,
      String? description,
      List<Map<String, dynamic>> fields,
      String? createdBy,
      DateTime? createdAt});
}

/// @nodoc
class __$$HostelFormImplCopyWithImpl<$Res>
    extends _$HostelFormCopyWithImpl<$Res, _$HostelFormImpl>
    implements _$$HostelFormImplCopyWith<$Res> {
  __$$HostelFormImplCopyWithImpl(
      _$HostelFormImpl _value, $Res Function(_$HostelFormImpl) _then)
      : super(_value, _then);

  /// Create a copy of HostelForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostelId = null,
    Object? title = null,
    Object? description = freezed,
    Object? fields = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$HostelFormImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      fields: null == fields
          ? _value._fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostelFormImpl implements _HostelForm {
  const _$HostelFormImpl(
      {required this.id,
      required this.hostelId,
      required this.title,
      this.description,
      final List<Map<String, dynamic>> fields = const [],
      this.createdBy,
      this.createdAt})
      : _fields = fields;

  factory _$HostelFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostelFormImplFromJson(json);

  @override
  final String id;
  @override
  final String hostelId;
  @override
  final String title;
  @override
  final String? description;
  final List<Map<String, dynamic>> _fields;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get fields {
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fields);
  }

  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'HostelForm(id: $id, hostelId: $hostelId, title: $title, description: $description, fields: $fields, createdBy: $createdBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostelFormImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._fields, _fields) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, hostelId, title, description,
      const DeepCollectionEquality().hash(_fields), createdBy, createdAt);

  /// Create a copy of HostelForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostelFormImplCopyWith<_$HostelFormImpl> get copyWith =>
      __$$HostelFormImplCopyWithImpl<_$HostelFormImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostelFormImplToJson(
      this,
    );
  }
}

abstract class _HostelForm implements HostelForm {
  const factory _HostelForm(
      {required final String id,
      required final String hostelId,
      required final String title,
      final String? description,
      final List<Map<String, dynamic>> fields,
      final String? createdBy,
      final DateTime? createdAt}) = _$HostelFormImpl;

  factory _HostelForm.fromJson(Map<String, dynamic> json) =
      _$HostelFormImpl.fromJson;

  @override
  String get id;
  @override
  String get hostelId;
  @override
  String get title;
  @override
  String? get description;
  @override
  List<Map<String, dynamic>> get fields;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;

  /// Create a copy of HostelForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostelFormImplCopyWith<_$HostelFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FormResponse _$FormResponseFromJson(Map<String, dynamic> json) {
  return _FormResponse.fromJson(json);
}

/// @nodoc
mixin _$FormResponse {
  String get id => throw _privateConstructorUsedError;
  String get formId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  Map<String, dynamic> get response => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FormResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FormResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FormResponseCopyWith<FormResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormResponseCopyWith<$Res> {
  factory $FormResponseCopyWith(
          FormResponse value, $Res Function(FormResponse) then) =
      _$FormResponseCopyWithImpl<$Res, FormResponse>;
  @useResult
  $Res call(
      {String id,
      String formId,
      String studentId,
      Map<String, dynamic> response,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$FormResponseCopyWithImpl<$Res, $Val extends FormResponse>
    implements $FormResponseCopyWith<$Res> {
  _$FormResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FormResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formId = null,
    Object? studentId = null,
    Object? response = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      formId: null == formId
          ? _value.formId
          : formId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormResponseImplCopyWith<$Res>
    implements $FormResponseCopyWith<$Res> {
  factory _$$FormResponseImplCopyWith(
          _$FormResponseImpl value, $Res Function(_$FormResponseImpl) then) =
      __$$FormResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String formId,
      String studentId,
      Map<String, dynamic> response,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$FormResponseImplCopyWithImpl<$Res>
    extends _$FormResponseCopyWithImpl<$Res, _$FormResponseImpl>
    implements _$$FormResponseImplCopyWith<$Res> {
  __$$FormResponseImplCopyWithImpl(
      _$FormResponseImpl _value, $Res Function(_$FormResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FormResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formId = null,
    Object? studentId = null,
    Object? response = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FormResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      formId: null == formId
          ? _value.formId
          : formId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value._response
          : response // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormResponseImpl implements _FormResponse {
  const _$FormResponseImpl(
      {required this.id,
      required this.formId,
      required this.studentId,
      required final Map<String, dynamic> response,
      this.status = 'Pending',
      this.createdAt,
      this.updatedAt})
      : _response = response;

  factory _$FormResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String formId;
  @override
  final String studentId;
  final Map<String, dynamic> _response;
  @override
  Map<String, dynamic> get response {
    if (_response is EqualUnmodifiableMapView) return _response;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_response);
  }

  @override
  @JsonKey()
  final String status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FormResponse(id: $id, formId: $formId, studentId: $studentId, response: $response, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.formId, formId) || other.formId == formId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            const DeepCollectionEquality().equals(other._response, _response) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      formId,
      studentId,
      const DeepCollectionEquality().hash(_response),
      status,
      createdAt,
      updatedAt);

  /// Create a copy of FormResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormResponseImplCopyWith<_$FormResponseImpl> get copyWith =>
      __$$FormResponseImplCopyWithImpl<_$FormResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormResponseImplToJson(
      this,
    );
  }
}

abstract class _FormResponse implements FormResponse {
  const factory _FormResponse(
      {required final String id,
      required final String formId,
      required final String studentId,
      required final Map<String, dynamic> response,
      final String status,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$FormResponseImpl;

  factory _FormResponse.fromJson(Map<String, dynamic> json) =
      _$FormResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get formId;
  @override
  String get studentId;
  @override
  Map<String, dynamic> get response;
  @override
  String get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of FormResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormResponseImplCopyWith<_$FormResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
