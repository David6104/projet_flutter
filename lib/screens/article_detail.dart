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
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              context.read<FavoritesViewModel>().toggleFavorite(article);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favoris mis à jour')));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(
                article.image,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    const Center(child: Icon(Icons.broken_image, size: 100)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // LE WIDGET CHIP CATÉGORIE
                  Chip(
                    label: Text(
                      article.category,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),

                  const SizedBox(height: 15),
                  Text('${article.price} €',
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(article.description,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Ajouter au panier',
                          style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        context.read<CartViewModel>().addToCart(article);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('${article.title} ajouté au panier')),
                        );
                      },
                    ),
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
