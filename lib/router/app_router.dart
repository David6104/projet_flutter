import 'package:go_router/go_router.dart';
import '../screens/home.dart';
import '../screens/welcome_screen.dart';
import '../screens/login.dart';
import '../screens/article_detail.dart';
import '../models/article.dart';

final GoRouter appRouter = GoRouter(
  initialLocation:
      '/', // Page de démarrage (vous pouvez mettre '/welcome' si besoin)
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/article',
      builder: (context, state) {
        final article = state.extra as Article;
        return ArticleDetail(article: article);
      },
    ),
  ],
);
