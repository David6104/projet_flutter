import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/supabase_service.dart';
import '../viewmodels/article_view_model.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _price = '';
  String _category = '';
  String _imageUrl = '';
  String _description = '';

  bool _isLoading = false;

  Future<void> _submitArticle() async {
    // Validation des informations avant enregistrement
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);

      try {
        // 1. Envoi réel des données à Supabase
        await SupabaseService.addArticle(
          title: _title,
          price: double.parse(_price),
          category: _category,
          image: _imageUrl,
          description: _description,
        );

        if (mounted) {
          // 2. Rafraîchir la liste des articles sur l'accueil pour voir le nouveau produit
          context.read<ArticleViewModel>().load();

          // 3. Afficher un message de succès et fermer la page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Article mis en vente avec succès !')),
          );
          context.pop(); // Retourne à l'écran précédent
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'ajout : $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proposer un article')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Titre de l\'article',
                            border: OutlineInputBorder()),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Veuillez entrer un titre'
                            : null,
                        onSaved: (val) => _title = val!,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Prix (€)',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Veuillez entrer un prix';
                          if (double.tryParse(val) == null)
                            return 'Veuillez entrer un nombre valide';
                          return null;
                        },
                        onSaved: (val) => _price = val!,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Catégorie (ex: Tech, Shoes...)',
                            border: OutlineInputBorder()),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Veuillez entrer une catégorie'
                            : null,
                        onSaved: (val) => _category = val!,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'URL de l\'image (optionnel)',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.url,
                        onSaved: (val) => _imageUrl = val ?? '',
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder()),
                        maxLines: 4,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Veuillez entrer une description'
                            : null,
                        onSaved: (val) => _description = val!,
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton.icon(
                        onPressed: _submitArticle,
                        icon: const Icon(Icons.check),
                        label: const Text('Mettre en vente',
                            style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50)),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
