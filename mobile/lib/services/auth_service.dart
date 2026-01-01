// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  static const String _userKey = 'current_user';
  Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;
  String? get currentUsername => _currentUser?['username'];
  bool get isLoggedIn => _currentUser != null;

  // Initialiser depuis le stockage local
  Future<void> init() async {
    // Vous pouvez stocker l'utilisateur localement si besoin
    // Pour l'instant, on garde juste en mémoire
  }

  void setUser(Map<String, dynamic> user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Vérifier si l'utilisateur est connecté
  bool isUserLoggedIn() {
    return _currentUser != null && _currentUser!['username'] != null;
  }
}