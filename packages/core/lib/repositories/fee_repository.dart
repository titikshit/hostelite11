import '../models/fee.dart';
import '../services/supabase_service.dart';
import '../utils/case_converter.dart';

class FeeRepository {
  final _client = SupabaseService.client;

  Future<List<Fee>> fetchFeesByStudent(String studentId) async {
    final response = await _client
        .from('fees')
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((e) => Fee.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<List<Fee>> fetchFeesByHostel(String hostelId) async {
    final response = await _client
        .from('fees')
        .select()
        .eq('hostel_id', hostelId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((e) => Fee.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<void> createFee({
    required String studentId,
    required String hostelId,
    required double amount,
    DateTime? dueDate,
    String status = 'pending',
  }) async {
    await _client.from('fees').insert({
      'student_id': studentId,
      'hostel_id': hostelId,
      'amount': amount,
      'due_date': dueDate?.toIso8601String(),
      'status': status,
    });
  }

  Future<void> updateFeeStatus(String feeId, String status) async {
    await _client
        .from('fees')
        .update({'status': status})
        .eq('id', feeId);
  }

  Future<void> updateFee({
    required String id,
    double? amount,
    DateTime? dueDate,
    String? status,
  }) async {
    final updates = <String, dynamic>{};
    
    if (amount != null) updates['amount'] = amount;
    if (dueDate != null) updates['due_date'] = dueDate.toIso8601String();
    if (status != null) updates['status'] = status;
    
    if (updates.isNotEmpty) {
      await _client
          .from('fees')
          .update(updates)
          .eq('id', id);
    }
  }

  Future<void> deleteFee(String id) async {
    await _client
        .from('fees')
        .delete()
        .eq('id', id);
  }
}
