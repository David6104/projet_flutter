import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'add_article_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person, size: 50),
            title: Text('Utilisateur Connecté'), // À lier avec UserViewModel
            subtitle: Text('utilisateur@email.com'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historique de mes achats'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Proposer un nouvel article'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddArticleScreen()));
            },
          ),
        ],
      ),
    );
  }
}
