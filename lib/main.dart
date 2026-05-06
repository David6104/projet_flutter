import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';
import 'theme/my_theme.dart';
import 'viewmodels/article_view_model.dart';
import 'viewmodels/favorites_view_model.dart';
import 'viewmodels/cart_view_model.dart';
import 'viewmodels/user_view_model.dart';

// On ajoute "as my_prefs" pour donner un surnom unique à notre fichier
import 'services/local_storage.dart' as my_prefs;

void main() async {
  // 1. Allumage du moteur Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialisation de Supabase
  await Supabase.initialize(
    url: 'https://uhmrkvtfvywprnccdqmu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVobXJrdnRmdnl3cHJuY2NkcW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5ODUwMzAsImV4cCI6MjA5MzU2MTAzMH0.SWkJBOUhQyMu5F2D0qNch486eCHxLGv229gPs0gMXMo',
  );

  // 3. Récupération des données locales (En utilisant le surnom "my_prefs")
  bool hideWelcome = await my_prefs.LocalStorage.shouldHideWelcomeScreen();

  // 4. On crée le routeur
  final router = createRouter(hideWelcome);

  // 5. On lance l'app
  runApp(Bloc2App(router: router));
}

class Bloc2App extends StatelessWidget {
  final GoRouter router;

  const Bloc2App({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ArticleViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: MyTheme.light(),
        darkTheme: MyTheme.dark(),
        title: 'Bloc2 Store',
        routerConfig: router,
      ),
    );
  }
}
