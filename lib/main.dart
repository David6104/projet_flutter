import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/my_theme.dart';
import 'screens/home.dart';
import 'viewmodels/article_view_model.dart';
import 'viewmodels/favorites_view_model.dart';
import 'viewmodels/cart_view_model.dart';
import 'viewmodels/user_view_model.dart';

void main() {
  runApp(const Bloc2App());
}

class Bloc2App extends StatelessWidget {
  const Bloc2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArticleViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyTheme.light(),
        darkTheme: MyTheme.dark(),
        title: 'Bloc2 Store',
        home: const Home(),
      ),
    );
  }
}
