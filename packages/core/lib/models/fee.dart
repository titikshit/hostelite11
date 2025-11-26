import 'package:freezed_annotation/freezed_annotation.dart';

part 'fee.freezed.dart';
part 'fee.g.dart';

@freezed
class Fee with _$Fee {
  const factory Fee({
    required String id,
    required String studentId,
    required String hostelId,
    required double amount,
    DateTime? dueDate,
    @Default('pending') String status,
    DateTime? createdAt,
  }) = _Fee;

  factory Fee.fromJson(Map<String, dynamic> json) => _$FeeFromJson(json);
}
