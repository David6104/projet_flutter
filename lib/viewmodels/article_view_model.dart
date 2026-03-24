import 'package:flutter/material.dart';
import '../models/article.dart';
import '../repository/article_repository.dart';

class ArticleViewModel extends ChangeNotifier {
  final ArticleRepository _repository = ArticleRepository();
  List<Article> _articles = [];
  bool _isLoading = false;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _articles = await _repository.getArticles();
    } catch (e) {
      print("Erreur : $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
