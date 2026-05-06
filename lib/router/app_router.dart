import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/home.dart';
import '../screens/welcome_screen.dart';
import '../screens/login.dart';
import '../screens/article_detail.dart';
import '../models/article.dart';

// On transforme appRouter en fonction pour lui passer la variable hideWelcome
GoRouter createRouter(bool hideWelcome) {
  return GoRouter(
    // 1. Détermine la page de départ
    initialLocation: _getInitialRoute(hideWelcome),

    // 2. Le Gardien de sécurité (Point 3 du cahier des charges)
    redirect: (context, state) {
      final user = Supabase.instance.client.auth.currentUser;
      final isLoggedIn = user != null;

      // Est-ce que l'utilisateur essaie d'aller sur Login ou Welcome ?
      final isGoingToAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/welcome';

      // S'il n'est PAS connecté et qu'il essaie de voir les articles -> On le bloque vers Login
      if (!isLoggedIn && !isGoingToAuth) {
        return '/login';
      }

      return null; // Tout va bien, on laisse passer
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const Home()),
      GoRoute(
          path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/article',
        builder: (context, state) {
          final article = state.extra as Article;
          return ArticleDetail(article: article);
        },
      ),
    ],
  );
}

// Calcule la page d'ouverture
String _getInitialRoute(bool hideWelcome) {
  final user = Supabase.instance.client.auth.currentUser;
  if (!hideWelcome) {
    return '/welcome';
  } else if (user == null) {
    return '/login';
  } else {
    return '/';
  }
}
