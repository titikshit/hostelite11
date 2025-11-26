// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeeImpl _$$FeeImplFromJson(Map<String, dynamic> json) => _$FeeImpl(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      hostelId: json['hostelId'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String? ?? 'pending',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FeeImplToJson(_$FeeImpl instance) => <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'hostelId': instance.hostelId,
      'amount': instance.amount,
      'dueDate': instance.dueDate?.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
