import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/local_storage.dart';

class CartViewModel extends ChangeNotifier {
  List<Article> _cartItems = [];
  List<Article> get cartItems => _cartItems;

  CartViewModel() {
    loadCart();
  }

  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.price);

  Future<void> loadCart() async {
    _cartItems = await LocalStorage.loadCart();
    notifyListeners();
  }

  void addToCart(Article article) async {
    _cartItems.add(article);
    await LocalStorage.saveCart(_cartItems);
    notifyListeners();
  }

  void removeFromCart(Article article) async {
    _cartItems.removeWhere((a) => a.id == article.id);
    await LocalStorage.saveCart(_cartItems);
    notifyListeners();
  }

  // CORRECTION : Validation du panier
  Future<void> checkout() async {
    if (_cartItems.isEmpty) return;

    // 1. Récupérer l'historique existant
    List<Map<String, dynamic>> history = await LocalStorage.loadHistory();

    // 2. Créer une nouvelle commande
    final newOrder = {
      'date': DateTime.now().toIso8601String(),
      'total': totalPrice,
      'items': _cartItems.map((a) => a.toMap()).toList(),
    };

    // 3. Ajouter et sauvegarder l'historique
    history.add(newOrder);
    await LocalStorage.saveHistory(history);

    // 4. Vider le panier
    _cartItems.clear();
    await LocalStorage.saveCart(_cartItems);

    notifyListeners();
  }
}
