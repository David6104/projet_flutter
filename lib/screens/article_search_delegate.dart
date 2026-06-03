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
        onPressed: () => query = '', // Vide la barre de texte
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
    // Si l'utilisateur n'a rien tapé
    if (query.trim().isEmpty) {
      return const Center(child: Text('Entrez un mot-clé (ex: Casque, Table...)'));
    }

    // On lance la requête vers Supabase
    return FutureBuilder<List<Article>>(
      future: SupabaseService.searchArticles(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final results = snapshot.data ?? [];
        
        if (results.isEmpty) {
          return const Center(child: Text('Aucun article trouvé pour cette recherche.'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final article = results[index];
            return ListTile(
              leading: const Icon(Icons.search),
              title: Text(article.title),
              subtitle: Text('${article.price} €'),
              onTap: () {
                // 1. Ferme la page de recherche
                close(context, null);
                // 2. Ouvre les détails du produit
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
    return const Center(child: Text('Recherchez un article par son nom.'));
  }
}