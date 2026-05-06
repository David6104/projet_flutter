import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/user_view_model.dart';
import '../viewmodels/cart_view_model.dart';
import 'history_screen.dart';
import 'add_article_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final email = userVM.user?.email ?? 'Utilisateur inconnu';

    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle, size: 50),
          title: const Text('Connecté en tant que :'),
          subtitle: Text(email), // Affiche l'email de l'utilisateur connecté
        ),
        const Divider(),
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
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title:
              const Text('Se déconnecter', style: TextStyle(color: Colors.red)),
          onTap: () async {
            // 1. Déconnecte l'utilisateur de Supabase
            await userVM.logout();

            if (context.mounted) {
              // 2. Vide le panier local pour éviter qu'un autre utilisateur ne le voit
              context.read<CartViewModel>().clearLocalCart();

              // 3. Renvoie de force à la page de connexion
              context.go('/login');
            }
          },
        ),
      ],
    );
  }
}
