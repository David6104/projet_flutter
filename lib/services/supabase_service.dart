import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // Récupérer tous les articles
  static Future<List<Article>> getArticles() async {
    final List<dynamic> data = await client.from('articles').select();
    return data.map((json) => Article.fromJson(json)).toList();
  }

  // Fonctionnalité 7 : Recherche et filtres
  static Future<List<Article>> searchArticles(String query) async {
    // .ilike permet de chercher du texte sans se soucier des majuscules/minuscules
    final List<dynamic> data =
        await client.from('articles').select().ilike('title', '%$query%');

    return data.map((json) => Article.fromJson(json)).toList();
  }
}
