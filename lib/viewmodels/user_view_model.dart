import 'package:flutter/foundation.dart';
import '../repository/auth_repository.dart';

class UserViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  bool _logged = false;

  UserViewModel({AuthRepository? repo}) : _repo = repo ?? AuthRepository();

  bool get logged => _logged;

  Future<bool> login(String email, String password) async {
    final ok = await _repo.login(email, password);
    _logged = ok;
    notifyListeners();
    return ok;
  }

  void logout() {
    _logged = false;
    notifyListeners();
  }
}
