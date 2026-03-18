import 'package:flutter/material.dart';
import 'package:mobile_app/models/models.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  User? _user;
  bool _isLoading = false;

  AuthProvider(this._apiService);

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);
      if (result['token'] != null) {
        _apiService.setToken(result['token']);
        _user = User.fromJson(result['user']);
        _isLoading = false;
        notifyListeners();
        return null; // null means success
      }
      return 'Unexpected login response';
    } catch (e) {
      debugPrint('Login Error: $e');
      _isLoading = false;
      notifyListeners();
      
      // Parse Exception message
      String errorMsg = e.toString();
      if (errorMsg.startsWith('Exception: ')) {
        errorMsg = errorMsg.substring('Exception: '.length);
      }
      return errorMsg;
    }
  }

  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _apiService.setToken('');
    notifyListeners();
  }
}
