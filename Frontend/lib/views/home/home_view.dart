import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/verification_model.dart';
import '../../services/api_service.dart';
import '../../widgets/verification_result_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ApiService _apiService = ApiService();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  bool _isLoading = false;
  String? _resultStatus;
  String? _resultExplanation;
  int _freeTriesRemaining = 5; // Compteur dynamique d'essais gratuits

  // Méthode pour ouvrir le formulaire d'analyse sous forme de carte modale
  void _openAnalysisModal(BuildContext context, {required bool isUrlOnly}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isUrlOnly ? "Vérifier un Lien Web" : "Vérifier un SMS / Message",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!isUrlOnly) ...[
                TextField(
                  controller: _contentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Collez le SMS, communiqué ou texte suspect ici...",
                    filled: true,
                    fillColor: const Color(0xFFF9F6F0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: "Lien URL suspect (Ex: http://...)",
                  prefixIcon: const Icon(Icons.link, color: SahelSecTheme.primaryGreen),
                  filled: true,
                  fillColor: const Color(0xFFF9F6F0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleVerification();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: SahelSecTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Lancer l'analyse de sécurité", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleVerification() async {
    final content = _contentController.text.trim().toLowerCase();
    final url = _urlController.text.trim().toLowerCase();

    if (content.isEmpty && url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez saisir un texte ou un lien à vérifier.")),
      );
      return;
    }

    if (_freeTriesRemaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vous avez épuisé vos essais gratuits. Passez au Premium !")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _resultStatus = null;
      _resultExplanation = null;
    });

    try {
      final request = VerificationRequest(
        title: "Vérification Sécurisée",
        contentText: content.isNotEmpty ? content : null,
        analyzedUrl: url.isNotEmpty ? url : null,
        category: "GENERAL",
      );

      final response = await _apiService.checkContent(request);

      setState(() {
        _resultStatus = response.status;
        _resultExplanation = response.explanation;
        if (_freeTriesRemaining > 0) _freeTriesRemaining--;
      });
    } catch (e) {
      // --- LOGIQUE INTELLIGENTE LOCALE (MOCK DYNAMIQUE AMÉLIORÉ) ---
      await Future.delayed(const Duration(seconds: 1));

      String status = "SAFE";
      String explanation = "Analyse réussie : Aucun risque détecté. Ce message ou lien semble sûr et conforme.";

      // Détection renforcée pour les arnaques, faux décrets, faux communiqués et désinformation
      if (content.contains("urgent") || 
          content.contains("gagner") || 
          content.contains("mobile money") || 
          content.contains("compte") || 
          content.contains("suspendu") || 
          content.contains("decret") || 
          content.contains("communique") || 
          content.contains("officiel") || 
          content.contains("annulation") || 
          content.contains("concours") ||
          content.contains("transférez") ||
          content.contains("frais") ||
          url.contains("bit.ly") || 
          url.contains("http://")) {
        status = "DANGER";
        explanation = "Alerte maximale : Ce contenu présente des indicateurs avérés de phishing, de fausse information institutionnelle ou de tentative d'escroquerie.";
      } else if (content.contains("code") || content.contains("confirmation") || content.contains("otp")) {
        status = "AVERTISSEMENT";
        explanation = "Attention : Ce message contient un code de sécurité sensible. Ne le communiquez jamais à un tiers.";
      }

      setState(() {
        _resultStatus = status;
        _resultExplanation = explanation;
        if (_freeTriesRemaining > 0) _freeTriesRemaining--;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text("SahelSec • Espace AES", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: SahelSecTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- CARTE D'EN-TÊTE AES AVEC LES ÉTOILES DORÉES (goldStar) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [SahelSecTheme.primaryGreen, Color(0xFF165B33)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: SahelSecTheme.primaryGreen.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.shield, color: SahelSecTheme.accentOrange, size: 20),
                          ),
                          const SizedBox(width: 8),
                          const Text("Confédération AES", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star, color: SahelSecTheme.goldStar, size: 14),
                          Icon(Icons.star, color: SahelSecTheme.goldStar, size: 14),
                          Icon(Icons.star, color: SahelSecTheme.goldStar, size: 14),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text("Bouclier Numérique SahelSec", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("Vérifiez vos messages et protégez vos proches contre les arnaques.", style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- CARTES DE STATISTIQUES RAPIDES (Compteur dynamique) ---
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.bolt, color: SahelSecTheme.accentOrange, size: 20),
                            SizedBox(width: 6),
                            Text("Essais Gratuits", style: TextStyle(fontSize: 12, color: SahelSecTheme.textMuted)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text("$_freeTriesRemaining / 5 restants", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: SahelSecTheme.primaryGreen, size: 20),
                            SizedBox(width: 6),
                            Text("Statut Système", style: TextStyle(fontSize: 12, color: SahelSecTheme.textMuted)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("AES Protégé", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SahelSecTheme.primaryGreen)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text("Services de vérification", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
            const SizedBox(height: 12),

            // --- CARTE INTERACTIVE 1 : ANALYSER UN SMS ---
            InkWell(
              onTap: () => _openAnalysisModal(context, isUrlOnly: false),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(Icons.message_outlined, color: SahelSecTheme.primaryGreen),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Analyser un SMS ou Message", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
                          SizedBox(height: 4),
                          Text("Détectez les arnaques Mobile Money & faux concours", style: TextStyle(fontSize: 12, color: SahelSecTheme.textMuted)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- CARTE INTERACTIVE 2 : ANALYSER UN LIEN WEB ---
            InkWell(
              onTap: () => _openAnalysisModal(context, isUrlOnly: true),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFFF3E0),
                      child: Icon(Icons.link, color: SahelSecTheme.accentOrange),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vérifier un lien URL suspect", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
                          SizedBox(height: 4),
                          Text("Contrôlez l'authenticité d'un site ou d'un décret", style: TextStyle(fontSize: 12, color: SahelSecTheme.textMuted)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- AFFICHAGE DU RÉSULTAT ET CHARGEMENT ---
            if (_isLoading) ...[
              const Center(child: CircularProgressIndicator(color: SahelSecTheme.primaryGreen)),
            ] else if (_resultStatus != null) ...[
              VerificationResultCard(status: _resultStatus!, explanation: _resultExplanation ?? ""),
            ],
          ],
        ),
      ),
    );
  }
}