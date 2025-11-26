import 'package:freezed_annotation/freezed_annotation.dart';

part 'form.freezed.dart';
part 'form.g.dart';

@freezed
class HostelForm with _$HostelForm {
  const factory HostelForm({
    required String id,
    required String hostelId,
    required String title,
    String? description,
    @Default([]) List<Map<String, dynamic>> fields,
    String? createdBy,
    DateTime? createdAt,
  }) = _HostelForm;

  factory HostelForm.fromJson(Map<String, dynamic> json) =>
      _$HostelFormFromJson(json);
}

@freezed
class FormResponse with _$FormResponse {
  const factory FormResponse({
    required String id,
    required String formId,
    required String studentId,
    required Map<String, dynamic> response,
    @Default('Pending') String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FormResponse;

  factory FormResponse.fromJson(Map<String, dynamic> json) =>
      _$FormResponseFromJson(json);
}
