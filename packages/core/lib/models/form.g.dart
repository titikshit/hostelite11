// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelFormImpl _$$HostelFormImplFromJson(Map<String, dynamic> json) =>
    _$HostelFormImpl(
      id: json['id'] as String,
      hostelId: json['hostelId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$HostelFormImplToJson(_$HostelFormImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostelId': instance.hostelId,
      'title': instance.title,
      'description': instance.description,
      'fields': instance.fields,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$FormResponseImpl _$$FormResponseImplFromJson(Map<String, dynamic> json) =>
    _$FormResponseImpl(
      id: json['id'] as String,
      formId: json['formId'] as String,
      studentId: json['studentId'] as String,
      response: json['response'] as Map<String, dynamic>,
      status: json['status'] as String? ?? 'Pending',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FormResponseImplToJson(_$FormResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formId': instance.formId,
      'studentId': instance.studentId,
      'response': instance.response,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
