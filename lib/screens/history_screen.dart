import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final data = await LocalStorage.loadHistory();
      setState(() {
        _history = data.reversed
            .toList(); // Affiche la commande la plus récente en haut
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Erreur lors du chargement de l'historique : $e");
    }
  }

  // Fonction pour formater la date sans avoir besoin du package 'intl'
  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$day/$month/$year à $hour:$minute';
    } catch (e) {
      return 'Date inconnue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des achats')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off,
                          size: 80, color: Colors.grey),
                      SizedBox(height: 20),
                      Text('Aucun achat précédent.',
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final order = _history[index];

                    // Récupération et vérification des données de la commande
                    final dateStr = order['date']?.toString() ?? '';
                    final formattedDate = _formatDate(dateStr);

                    int itemsCount = 0;
                    if (order['items'] != null && order['items'] is List) {
                      itemsCount = (order['items'] as List).length;
                    }

                    // Formatage du prix
                    final total = order['total'] != null
                        ? (order['total'] as num).toStringAsFixed(2)
                        : '0.00';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.check_circle,
                            color: Colors.green, size: 40),
                        title: Text('Commande du $formattedDate',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('$itemsCount article(s) acheté(s)'),
                        trailing: Text('$total €',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green)),
                      ),
                    );
                  },
                ),
    );
  }
}
