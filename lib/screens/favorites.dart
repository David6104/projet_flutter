import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favorites_view_model.dart';
import 'article_detail.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favViewModel = context.watch<FavoritesViewModel>();

    if (favViewModel.favorites.isEmpty) {
      return const Center(child: Text('Aucun favori pour le moment.'));
    }

    return ListView.builder(
      itemCount: favViewModel.favorites.length,
      itemBuilder: (context, index) {
        final article = favViewModel.favorites[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: article.image.isNotEmpty
                ? Image.network(article.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) =>
                        const Icon(Icons.image_not_supported))
                : const Icon(Icons.image, size: 50),
            title: Text(article.title,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('${article.price} €'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () =>
                  context.read<FavoritesViewModel>().toggleFavorite(article),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ArticleDetail(article: article)),
              );
            },
          ),
        );
      },
    );
  }
}
