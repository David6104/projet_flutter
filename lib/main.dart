import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router/app_router.dart';
import 'theme/my_theme.dart';
import 'viewmodels/article_view_model.dart';
import 'viewmodels/favorites_view_model.dart';
import 'viewmodels/cart_view_model.dart';
import 'viewmodels/user_view_model.dart';

void main() async {
  // Nécessaire car nous appelons du code asynchrone avant runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de VOTRE base de données Supabase
  await Supabase.initialize(
    url:
        'https://uhmrkvtfvywprnccdqmu.supabase.co', // Corrigé (sans le /rest/v1/)
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVobXJrdnRmdnl3cHJuY2NkcW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5ODUwMzAsImV4cCI6MjA5MzU2MTAzMH0.SWkJBOUhQyMu5F2D0qNch486eCHxLGv229gPs0gMXMo',
  );

  runApp(const Bloc2App());
}

class Bloc2App extends StatelessWidget {
  const Bloc2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ArticleViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      // Utilisation de MaterialApp.router pour activer go_router
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: MyTheme.light(),
        darkTheme: MyTheme.dark(),
        title: 'Bloc2 Store',
        routerConfig: appRouter, // Connecte la navigation complexe ici
      ),
    );
  }
}
