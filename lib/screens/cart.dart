import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart'; // pour firstWhereOrNull
import '../viewmodels/cart_view_model.dart';
import '../viewmodels/article_view_model.dart';
import '../models/article.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final articles = context.watch<ArticleViewModel>().articles;

    if (cart.cart.isEmpty) {
      return const Center(child: Text('Panier vide'));
    }

    // Associer chaque article avec sa quantité
    final items = cart.cart.entries
        .map((entry) {
          final Article? article =
              articles.firstWhereOrNull((a) => a.id == entry.key);
          return {'article': article, 'qty': entry.value};
        })
        .where((m) => m['article'] != null)
        .toList();

    final total = items.fold<double>(
      0,
      (sum, m) => sum + (m['article'] as Article).price * (m['qty'] as int),
    );

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final Article article = items[index]['article'] as Article;
              final int qty = items[index]['qty'] as int;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: article.image.isNotEmpty
                      ? NetworkImage(article.image)
                      : null,
                ),
                title: Text(article.title),
                subtitle: Text(
                    'x$qty • ${(article.price * qty).toStringAsFixed(2)} €'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () => cart.removeOne(article.id),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Total: ${total.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  await cart.clear();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Achat simulé, panier vidé')),
                    );
                  }
                },
                icon: const Icon(Icons.payment),
                label: const Text('Valider'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
