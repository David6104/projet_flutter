import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/article_view_model.dart';
import '../viewmodels/favorites_view_model.dart';
import '../viewmodels/cart_view_model.dart';
import 'article_detail.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ArticleViewModel>();
    final fav = context.watch<FavoritesViewModel>();
    final cart = context.watch<CartViewModel>();

    if (vm.loading) return const Center(child: CircularProgressIndicator());
    if (vm.error != null) return Center(child: Text('Erreur: ${vm.error}'));
    final items = vm.articles;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (c, i) {
        final a = items[i];
        final isFav = fav.isFav(a.id);
        final q = cart.qty(a.id);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: a.image.isNotEmpty ? NetworkImage(a.image) : null,
          ),
          title: Text(a.title),
          subtitle: Text('${a.category} • ${a.price.toStringAsFixed(2)} €'),
          onTap: () => Navigator.push(
            c,
            MaterialPageRoute(builder: (_) => ArticleDetail(article: a)),
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () => fav.toggle(a.id),
                tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () => cart.add(a.id),
                tooltip: q > 0 ? 'Quantité: $q' : 'Ajouter au panier',
              ),
            ],
          ),
        );
      },
    );
  }
}
