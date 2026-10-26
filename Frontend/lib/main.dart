import 'package:flutter/material.dart';
import 'views/home/home_view.dart';
import 'views/report/report_view.dart';
import 'views/history/history_view.dart';
import 'views/payment/payment_view.dart';
import 'views/profile/profile_view.dart'; // Import de la page Profil
import 'views/onboarding/onboarding_view.dart';

void main() {
  runApp(const SahelSecApp());
}

class SahelSecApp extends StatelessWidget {
  const SahelSecApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SahelSec',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF9F6F0), // Fond sable doux AES
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A4022), // Vert SahelSec
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A4022),
          primary: const Color(0xFF0A4022),
          secondary: const Color(0xFFF18A00), // Orange solaire
        ),
        useMaterial3: true,
      ),
      home: OnboardingView(),
    );
  }
}

/// Coque de navigation principale gérant le basculement entre les 5 onglets
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({Key? key}) : super(key: key);

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // Liste des 5 écrans accessibles via la barre de navigation du bas
  final List<Widget> _screens = [
    const HomeView(),
    const ReportView(),
    const HistoryView(),
    const PaymentView(),
    const ProfileView(), // Ajout de l'onglet Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF0A4022), // Vert SahelSec
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.security_outlined),
            activeIcon: Icon(Icons.security),
            label: 'Vérifier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem_outlined),
            activeIcon: Icon(Icons.report_problem),
            label: 'Signaler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium_outlined),
            activeIcon: Icon(Icons.workspace_premium),
            label: 'Premium',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}