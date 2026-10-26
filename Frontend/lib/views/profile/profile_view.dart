import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../auth/register_view.dart';
import '../payment/payment_view.dart'; // Import de la page de paiement (ajuste le chemin si besoin)
import 'about_view.dart';
import 'security_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text("Mon Profil Citoyen", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: SahelSecTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- CARTE D'IDENTIFICATION DU PROFIL ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: SahelSecTheme.primaryGreen,
                    child: Icon(Icons.person, size: 36, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Citoyen SahelSec",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "citoyen@sahelsec.aes",
                          style: TextStyle(fontSize: 13, color: SahelSecTheme.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: SahelSecTheme.accentOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Compte Freemium (Protection AES active)",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: SahelSecTheme.accentOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- OPTIONS DU PROFIL ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  // 1. Redirection active vers la page de paiement Premium
                  ListTile(
                    leading: const Icon(Icons.workspace_premium, color: SahelSecTheme.accentOrange),
                    title: const Text("Passer à l'offre Premium", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Accès illimité pour 1 000 XOF/mois"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentView()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // 2. Redirection vers la page Sécurité
                  ListTile(
                    leading: const Icon(Icons.security, color: SahelSecTheme.primaryGreen),
                    title: const Text("Sécurité et confidentialité", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Politique de protection des données AES"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecurityView()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // 3. Redirection vers la page À propos
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: SahelSecTheme.primaryGreen),
                    title: const Text("À propos de SahelSec", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Version 1.0.0 • Concours AMRTP / AES"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutView()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- BOUTON DE DÉCONNEXION ---
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterView()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text("Se déconnecter", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.redAccent, width: 1),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}