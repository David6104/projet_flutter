import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/article.dart';
import '../services/supabase_service.dart';

class ArticleSearchDelegate extends SearchDelegate<Article?> {
  @override
  String get searchFieldLabel => 'Rechercher un article...';

  // Le bouton à droite (pour effacer le texte)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Vide la barre de recherche
        },
      ),
    ];
  }

  // Le bouton à gauche (pour revenir en arrière)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Ferme la recherche
      },
    );
  }

  // Construit les résultats une fois qu'on a tapé un texte
  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(
          child: Text('Veuillez entrer un terme de recherche.'));
    }

    // Le FutureBuilder va exécuter la recherche sur Supabase
    return FutureBuilder<List<Article>>(
      future: SupabaseService.searchArticles(query),
      builder: (context, snapshot) {
        // En cours de chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // En cas d'erreur
        if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        }

        final results = snapshot.data ?? [];

        // Si aucun résultat
        if (results.isEmpty) {
          return const Center(
              child: Text('Aucun article trouvé pour cette recherche.'));
        }

        // Si on a des résultats, on les affiche en liste
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final article = results[index];
            return ListTile(
              leading: article.image.isNotEmpty
                  ? Image.network(
                      article.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) =>
                          const Icon(Icons.image, size: 50),
                    )
                  : const Icon(Icons.image, size: 50),
              title: Text(article.title),
              subtitle: Text('${article.price} €'),
              onTap: () {
                // Fermer le clavier et la recherche avant de naviguer
                close(context, null);
                // Utilisation de GoRouter (Point 8 du cahier des charges)
                context.push('/article', extra: article);
              },
            );
          },
        );
      },
    );
  }

  // Ce qu'on affiche avant d'avoir tapé "Entrée"
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
        child: Text('Tapez un mot-clé pour chercher un article.'));
  }
}
