import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/article_view_model.dart';
import '../viewmodels/favorites_view_model.dart';
import '../viewmodels/cart_view_model.dart';
import 'article_list.dart';
import 'favorites.dart';
import 'cart.dart';
import 'profile.dart'; // Le nouvel onglet

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _idx = 0;
  final _pages = const [
    ArticleList(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen() // Ajout de la page profil
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ArticleViewModel>().load();
      await context.read<FavoritesViewModel>().loadFavorites();
      await context.read<CartViewModel>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc2 Store')),
      body: _pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        type: BottomNavigationBarType
            .fixed, // Nécessaire quand on a plus de 3 onglets
        onTap: (i) => setState(() => _idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Panier'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profil'), // Nouvel icône
        ],
      ),
    );
  }
}
