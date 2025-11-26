// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComplaintImpl _$$ComplaintImplFromJson(Map<String, dynamic> json) =>
    _$ComplaintImpl(
      id: json['id'] as String,
      hostelId: json['hostelId'] as String,
      studentId: json['studentId'] as String,
      roomNo: json['roomNo'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String,
      severity: json['severity'] as String? ?? 'Low',
      status: json['status'] as String? ?? 'open',
      attachmentUrl: json['attachmentUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ComplaintImplToJson(_$ComplaintImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostelId': instance.hostelId,
      'studentId': instance.studentId,
      'roomNo': instance.roomNo,
      'title': instance.title,
      'description': instance.description,
      'severity': instance.severity,
      'status': instance.status,
      'attachmentUrl': instance.attachmentUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
