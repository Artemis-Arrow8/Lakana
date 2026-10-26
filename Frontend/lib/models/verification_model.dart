/// Modèle de données pour envoyer une requête de vérification au backend FastAPI.
class VerificationRequest {
  final String title;
  final String? contentText;
  final String? analyzedUrl;
  final String? phoneNumber;
  final String category;

  VerificationRequest({
    required this.title,
    this.contentText,
    this.analyzedUrl,
    this.phoneNumber,
    this.category = "GENERAL",
  });

  /// Convertit l'objet Dart en JSON pour la requête HTTP POST.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content_text': contentText,
      'analyzed_url': analyzedUrl,
      'phone_number': phoneNumber,
      'category': category,
    };
  }
}

/// Modèle de données pour structurer la réponse renvoyée par le backend.
class VerificationResponse {
  final bool success;
  final String status; // SÉCURISÉ, SUSPECT, DANGEREUX
  final String explanation;
  final String? category;

  VerificationResponse({
    required this.success,
    required this.status,
    required this.explanation,
    this.category,
  });

  /// Convertit le JSON reçu de l'API en objet Dart typé.
  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 'SÉCURISÉ',
      explanation: json['explanation'] ?? '',
      category: json['category'],
    );
  }
}