import 'package:flutter_test/flutter_test.dart';
import '../lib/models/article.dart';

void main() {
  group('Tests du Modèle Article (Remplacement de TaskRepository)', () {
    test('Création correcte d un Article depuis un JSON Supabase', () {
      final json = {
        'id': 99,
        'title': 'Test Article',
        'description': 'Description',
        'price': 199.99,
        'category': 'Electronics',
        'image': 'http://image.url'
      };

      final article = Article.fromJson(json);

      expect(article.id, 99);
      expect(article.title, 'Test Article');
      expect(article.price, 199.99);
      expect(article.category, 'Electronics');
    });
  });
}
