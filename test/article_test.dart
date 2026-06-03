import 'package:flutter_test/flutter_test.dart';
import 'package:projet_flutter/models/article.dart';

void main() {
  group('Tests du Modèle Article', () {
    test('fromJson doit lire correctement les données de Supabase', () {
      final json = {
        'id': 101,
        'title': 'Casque Audio',
        'description': 'Super son',
        'price': 89.99,
        'category': 'Tech',
        'image': 'https://lien.com/image.png'
      };

      final article = Article.fromJson(json);

      expect(article.id, 101);
      expect(article.title, 'Casque Audio');
      expect(article.price, 89.99);
      expect(article.category, 'Tech');
    });

    test('toMap doit convertir l\'article pour l\'insertion SQL', () {
      final article = Article(
        id: 202,
        title: 'Livre Flutter',
        description: 'Dev',
        price: 25.0,
        category: 'Livres',
        image: 'url'
      );

      final map = article.toMap();

      expect(map['title'], 'Livre Flutter');
      expect(map['price'], 25.0);
    });
  });
}