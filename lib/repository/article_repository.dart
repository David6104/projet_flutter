import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticleRepository {
  static const base = 'https://api.escuelajs.co/api/v1';

  Future<List<Article>> fetchAll() async {
    final res = await http.get(Uri.parse('$base/products'));
    if (res.statusCode != 200) throw Exception('API error ${res.statusCode}');
    final List data = jsonDecode(res.body);
    return data.map((e) => Article.fromMap(e)).toList();
  }

  Future<Article> fetchOne(int id) async {
    final res = await http.get(Uri.parse('$base/products/$id'));
    if (res.statusCode != 200) throw Exception('API error ${res.statusCode}');
    return Article.fromMap(jsonDecode(res.body));
  }
}
