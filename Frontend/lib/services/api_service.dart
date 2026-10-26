import 'package:dio/dio.dart';
import 'dart:io';
import '../models/verification_model.dart';
import '../models/report_model.dart';

class ApiService {
  late final Dio _dio;

  // URL de base de ton backend FastAPI
  // - Utilise 'http://10.0.2.2:8000/api/v1' pour l'émulateur Android.
  // - Utilise ton IP locale (ex: 'http://192.168.1.15:8000/api/v1') pour un vrai téléphone.
  // - Utilise 'http://localhost:8000/api/v1' si tu testes sur le navigateur web.
  final String baseUrl = "http://192.168.1.X:8000/api/v1";

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30), // Timeout de connexion fixé à 30s
      receiveTimeout: const Duration(seconds: 30), // Timeout de réception fixé à 30s
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  /// 1. Vérification de texte, SMS ou URL suspecte
  Future<VerificationResponse> checkContent(VerificationRequest request) async {
    try {
      final response = await _dio.post(
        '/verifications/check',
        data: request.toJson(),
      );
      return VerificationResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Gestion spécifique de la limite Freemium atteinte (Code HTTP 403)
      if (e.response?.statusCode == 403) {
        throw Exception("LIMITE_ATTEINTE : Vous avez épuisé vos analyses gratuites.");
      }
      throw Exception("Erreur lors de la vérification : ${e.message}");
    }
  }

  /// 2. Vérification d'image par OCR (faux décrets, affiches suspectes, etc.)
  Future<VerificationResponse> checkImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/verifications/check-image',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return VerificationResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception("LIMITE_ATTEINTE : Vous avez épuisé vos analyses gratuites.");
      }
      throw Exception("Erreur lors de l'analyse d'image : ${e.message}");
    }
  }

  /// 3. Soumission d'un signalement citoyen (arnaques, faux numéros)
  Future<ReportResponse> createReport(ReportRequest request) async {
    try {
      final response = await _dio.post(
        '/reports/',
        data: request.toJson(),
      );
      return ReportResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Erreur lors du signalement : ${e.message}");
    }
  }

  /// 4. Initiation d'un paiement Mobile Money (Orange, Moov, Wave) pour passer au statut Premium
  Future<Map<String, dynamic>> initiateCheckout({
    required String phoneNumber,
    required String provider,
    required String planType,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/checkout',
        data: {
          'phone_number': phoneNumber,
          'provider': provider,
          'plan_type': planType,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final detail = e.response?.data != null && e.response?.data is Map
          ? e.response?.data['detail']
          : e.message;
      throw Exception("Erreur lors du paiement : $detail");
    }
  }

  /// 5. Récupération de l'historique des vérifications de l'utilisateur
  Future<List<dynamic>> getHistory() async {
    try {
      final response = await _dio.get('/history/verifications');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception("Erreur lors de la récupération de l'historique : ${e.message}");
    }
  }
}