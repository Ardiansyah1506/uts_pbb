import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }
}
