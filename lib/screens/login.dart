import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Ajouté pour AuthException
import '../viewmodels/user_view_model.dart';
import '../viewmodels/cart_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final userVM = context.read<UserViewModel>();
    final cartVM = context.read<CartViewModel>();

    try {
      if (_isLogin) {
        await userVM.login(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
      } else {
        await userVM.register(
            _emailCtrl.text.trim(), _passwordCtrl.text.trim());
      }

      if (mounted) {
        // On essaie de charger le panier, mais on ne bloque pas si le panier est vide
        try {
          await cartVM.loadCart();
        } catch (e) {
          debugPrint("Note: Aucun panier existant ou erreur mineure : $e");
        }

        // Connexion réussie : on va vers l'accueil
        context.go('/');
      }
      // CE BLOC CAPTURE LES ERREURS SUPABASE (ex: Mot de passe incorrect)
    } on AuthException catch (authError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(authError.message), // Affiche le message exact de Supabase
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur inattendue : $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Connexion' : 'Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(
                labelText:
                    'Mot de passe (min. 6 caractères)', // Rappel de la règle Supabase
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)),
                child: Text(_isLogin ? 'Se connecter' : 'Créer un compte',
                    style: const TextStyle(fontSize: 18)),
              ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin
                  ? 'Pas de compte ? S\'inscrire'
                  : 'Déjà un compte ? Se connecter'),
            )
          ],
        ),
      ),
    );
  }
}
