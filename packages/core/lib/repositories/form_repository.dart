import '../models/form.dart';
import '../services/supabase_service.dart';
import '../utils/case_converter.dart';

class FormRepository {
  final _client = SupabaseService.client;

  Future<HostelForm?> fetchFormById(String id) async {
    final response =
        await _client.from('forms').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return HostelForm.fromJson(toCamelCase(response));
  }

  Future<List<HostelForm>> fetchFormsByHostel(String hostelId) async {
    final response = await _client
        .from('forms')
        .select()
        .eq('hostel_id', hostelId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => HostelForm.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<void> createForm({
    required String hostelId,
    required String title,
    String? description,
    required List<Map<String, dynamic>> fields,
  }) async {
    await _client.from('forms').insert({
      'hostel_id': hostelId,
      'title': title,
      'description': description,
      'fields': fields,
      'created_by': _client.auth.currentUser?.id,
    });
  }

  Future<void> deleteForm(String id) async {
    await _client.from('forms').delete().eq('id', id);
  }
}
