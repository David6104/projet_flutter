import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../viewmodels/cart_view_model.dart';
import '../viewmodels/favorites_view_model.dart';

class ArticleDetail extends StatelessWidget {
  final Article article;
  const ArticleDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoritesViewModel>().isFavorite(article.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red),
            onPressed: () =>
                context.read<FavoritesViewModel>().toggleFavorite(article),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            article.image.isNotEmpty
                ? Image.network(article.image,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) =>
                        const Icon(Icons.image_not_supported, size: 100))
                : const SizedBox(
                    height: 300, child: Icon(Icons.image, size: 100)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('${article.price} €',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  const SizedBox(height: 10),
                  Chip(label: Text(article.category)),
                  const SizedBox(height: 20),
                  Text(article.description,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<CartViewModel>().addToCart(article);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ajouté au panier !')));
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Ajouter au panier'),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
