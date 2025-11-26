import 'package:freezed_annotation/freezed_annotation.dart';

part 'complaint.freezed.dart';
part 'complaint.g.dart';

@freezed
class Complaint with _$Complaint {
  const factory Complaint({
    required String id,
    required String hostelId,
    required String studentId,
    String? roomNo,
    String? title,
    required String description,
    @Default('Low') String severity,
    @Default('open') String status,
    String? attachmentUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Complaint;

  factory Complaint.fromJson(Map<String, dynamic> json) => _$ComplaintFromJson(json);
}
