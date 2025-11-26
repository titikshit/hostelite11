import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_env.dart';

class SupabaseService {
  static SupabaseClient? _client;
  
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppEnv.supabaseUrl,
      anonKey: AppEnv.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }
  
  static bool get isInitialized => _client != null;
}
