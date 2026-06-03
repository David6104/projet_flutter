import 'package:flutter/material.dart';
import 'article_list.dart';
import 'cart.dart';
import 'favorites.dart';
import 'profile.dart';
import 'article_search_delegate.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ArticleList(),
    const CartScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Bloc2 Store',
    'Mon Panier',
    'Mes Favoris',
    'Mon Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.search, size: 28),
              tooltip: 'Rechercher un article',
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ArticleSearchDelegate(),
                );
              },
            ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}