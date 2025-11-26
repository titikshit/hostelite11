import '../models/complaint.dart';
import '../services/supabase_service.dart';
import '../utils/case_converter.dart';

class ComplaintRepository {
  final _client = SupabaseService.client;

  Future<List<Complaint>> fetchComplaintsByStudent(String studentId) async {
    final response = await _client
        .from('complaints')
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((e) => Complaint.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<List<Complaint>> fetchComplaintsByHostel(String hostelId) async {
    final response = await _client
        .from('complaints')
        .select()
        .eq('hostel_id', hostelId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((e) => Complaint.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<void> createComplaint({
    required String hostelId,
    required String studentId,
    String? roomNo,
    String? title,
    required String description,
    String severity = 'Low',
    String? attachmentUrl,
  }) async {
    await _client.from('complaints').insert({
      'hostel_id': hostelId,
      'student_id': studentId,
      'room_no': roomNo,
      'title': title,
      'description': description,
      'severity': severity,
      'attachment_url': attachmentUrl,
    });
  }

  Future<void> updateComplaintStatus(String complaintId, String status) async {
    await _client
        .from('complaints')
        .update({
          'status': status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', complaintId);
  }

  Future<void> updateComplaint({
    required String id,
    String? title,
    String? description,
    String? severity,
    String? status,
    String? attachmentUrl,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (severity != null) updates['severity'] = severity;
    if (status != null) updates['status'] = status;
    if (attachmentUrl != null) updates['attachment_url'] = attachmentUrl;
    
    await _client
        .from('complaints')
        .update(updates)
        .eq('id', id);
  }
}
