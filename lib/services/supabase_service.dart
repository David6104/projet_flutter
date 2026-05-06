import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // --- AUTHENTIFICATION ---
  static Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth
        .signInWithPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  // --- ARTICLES ---
  static Future<List<Article>> getArticles() async {
    final List<dynamic> data = await client.from('articles').select();
    return data.map((json) => Article.fromJson(json)).toList();
  }

  // --- RECHERCHE (Point 7) ---
  static Future<List<Article>> searchArticles(String query) async {
    final List<dynamic> data = await client.from('articles').select().ilike(
        'title', '%$query%'); // Cherche le texte, peu importe les majuscules
    return data.map((json) => Article.fromJson(json)).toList();
  }

  // --- AJOUT D'ARTICLE (Point 6) ---
  static Future<void> addArticle({
    required String title,
    required String description,
    required double price,
    required String category,
    required String image,
  }) async {
    await client.from('articles').insert({
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'image': image.isEmpty ? 'https://via.placeholder.com/150' : image,
    });
  }

  // --- COMMANDES (Historique) ---
  static Future<void> saveOrder(double total, List<Article> items) async {
    final user = currentUser;
    if (user == null)
      throw Exception("Vous devez être connecté pour valider le panier.");

    await client.from('orders').insert({
      'user_id': user.id,
      'total': total,
      'items': items.map((a) => a.toMap()).toList(),
    });
  }
}
