import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import 'home.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _dontShowAgain = false;

  void _continue() async {
    if (_dontShowAgain) {
      await LocalStorage.setHideWelcomeScreen(true);
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.store, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text('Bienvenue sur Bloc2 Store !',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Achetez et vendez vos articles en toute simplicité.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _dontShowAgain,
                    onChanged: (val) => setState(() => _dontShowAgain = val!),
                  ),
                  const Text('Ne plus afficher cet écran')
                ],
              ),
              ElevatedButton(
                onPressed: _continue,
                child: const Text('Commencer'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
