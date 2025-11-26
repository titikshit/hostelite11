import '../models/notice.dart';
import '../services/supabase_service.dart';
import '../utils/case_converter.dart';

class NoticeRepository {
  final _client = SupabaseService.client;

  Future<List<Notice>> fetchNotices(String hostelId) async {
    final response = await _client
        .from('notices')
        .select()
        .eq('hostel_id', hostelId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((e) => Notice.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<void> createNotice({
    required String hostelId,
    required String title,
    String? body,
    String tag = 'General',
  }) async {
    await _client.from('notices').insert({
      'hostel_id': hostelId,
      'title': title,
      'body': body,
      'tag': tag,
      'created_by': _client.auth.currentUser?.id,
    });
  }

  Future<void> updateNotice({
    required String id,
    String? title,
    String? body,
    String? tag,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (body != null) updates['body'] = body;
    if (tag != null) updates['tag'] = tag;
    
    if (updates.isNotEmpty) {
      await _client
          .from('notices')
          .update(updates)
          .eq('id', id);
    }
  }

  Future<void> deleteNotice(String id) async {
    await _client
        .from('notices')
        .delete()
        .eq('id', id);
  }
}
