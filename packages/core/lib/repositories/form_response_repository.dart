import '../models/form.dart';
import '../services/supabase_service.dart';
import '../utils/case_converter.dart';

class FormResponseRepository {
  final _client = SupabaseService.client;

  Future<List<FormResponse>> fetchFormResponsesByStudent(
      String studentId) async {
    final response = await _client
        .from('form_responses')
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => FormResponse.fromJson(toCamelCase(e)))
        .toList();
  }

  // Add this function to your existing FormResponseRepository class
  Future<List<FormResponse>> fetchFormResponsesByFormId(String formId) async {
    final response = await _client
        .from('form_responses')
        .select()
        .eq('form_id', formId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => FormResponse.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<void> createFormResponse({
    required String formId,
    required String studentId,
    required Map<String, dynamic> response,
  }) async {
    await _client.from('form_responses').insert({
      'form_id': formId,
      'student_id': studentId,
      'response': response,
    });
  }
}
