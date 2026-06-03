import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:projet_flutter/screens/login.dart';
import 'package:projet_flutter/viewmodels/user_view_model.dart';
import 'package:projet_flutter/viewmodels/cart_view_model.dart';

void main() {
  testWidgets('Test UI: Écran de connexion', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserViewModel()),
          ChangeNotifierProvider(create: (_) => CartViewModel()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Se connecter'), findsOneWidget);
    
    await tester.tap(find.text('Pas de compte ? S\'inscrire'));
    await tester.pump(); 

    expect(find.text('Créer un compte'), findsOneWidget);
  });
}
