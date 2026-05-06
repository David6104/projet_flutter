import 'package:flutter_test/flutter_test.dart';
import '../lib/models/article.dart';
import '../lib/viewmodels/cart_view_model.dart';

void main() {
  group('Tests du Panier (CartViewModel)', () {
    late CartViewModel cartVM;
    late Article testArticle1;
    late Article testArticle2;

    setUp(() {
      cartVM = CartViewModel();
      testArticle1 = Article(
          id: 1,
          title: 'PC Gamer',
          description: 'Super PC',
          price: 1000.0,
          category: 'Tech',
          image: '');
      testArticle2 = Article(
          id: 2,
          title: 'Souris',
          description: 'Souris sans fil',
          price: 50.0,
          category: 'Tech',
          image: '');
    });

    test('Le panier doit être vide au départ', () {
      expect(cartVM.cartItems.length, 0);
      expect(cartVM.totalPrice, 0.0);
    });

    test(
        'Ajouter un article doit augmenter la taille du panier et le prix total',
        () {
      cartVM.cartItems.add(testArticle1);
      expect(cartVM.cartItems.length, 1);
      expect(cartVM.totalPrice, 1000.0);
    });

    test('Ajouter plusieurs articles additionne les prix', () {
      cartVM.cartItems.add(testArticle1);
      cartVM.cartItems.add(testArticle2);
      expect(cartVM.cartItems.length, 2);
      expect(cartVM.totalPrice, 1050.0);
    });

    test('Supprimer un article met à jour le panier', () {
      cartVM.cartItems.add(testArticle1);
      cartVM.cartItems.add(testArticle2);
      cartVM.cartItems.removeWhere((a) => a.id == testArticle1.id);
      expect(cartVM.cartItems.length, 1);
      expect(cartVM.cartItems.first.title, 'Souris');
      expect(cartVM.totalPrice, 50.0);
    });
  });
}
