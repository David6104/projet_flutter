import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'add_article_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Historique des achats'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Proposer un article'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddArticleScreen()));
          },
        ),
      ],
    );
  }
}
