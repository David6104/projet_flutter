import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1/products';

  // Récupère les articles depuis l'API Platzi
  static Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des articles depuis l\'API');
    }
  }
}
