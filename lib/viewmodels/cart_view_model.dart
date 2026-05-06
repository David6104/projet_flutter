import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/supabase_service.dart';

class CartViewModel extends ChangeNotifier {
  List<Article> _cartItems = [];
  bool _isLoading = false;

  List<Article> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.price);

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    _cartItems = await SupabaseService.getUserCart();

    _isLoading = false;
    notifyListeners();
  }

  void addToCart(Article article) async {
    _cartItems.add(article);
    notifyListeners();
    await SupabaseService.syncCart(_cartItems);
  }

  void removeFromCart(Article article) async {
    _cartItems.removeWhere((a) => a.id == article.id);
    notifyListeners();
    await SupabaseService.syncCart(_cartItems);
  }

  Future<void> checkout() async {
    if (_cartItems.isEmpty) return;

    try {
      // 1. Sauvegarde la commande dans l'historique
      await SupabaseService.saveOrder(totalPrice, _cartItems);

      // 2. Vide le panier localement
      _cartItems.clear();
      notifyListeners();

      // 3. LA CORRECTION : On synchronise le panier VIDE avec Supabase
      await SupabaseService.syncCart(_cartItems);
    } catch (e) {
      throw Exception("Erreur lors de la validation : $e");
    }
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
