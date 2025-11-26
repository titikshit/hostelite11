// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      hostelId: json['hostelId'] as String,
      roomNo: json['roomNo'] as String?,
      course: json['course'] as String?,
      year: json['year'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'role': instance.role,
      'hostelId': instance.hostelId,
      'roomNo': instance.roomNo,
      'course': instance.course,
      'year': instance.year,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
