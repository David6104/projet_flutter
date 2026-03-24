import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/article_view_model.dart';
import '../viewmodels/favorites_view_model.dart';
import 'article_detail.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArticleViewModel>();
    final favViewModel = context.watch<FavoritesViewModel>();

    if (viewModel.isLoading)
      return const Center(child: CircularProgressIndicator());
    if (viewModel.articles.isEmpty)
      return const Center(child: Text('Aucun article.'));

    return ListView.builder(
      itemCount: viewModel.articles.length,
      itemBuilder: (context, index) {
        final article = viewModel.articles[index];
        final isFav = favViewModel.isFavorite(article.id);

        return ListTile(
          leading: article.image.isNotEmpty
              ? Image.network(article.image,
                  width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.image, size: 50),
          title: Text(article.title),
          subtitle: Text('${article.price} €'),
          trailing: IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red),
            onPressed: () => favViewModel.toggleFavorite(article),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ArticleDetail(article: article)));
          },
        );
      },
    );
  }
}
