import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:projet_flutter/main.dart' as app; 

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test d\'intégration : Navigation', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    if (find.text('Commencer').evaluate().isNotEmpty) {
       await tester.tap(find.text('Commencer'));
       await tester.pumpAndSettle();
    }

    expect(find.text('Se connecter'), findsOneWidget);
    
    await tester.tap(find.text('Pas de compte ? S\'inscrire'));
    await tester.pumpAndSettle();

    expect(find.text('Créer un compte'), findsOneWidget);
  });
}