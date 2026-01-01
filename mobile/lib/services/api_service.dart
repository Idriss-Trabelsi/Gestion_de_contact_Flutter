// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000"; // Pour émulateur Android
  // static const String baseUrl = "http://localhost:8000"; // Pour iOS/Web
  // static const String baseUrl = "http://VOTRE_IP:8000"; // Pour appareil physique
  
  static const Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  // ==================== USER ENDPOINTS ====================

  // Inscription d'un utilisateur
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur d\'inscription');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Connexion d'un utilisateur
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Identifiants incorrects');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ==================== CONTACT ENDPOINTS ====================

  // Créer un contact
  static Future<Map<String, dynamic>> createContact({
    required String username,
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/contacts?username=$username'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'email': email ?? '',
          'address': address ?? '',
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur de création du contact');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir tous les contacts d'un utilisateur
  static Future<List<dynamic>> getAllContacts(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contacts?username=$username'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur de récupération des contacts');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Modifier un contact
  static Future<Map<String, dynamic>> updateContact({
    required String username,
    required int contactId,
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/contacts/$contactId?username=$username'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'email': email ?? '',
          'address': address ?? '',
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur de mise à jour du contact');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un contact
  static Future<Map<String, dynamic>> deleteContact({
    required String username,
    required int contactId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/contacts/$contactId?username=$username'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur de suppression du contact');
      }
    } catch (e) {
      rethrow;
    }
  }
}