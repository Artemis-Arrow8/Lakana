import 'package:flutter/material.dart';

class SahelSecTheme {
  // Couleurs officielles inspirées du drapeau de l'AES
  static const Color primaryGreen = Color(0xFF0A4022); // Vert sahélien profond
  static const Color accentOrange = Color(0xFFF18A00); // Orange / Jaune soleil levant
  static const Color alertRed = Color(0xFFD32F2F);    // Rouge vif institutionnel
  static const Color goldStar = Color(0xFFFFD700);    // Or des étoiles (S majuscule)
  
  static const Color backgroundLight = Color(0xFFF9F6F0); // Blanc cassé / Sable très doux
  static const Color surfaceCard = Colors.white;
  
  static const Color textDark = Color(0xFF1E2A22);
  static const Color textMuted = Color(0xFF687A6E);

  // Thème global de l'application
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: accentOrange,
        error: alertRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}