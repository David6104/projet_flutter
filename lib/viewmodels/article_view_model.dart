import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../repository/article_repository.dart';

class ArticleViewModel extends ChangeNotifier {
  final ArticleRepository _repo;
  List<Article> _articles = [];
  bool _loading = false;
  String? _error;

  ArticleViewModel({ArticleRepository? repo})
    : _repo = repo ?? ArticleRepository();

  List<Article> get articles => _articles;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _articles = await _repo.fetchAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Article? byId(int id) => _articles.firstWhere(
    (a) => a.id == id,
    orElse: () => Article(
      id: id,
      title: '',
      description: '',
      price: 0,
      category: '',
      image: '',
    ),
  );
}
