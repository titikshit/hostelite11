// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomImpl _$$RoomImplFromJson(Map<String, dynamic> json) => _$RoomImpl(
      id: json['id'] as String,
      hostelId: json['hostelId'] as String,
      number: json['number'] as String,
      capacity: (json['capacity'] as num?)?.toInt() ?? 1,
      allotted: (json['allotted'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RoomImplToJson(_$RoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostelId': instance.hostelId,
      'number': instance.number,
      'capacity': instance.capacity,
      'allotted': instance.allotted,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
