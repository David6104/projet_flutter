import 'package:flutter_test/flutter_test.dart';
import 'package:projet_flutter/models/article.dart';

void main() {
  group('Tests du Modèle Article', () {
    test('Q3 - fromJson gère une catégorie sous forme d\'objet imbriqué', () {
      final json = {
        'id': 1,
        'title': 'Veste en cuir',
        'price': 100,
        // L'API Platzi renvoie un map pour la catégorie
        'category': {'id': 1, 'name': 'Clothes'}
      };

      final article = Article.fromJson(json);

      expect(article.category, 'Clothes'); // Doit extraire le "name"
    });

    //  TEST PRIX ABSENT OU EN TEXTE
    test('Q3 - fromJson gère un prix absent ou non-numérique', () {
      // Cas 1 : Prix absent du JSON
      final jsonAbsent = {'id': 1, 'title': 'Livre'};
      final articleAbsent = Article.fromJson(jsonAbsent);
      expect(
          articleAbsent.price, 0.0); // Doit retomber sur la valeur par défaut

      // Cas 2 : Prix envoyé sous forme de texte (String)
      final jsonString = {'id': 2, 'title': 'Livre', 'price': '15.50'};
      final articleString = Article.fromJson(jsonString);
      expect(articleString.price,
          15.50); // Doit être converti en double correctement

      // Cas 3 : Prix invalide textuel
      final jsonInvalid = {'id': 3, 'title': 'Livre', 'price': 'Gratuit'};
      final articleInvalid = Article.fromJson(jsonInvalid);
      expect(articleInvalid.price, 0.0); // En cas de plantage, retombe sur 0.0
    });
  });
}
