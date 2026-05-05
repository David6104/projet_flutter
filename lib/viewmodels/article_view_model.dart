import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/supabase_service.dart'; // On importe notre service Supabase

class ArticleViewModel extends ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      // C'EST ICI QUE TOUT CHANGE : On utilise SupabaseService au lieu du repo API
      _articles = await SupabaseService.getArticles();
    } catch (e) {
      print("Erreur de chargement Supabase : $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
