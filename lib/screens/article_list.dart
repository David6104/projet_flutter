import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/article_view_model.dart';
import '../viewmodels/cart_view_model.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  
  @override
  void initState() {
    super.initState();
    // Au démarrage de l'écran, on force le ViewModel à charger les articles depuis Supabase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    // On écoute les changements d'état (chargement, liste remplie...)
    final articleVM = context.watch<ArticleViewModel>();

    // 1. Si ça charge, on affiche le cercle qui tourne
    if (articleVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Si la liste est vide (aucun article dans la base)
    if (articleVM.articles.isEmpty) {
      return const Center(child: Text('Aucun article disponible pour le moment.', style: TextStyle(fontSize: 16)));
    }

    // 3. On affiche les articles
    return ListView.builder(
      itemCount: articleVM.articles.length,
      itemBuilder: (context, index) {
        final article = articleVM.articles[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: article.image.isNotEmpty
                ? Image.network(
                    article.image, 
                    width: 50, 
                    height: 50, 
                    fit: BoxFit.cover,
                    // Sécurité : si l'image web est cassée, on met une icône à la place
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.image, size: 50),
                  )
                : const Icon(Icons.image, size: 50),
            title: Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${article.price} €', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
              onPressed: () {
                // Ajout direct au panier
                context.read<CartViewModel>().addToCart(article);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${article.title} ajouté au panier !')),
                );
              },
            ),
            onTap: () {
              // Aller voir les détails
              context.push('/article', extra: article);
            },
          ),
        );
      },
    );
  }
}