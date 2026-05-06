import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/supabase_service.dart';

class ArticleViewModel extends ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Appelle la méthode getArticles() du service
      _articles = await SupabaseService.getArticles();
    } catch (e) {
      debugPrint("Erreur lors du chargement des articles : $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
