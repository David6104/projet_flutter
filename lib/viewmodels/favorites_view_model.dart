import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/local_storage.dart';

class FavoritesViewModel extends ChangeNotifier {
  List<Article> _favorites = [];
  List<Article> get favorites => _favorites;

  FavoritesViewModel() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _favorites = await LocalStorage.loadFavorites();
    notifyListeners();
  }

  void toggleFavorite(Article article) async {
    final index = _favorites.indexWhere((a) => a.id == article.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(article);
    }
    await LocalStorage.saveFavorites(_favorites); // Sauvegarde immédiate
    notifyListeners();
  }

  bool isFavorite(int id) => _favorites.any((a) => a.id == id);
}
