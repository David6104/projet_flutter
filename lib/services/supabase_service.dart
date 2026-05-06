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

  static Future<List<Article>> searchArticles(String query) async {
    final List<dynamic> data =
        await client.from('articles').select().ilike('title', '%$query%');
    return data.map((json) => Article.fromJson(json)).toList();
  }

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

  // Sauvegarder le panier de l'utilisateur connecté
  static Future<void> syncCart(List<Article> cartItems) async {
    final user = currentUser;
    if (user == null) return; // Ne rien faire si non connecté

    final itemsJson = cartItems.map((a) => a.toMap()).toList();

    // Upsert = Insert si ça n'existe pas, Update si ça existe
    await client.from('user_carts').upsert({
      'user_id': user.id,
      'items': itemsJson,
    });
  }

  // Récupérer le panier de l'utilisateur au démarrage
  static Future<List<Article>> getUserCart() async {
    final user = currentUser;
    if (user == null) return [];

    try {
      final data = await client
          .from('user_carts')
          .select('items')
          .eq('user_id', user.id)
          .maybeSingle();

      if (data == null || data['items'] == null) return [];

      final List<dynamic> items = data['items'];
      return items.map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      print('Erreur récupération panier: $e');
      return [];
    }
  }

  // --- COMMANDES ---
  static Future<void> saveOrder(double total, List<Article> items) async {
    final user = currentUser;
    if (user == null) throw Exception("Vous devez être connecté.");

    await client.from('orders').insert({
      'user_id': user.id,
      'total': total,
      'items': items.map((a) => a.toMap()).toList(),
    });

    // On vide le panier distant après la commande
    await syncCart([]);
  }
}
