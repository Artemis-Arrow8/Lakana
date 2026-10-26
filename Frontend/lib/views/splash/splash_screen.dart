import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/theme.dart';
import '../../main.dart'; // Importe MainNavigationShell depuis main.dart

/// Écran d'accueil temporaire (Splash Screen) affiché au lancement.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();

    // Redirection automatique vers MainNavigationShell après 2.5 secondes
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationShell()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SahelSecTheme.primaryGreen,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: SahelSecTheme.accentOrange.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 64,
                    color: SahelSecTheme.accentOrange,
                  ),
                ),
                
                const SizedBox(height: 24),

                const Text(
                  'SAHELSEC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                  ),
                ),
                
                const SizedBox(height: 8),

                Text(
                  'Protection & Cybersécurité AES',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                  ),
                ),

                const Spacer(),

                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      SahelSecTheme.accentOrange,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}