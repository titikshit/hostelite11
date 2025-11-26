import '../models/profile.dart';
import '../services/supabase_service.dart';
import '../utils/case_converter.dart';

class ProfileRepository {
  final _client = SupabaseService.client;

  Future<Profile?> getCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    
    if (response == null) return null;
    return Profile.fromJson(toCamelCase(response));
  }

  Future<List<Profile>> fetchProfilesByHostel(String hostelId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('hostel_id', hostelId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((e) => Profile.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<List<Profile>> fetchStudentsByFilters({
    String? hostelId,
    String? course,
    String? year,
  }) async {
    var query = _client
        .from('profiles')
        .select()
        .eq('role', 'student');
    
    if (hostelId != null) {
      query = query.eq('hostel_id', hostelId);
    }
    if (course != null) {
      query = query.eq('course', course);
    }
    if (year != null) {
      query = query.eq('year', year);
    }
    
    final response = await query.order('created_at', ascending: false);
    
    return (response as List)
        .map((e) => Profile.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<void> createProfile({
    required String id,
    required String fullName,
    String? phone,
    required String role,
    required String hostelId,
    String? roomNo,
    String? course,
    String? year,
  }) async {
    await _client.from('profiles').insert({
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'hostel_id': hostelId,
      'room_no': roomNo,
      'course': course,
      'year': year,
    });
  }

  Future<void> updateProfile({
    required String id,
    String? fullName,
    String? phone,
    String? hostelId,
    String? roomNo,
    String? course,
    String? year,
  }) async {
    final updates = <String, dynamic>{};
    
    if (fullName != null) updates['full_name'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (hostelId != null) updates['hostel_id'] = hostelId;
    if (roomNo != null) updates['room_no'] = roomNo;
    if (course != null) updates['course'] = course;
    if (year != null) updates['year'] = year;
    
    if (updates.isNotEmpty) {
      await _client
          .from('profiles')
          .update(updates)
          .eq('id', id);
    }
  }

  Future<void> deleteProfile(String id) async {
    await _client
        .from('profiles')
        .delete()
        .eq('id', id);
  }
}
