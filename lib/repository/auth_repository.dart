class AuthRepository {
  // TODO: branch feature/auth - intégrer API ou Firebase/Supabase
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return email.isNotEmpty && password.isNotEmpty;
  }
}
