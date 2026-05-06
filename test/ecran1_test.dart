import 'package:flutter_test/flutter_test.dart';
import '../lib/viewmodels/article_view_model.dart';

void main() {
  group('Tests de ArticleViewModel (Remplacement de Ecran1)', () {
    test('Etat initial correct pour ArticleViewModel', () {
      final vm = ArticleViewModel();

      // Au démarrage, la liste est vide et ça ne charge pas
      expect(vm.articles.isEmpty, true);
      expect(vm.isLoading, false);
    });
  });
}
