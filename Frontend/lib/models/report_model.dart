/// Modèle de données pour envoyer un signalement citoyen au backend FastAPI.
class ReportRequest {
  final String phoneNumberReported;
  final String description;
  final String category;

  ReportRequest({
    required this.phoneNumberReported,
    required this.description,
    required this.category,
  });

  /// Convertit l'objet Dart en JSON pour la requête HTTP POST.
  Map<String, dynamic> toJson() {
    return {
      'phone_number_reported': phoneNumberReported,
      'description': description,
      'category': category,
    };
  }
}

/// Modèle de réponse pour un signalement.
class ReportResponse {
  final int id;
  final String phoneNumberReported;
  final String description;
  final String category;
  final String createdAt;

  ReportResponse({
    required this.id,
    required this.phoneNumberReported,
    required this.description,
    required this.category,
    required this.createdAt,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      id: json['id'] ?? 0,
      phoneNumberReported: json['phone_number_reported'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'GENERAL',
      createdAt: json['created_at'] ?? '',
    );
  }
}