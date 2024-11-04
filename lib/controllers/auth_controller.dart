import 'package:flutter/material.dart';
import '../services/shared_preferences_service.dart';

class AuthController {
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  Future<void> register(String username, String password) async {
    await _prefsService.saveUsername(username);
    await _prefsService.savePassword(password);
  }

  Future<void> login(String username, String password) async {
    String? savedPassword = await _prefsService.getPassword();
    if (savedPassword == password) {
      await _prefsService.saveUsername(username);
    } else {
      throw Exception('Password tidak valid');
    }
  }

  Future<String?> getUsername() async {
    return await _prefsService.getUsername();
  }
}
