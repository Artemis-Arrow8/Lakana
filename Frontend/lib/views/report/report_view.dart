import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = "ARNAQUE FINANCIÈRE";

  final List<String> _categories = [
    "ARNAQUE FINANCIÈRE",
    "FAUX DÉCRET / INSTITUTIONNEL",
    "PHISHING / LIEN SUSPECT",
    "AUTRE MENACE"
  ];

  void _openReportModal(BuildContext context) {
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
                  const Text(
                    "Signaler une fraude ou un faux décret",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Numéro de téléphone suspect (Optionnel)",
                  prefixIcon: const Icon(Icons.phone_outlined, color: SahelSecTheme.primaryGreen),
                  filled: true,
                  fillColor: const Color(0xFFF9F6F0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: "Catégorie de la menace",
                  filled: true,
                  fillColor: const Color(0xFFF9F6F0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13)));
                }).toList(), // <-- .toList() bien présent ici
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Décrivez les faits constatés...",
                  filled: true,
                  fillColor: const Color(0xFFF9F6F0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Signalement transmis avec succès aux autorités de l'AES.")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: SahelSecTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Envoyer le signalement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text("SahelSec • Signalement Citoyen", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: SahelSecTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- CARTE D'INFORMATION ---
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
                      Icon(Icons.report_problem, color: SahelSecTheme.accentOrange, size: 24),
                      SizedBox(width: 10),
                      Text("Veille Collaborative AES", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Aidez la communauté et les institutions en signalant les numéros frauduleux, les tentatives d'escroquerie ou les faux communiqués officiels.",
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- CARTE CLIQUABLE POUR LANCER LE SIGNALEMENT ---
            InkWell(
              onTap: () => _openReportModal(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: SahelSecTheme.accentOrange.withOpacity(0.4), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFFF3E0),
                      child: Icon(Icons.add_alert, color: SahelSecTheme.accentOrange),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nouveau Signalement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark)),
                          SizedBox(height: 4),
                          Text("Appuyez ici pour remplir le formulaire d'alerte", style: TextStyle(fontSize: 12, color: SahelSecTheme.textMuted)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}