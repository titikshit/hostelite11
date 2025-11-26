class AppEnv {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://lbmgkkxkxotkfruhguvl.supabase.co',
  );
  
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxibWdra3hreG90a2ZydWhndXZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU4MDMyMzUsImV4cCI6MjA3MTM3OTIzNX0.5QoSRZDyHjpMrl0hAAU4nq8xaWDhdr42ltKE6Q4PtA0',
  );
}

/// Hostel assignment based on year
class HostelConfig {
  static const Map<String, String> yearToHostel = {
    '1st': 'mvcv_hostel',
    '2nd': 'bhaba_hostel', 
    '3rd': 'bose_hostel',
    '4th': 'bose_hostel',
  };
  
  static const String defaultHostel = 'bose_hostel';
  
  static String getHostelForYear(String year) {
    return yearToHostel[year] ?? defaultHostel;
  }
  
  static List<String> get allHostels => [
    'mvcv_hostel',
    'bhaba_hostel',
    'bose_hostel',
  ];
}
