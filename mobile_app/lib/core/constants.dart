import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    return 'http://10.0.2.2:5000/api';
  }

  static const String supabaseUrl = 'https://aeozrauzceiegcbafssv.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFlb3pyYXV6Y2VpZWdjYmFmc3N2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MTIyNzc4MSwiZXhwIjoyMDg2ODAzNzgxfQ.TnYhQMTkjRffaWg1i_GxJxlky8KvyaqMGVV5L6RlgsE';
}
