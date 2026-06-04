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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final articleVM = context.watch<ArticleViewModel>();

    // On récupère les listes gérées par le ViewModel
    final articles = articleVM.displayedArticles;
    final categories = articleVM.availableCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique Platzi'),
        actions: [
          //  BOUTON DE TRI
          IconButton(
            icon: Icon(
              articleVM.sortAscending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
            tooltip: 'Trier par prix',
            onPressed: () => context.read<ArticleViewModel>().toggleSort(),
          )
        ],
      ),
      body: articleVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BARRE DE FILTRES
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = articleVM.selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: Colors.blueAccent,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (bool selected) {
                            if (selected) {
                              context.read<ArticleViewModel>().setCategory(cat);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Expanded(
                  child: articles.isEmpty
                      ? const Center(child: Text('Aucun article trouvé.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),

                                //Miniature
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.network(
                                      article.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => const Icon(
                                          Icons.broken_image,
                                          size: 40),
                                    ),
                                  ),
                                ),

                                //LE TEXTE
                                title: Text(
                                  article.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${article.price} €',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),

                                // LE BOUTON D'AJOUT AU PANIER
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_shopping_cart,
                                      color: Colors.blue),
                                  onPressed: () {
                                    context
                                        .read<CartViewModel>()
                                        .addToCart(article);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Ajouté au panier !')),
                                    );
                                  },
                                ),

                                onTap: () =>
                                    context.push('/article', extra: article),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
