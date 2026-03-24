import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticleRepository {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  Future<List<Article>> getArticles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Erreur de chargement des articles');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
