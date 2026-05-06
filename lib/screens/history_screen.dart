import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // On récupère les commandes de cet utilisateur spécifique sur Supabase
        final data = await Supabase.instance.client
            .from('orders')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false);

        setState(() => _history = data);
      }
    } catch (e) {
      debugPrint("Erreur historique : $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final min = date.minute.toString().padLeft(2, '0');
      return '$day/$month/$year à $hour:$min';
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
              ? const Center(child: Text('Aucun achat précédent.'))
              : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final order = _history[index];
                    final dateStr = order['created_at']?.toString() ?? '';
                    final formattedDate = _formatDate(dateStr);

                    int itemsCount = 0;
                    if (order['items'] != null) {
                      itemsCount = (order['items'] as List).length;
                    }

                    final total = order['total'] != null
                        ? (order['total'] as num).toStringAsFixed(2)
                        : '0.00';

                    return ListTile(
                      leading:
                          const Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Commande du $formattedDate'),
                      subtitle: Text('$itemsCount article(s) acheté(s)'),
                      trailing: Text('$total €',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    );
                  },
                ),
    );
  }
}
