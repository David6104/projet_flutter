import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class LocalStorage {
  // --- ECRAN D'ACCUEIL ---
  static Future<void> setHideWelcomeScreen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hide_welcome', value);
  }

  static Future<bool> shouldHideWelcomeScreen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hide_welcome') ?? false;
  }

  // --- FAVORIS
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
}
