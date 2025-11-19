import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favorites_view_model.dart';
import '../viewmodels/article_view_model.dart';
import 'article_detail.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesViewModel>();
    final articles = context.watch<ArticleViewModel>().articles;
    final favItems = articles.where((a) => fav.isFav(a.id)).toList();

    if (favItems.isEmpty) return const Center(child: Text('Aucun favori'));
    return ListView.builder(
      itemCount: favItems.length,
      itemBuilder: (c, i) {
        final a = favItems[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: a.image.isNotEmpty ? NetworkImage(a.image) : null,
          ),
          title: Text(a.title),
          onTap: () => Navigator.push(
            c,
            MaterialPageRoute(builder: (_) => ArticleDetail(article: a)),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => fav.toggle(a.id),
          ),
        );
      },
    );
  }
}
