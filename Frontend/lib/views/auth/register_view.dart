import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../main.dart'; // Pour rediriger vers MainNavigationShell après l'inscription

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleRegister() {
    setState(() => _isLoading = true);
    
    // Simulation d'un enregistrement de compte
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès ! Bienvenue sur SahelSec.")),
      );

      // Redirection vers l'application principale (onglets)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Créer un compte"),
        backgroundColor: SahelSecTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Icon(Icons.shield_outlined, size: 64, color: SahelSecTheme.primaryGreen),
              ),
              const SizedBox(height: 16),
              const Text(
                "Rejoignez SahelSec",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: SahelSecTheme.textDark),
              ),
              const SizedBox(height: 8),
              const Text(
                "Protégez vos communications et contribuez à la sécurité citoyenne au Sahel.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: SahelSecTheme.textMuted),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nom complet",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Adresse e-mail",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SahelSecTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text("S'inscrire", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}