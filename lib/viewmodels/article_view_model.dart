import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart'; // Import corrigé vers l'API

class ArticleViewModel extends ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Article> get articles => _articles;

  // TRI PAR PRIX
  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;

  void toggleSort() {
    _sortAscending = !_sortAscending;
    notifyListeners();
  }

  // FILTRE PAR CATÉGORIE
  String _selectedCategory = 'Toutes';
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Extrait les catégories de l'API
  List<String> get availableCategories {
    List<String> categories = _articles.map((a) => a.category).toSet().toList();
    categories.insert(0, 'Toutes');
    return categories;
  }

  //  LISTE  AFFICHÉE (Filtrée et Triée)
  List<Article> get displayedArticles {
    Iterable<Article> filtered = _articles;
    if (_selectedCategory != 'Toutes') {
      filtered = _articles.where((a) => a.category == _selectedCategory);
    }

    List<Article> copy = filtered.toList();
    copy.sort((a, b) => _sortAscending
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));

    return copy;
  }

  // CHARGEMENT DEPUIS L'API PLATZI
  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _articles = await ApiService.getArticles();
    } catch (e) {
      print("Erreur API: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
