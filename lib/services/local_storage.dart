import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
// Créez un modèle Order ou utilisez simplement une Map pour l'historique

class LocalStorage {
  // --- FAVORIS ---
  static Future<void> saveFavorites(List<Article> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
        json.encode(favorites.map((a) => a.toMap()).toList());
    await prefs.setString('favorites', encoded);
  }

  static Future<List<Article>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('favorites');
    if (data == null) return [];
    final List<dynamic> decoded = json.decode(data);
    return decoded.map((item) => Article.fromJson(item)).toList();
  }

  // --- PANIER ---
  static Future<void> saveCart(List<Article> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(cart.map((a) => a.toMap()).toList());
    await prefs.setString('cart', encoded);
  }

  static Future<List<Article>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('cart');
    if (data == null) return [];
    final List<dynamic> decoded = json.decode(data);
    return decoded.map((item) => Article.fromJson(item)).toList();
  }

  // --- HISTORIQUE D'ACHAT ---
  static Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('history', json.encode(history));
  }

  static Future<List<Map<String, dynamic>>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('history');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  // --- ÉCRAN D'ACCUEIL ---
  static Future<void> setHideWelcomeScreen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hide_welcome', value);
  }

  static Future<bool> shouldHideWelcomeScreen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hide_welcome') ?? false;
  }
}
