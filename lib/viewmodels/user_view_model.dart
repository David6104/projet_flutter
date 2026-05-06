import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class UserViewModel extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  UserViewModel() {
    _user = SupabaseService.currentUser;
  }

  Future<void> login(String email, String password) async {
    final response = await SupabaseService.signIn(email, password);
    _user = response.user;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    final response = await SupabaseService.signUp(email, password);
    _user = response.user;
    notifyListeners();
  }

  Future<void> logout() async {
    await SupabaseService.signOut();
    _user = null;
    notifyListeners();
  }
}
