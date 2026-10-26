import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../auth/register_view.dart';
import '../../main.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Bienvenue sur SahelSec 🛡️",
      "subtitle": "Nous sommes là pour garantir votre sécurité en ligne, empêcher les arnaques, le phishing et la propagation de faux décrets administratifs dans l'espace AES.",
    },
    {
      "title": "5 Essais Gratuits 🎁",
      "subtitle": "Testez notre intelligence artificielle dès maintenant ! Vous avez droit à 5 essais gratuits pour analyser vos SMS et liens suspects en toute tranquillité.",
    },
    {
      "title": "Passez au Premium 🚀",
      "subtitle": "Au-delà de vos essais gratuits, profitez d'un accès illimité pour seulement 1 000 XOF par mois via Mobile Money (Orange, Moov, Wave).",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0), // Fond sable doux inspiré de l'AES
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Bouton Passer en haut à droite
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigationShell()),
                    );
                  },
                  child: const Text(
                    "Passer",
                    style: TextStyle(color: SahelSecTheme.primaryGreen, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              // Zone de défileing des cartes d'onboarding
              Expanded(
                flex: 4,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: SahelSecTheme.primaryGreen.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: SahelSecTheme.accentOrange.withOpacity(0.3), width: 2),
                            ),
                            child: const Icon(Icons.security, size: 65, color: SahelSecTheme.primaryGreen),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            _onboardingData[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: SahelSecTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _onboardingData[index]["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: SahelSecTheme.textMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Indicateurs de points (pagination)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? SahelSecTheme.primaryGreen : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Bouton d'action principal
              ElevatedButton(
                onPressed: () {
                  if (_currentPage < _onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterView()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SahelSecTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: Text(
                  _currentPage == _onboardingData.length - 1 ? "Créer un compte / Commencer" : "Suivant",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              
              if (_currentPage == _onboardingData.length - 1)
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigationShell()),
                    );
                  },
                  child: const Text(
                    "Commencer l'essai gratuit sans compte",
                    style: TextStyle(color: SahelSecTheme.accentOrange, fontWeight: FontWeight.w600),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}