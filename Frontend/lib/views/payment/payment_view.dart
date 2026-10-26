import 'package:flutter/material.dart';
import '../../core/theme.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String _selectedPlan = "MENSUEL";
  String _selectedOperator = "Orange Money";
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text("SahelSec • Espace Premium", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: SahelSecTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- CARTE D'EN-TÊTE PREMIUM ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [SahelSecTheme.primaryGreen, Color(0xFF165B33)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.workspace_premium, color: SahelSecTheme.goldStar, size: 26),
                      SizedBox(width: 10),
                      Text("Sécurisez vos accès illimités", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Passez au niveau supérieur et profitez d'une protection renforcée sans aucune limite d'analyse.",
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text("1. Choisissez votre formule", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
            const SizedBox(height: 12),

            // --- CARTES DE SÉLECTION DE FORFAIT ---
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedPlan = "MENSUEL"),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _selectedPlan == "MENSUEL" ? SahelSecTheme.accentOrange : Colors.grey.shade300,
                          width: _selectedPlan == "MENSUEL" ? 2 : 1,
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mensuel", style: TextStyle(fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
                          SizedBox(height: 8),
                          Text("1 000 XOF", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SahelSecTheme.accentOrange)),
                          Text("par mois", style: TextStyle(fontSize: 11, color: SahelSecTheme.textMuted)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedPlan = "ANNUEL"),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _selectedPlan == "ANNUEL" ? SahelSecTheme.accentOrange : Colors.grey.shade300,
                          width: _selectedPlan == "ANNUEL" ? 2 : 1,
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Annuel (-15%)", style: TextStyle(fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
                          SizedBox(height: 8),
                          Text("10 000 XOF", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SahelSecTheme.accentOrange)),
                          Text("par an", style: TextStyle(fontSize: 11, color: SahelSecTheme.textMuted)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text("2. Opérateur Mobile Money", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _selectedOperator,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
              items: ["Orange Money", "Moov Money", "Wave"].map((op) {
                return DropdownMenuItem(value: op, child: Text(op));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedOperator = val);
              },
            ),
            const SizedBox(height: 20),

            const Text("3. Numéro de compte débité", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
            const SizedBox(height: 12),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "+223 70 00 00 00",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Demande de paiement transmise. Validez sur votre mobile.")),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: SahelSecTheme.accentOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Payer ${_selectedPlan == "MENSUEL" ? "1 000 XOF" : "10 000 XOF"} et Activer",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}