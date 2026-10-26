import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0), // Fond sable doux AES
      appBar: AppBar(
        title: const Text("À propos de SahelSec", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: SahelSecTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- CARTE PRÉSENTATION ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: SahelSecTheme.primaryGreen,
                    child: Icon(Icons.shield, size: 40, color: SahelSecTheme.accentOrange),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "SahelSec (Espace AES)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Version 1.0.0 • Édition Concours AMRTP",
                    style: TextStyle(fontSize: 13, color: SahelSecTheme.textMuted),
                  ),
                  const Divider(height: 24),
                  const Text(
                    "Bouclier numérique intelligent conçu pour protéger les citoyens de la Confédération des États du Sahel (AES) contre les arnaques financières, le phishing Mobile Money et la désinformation institutionnelle.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: SahelSecTheme.textDark, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- CARTE DÉTAILS TECHNIQUES ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Technologies & Sécurité", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SahelSecTheme.primaryGreen)),
                  SizedBox(height: 12),
                  Text("• Frontend : Flutter / Dart (Responsive Mobile)\n• Backend : Django REST Framework / FastAPI\n• Sécurité : Analyse heuristique et chiffrement des données citoyennes.", 
                    style: TextStyle(fontSize: 13, color: SahelSecTheme.textDark, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}