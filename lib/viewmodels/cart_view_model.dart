import 'package:flutter/foundation.dart';
import '../repository/local_storage.dart';

class CartViewModel extends ChangeNotifier {
  final LocalStorage _store;
  Map<int, int> _cart = {};

  CartViewModel({LocalStorage? store}) : _store = store ?? LocalStorage();

  Map<int, int> get cart => Map.unmodifiable(_cart);
  int qty(int id) => _cart[id] ?? 0;

  Future<void> load() async {
    _cart = await _store.getCart();
    notifyListeners();
  }

  Future<void> add(int id) async {
    final q = (_cart[id] ?? 0) + 1;
    _cart[id] = q;
    await _store.setCartQty(id, q);
    notifyListeners();
  }

  Future<void> removeOne(int id) async {
    final q = (_cart[id] ?? 0) - 1;
    await _store.setCartQty(id, q);
    if (q <= 0)
      _cart.remove(id);
    else
      _cart[id] = q;
    notifyListeners();
  }

  Future<void> clear() async {
    await _store.clearCart();
    _cart.clear();
    notifyListeners();
  }
}
