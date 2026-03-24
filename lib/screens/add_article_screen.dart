import 'package:flutter/material.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String price = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proposer un article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Titre de l\'article'),
                validator: (val) =>
                    val!.isEmpty ? 'Veuillez entrer un titre' : null,
                onSaved: (val) => title = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prix (€)'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? 'Veuillez entrer un prix' : null,
                onSaved: (val) => price = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (val) =>
                    val!.isEmpty ? 'Veuillez entrer une description' : null,
                onSaved: (val) => description = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Ici, dans un vrai projet, on ferait un POST vers l'API
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Article proposé avec succès ! (Simulation)')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Mettre en vente'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
