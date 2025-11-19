import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../viewmodels/favorites_view_model.dart';
import '../viewmodels/cart_view_model.dart';

class ArticleDetail extends StatelessWidget {
  final Article article;
  const ArticleDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesViewModel>();
    final cart = context.watch<CartViewModel>();
    final isFav = fav.isFav(article.id);
    final q = cart.qty(article.id);

    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (article.image.isNotEmpty)
            Image.network(article.image, height: 220, fit: BoxFit.cover),
          const SizedBox(height: 12),
          Text(
            '${article.price.toStringAsFixed(2)} €',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(article.description),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => fav.toggle(article.id),
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                label: Text(
                  isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => cart.add(article.id),
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(q > 0 ? 'Quantité: $q' : 'Ajouter au panier'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
