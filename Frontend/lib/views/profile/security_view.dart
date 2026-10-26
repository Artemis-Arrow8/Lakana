import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text("Sécurité et confidentialité", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: SahelSecTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  Row(
                    children: [
                      Icon(Icons.security, color: SahelSecTheme.primaryGreen, size: 28),
                      SizedBox(width: 12),
                      Text("Politique de protection AES", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
                    ],
                  ),
                  Divider(height: 24),
                  Text(
                    "Conformément aux exigences de la Confédération des États du Sahel (AES), toutes les données transmises lors de vos analyses de liens, messages et signalements sont strictement chiffrées.\n\n"
                    "• Chiffrement de bout en bout des requêtes.\n"
                    "• Anonymat garanti des signalements citoyens.\n"
                    "• Aucune revente de données personnelles à des tiers.",
                    style: TextStyle(fontSize: 14, color: SahelSecTheme.textDark, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}