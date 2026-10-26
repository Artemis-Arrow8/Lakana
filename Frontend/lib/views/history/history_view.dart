import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../services/api_service.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _historyList = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  // Récupération de l'historique depuis l'API avec gestion du mode hors-ligne / fallback
  Future<void> _fetchHistory() async {
    try {
      final data = await _apiService.getHistory();
      setState(() {
        _historyList = data;
        _isLoading = false;
      });
    } catch (e) {
      // En cas d'erreur réseau ou CORS, on affiche une liste vide propre au lieu de bloquer l'app
      setState(() {
        _historyList = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0), // Fond sable doux AES unifié
      appBar: AppBar(
        title: const Text('Historique des analyses', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: SahelSecTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: SahelSecTheme.accentOrange,
              ),
            )
          : _historyList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: SahelSecTheme.primaryGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.history_edu_outlined,
                            size: 48,
                            color: SahelSecTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Aucun historique d'analyse",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: SahelSecTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Vos vérifications de messages, liens et décrets s'afficheront ici pour assurer votre suivi sécuritaire.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: SahelSecTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _historyList.length,
                  itemBuilder: (context, index) {
                    final item = _historyList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                      child: ListTile(
                        leading: const Icon(
                          Icons.shield_outlined,
                          color: SahelSecTheme.primaryGreen,
                        ),
                        title: Text(
                          item['content'] ?? 'Élément analysé',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: SahelSecTheme.textDark,
                          ),
                        ),
                        subtitle: Text(
                          'Statut : ${item['status'] ?? 'Vérifié'}',
                          style: const TextStyle(color: SahelSecTheme.textMuted),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}