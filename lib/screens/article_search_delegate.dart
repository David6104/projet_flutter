import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/article.dart';
import '../services/supabase_service.dart';

class ArticleSearchDelegate extends SearchDelegate<Article?> {
  @override
  String get searchFieldLabel => 'Rechercher un article...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '', // Efface le texte tapé
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null), // Ferme la recherche
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Tapez un nom d\'article.'));
    }

    return FutureBuilder<List<Article>>(
      future: SupabaseService.searchArticles(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erreur lors de la recherche.'));
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty) {
          return const Center(child: Text('Aucun article trouvé.'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final article = results[index];
            return ListTile(
              leading: const Icon(Icons.image),
              title: Text(article.title),
              subtitle: Text('${article.price} €'),
              onTap: () {
                // Fonctionnalité 8 : Utilisation de go_router pour naviguer
                context.push('/article', extra: article);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // On peut laisser vide ou rappeler buildResults(context)
  }
}
