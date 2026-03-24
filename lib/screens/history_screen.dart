import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/local_storage.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final data = await LocalStorage.loadHistory();
    setState(() => _history = data.reversed.toList()); // Plus récent en haut
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des achats')),
      body: _history.isEmpty
          ? const Center(child: Text('Aucun achat précédent.'))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final order = _history[index];
                final date = DateTime.parse(order['date']);
                final formattedDate =
                    DateFormat('dd/MM/yyyy à HH:mm').format(date);
                final itemsCount = (order['items'] as List).length;

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading:
                        const Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Commande du $formattedDate'),
                    subtitle: Text('$itemsCount article(s)'),
                    trailing: Text('${order['total']} €',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                );
              },
            ),
    );
  }
}
