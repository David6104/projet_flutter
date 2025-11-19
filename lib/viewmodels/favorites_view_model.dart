import 'package:flutter/foundation.dart';
import '../repository/local_storage.dart';

class FavoritesViewModel extends ChangeNotifier {
  final LocalStorage _store;
  Set<int> _ids = {};

  FavoritesViewModel({LocalStorage? store}) : _store = store ?? LocalStorage();

  Set<int> get ids => _ids;

  Future<void> load() async {
    _ids = (await _store.getFavorites()).toSet();
    notifyListeners();
  }

  Future<void> toggle(int id) async {
    if (_ids.contains(id)) {
      await _store.removeFavorite(id);
      _ids.remove(id);
    } else {
      await _store.addFavorite(id);
      _ids.add(id);
    }
    notifyListeners();
  }

  bool isFav(int id) => _ids.contains(id);
}
