import 'package:flutter/material.dart';
import '../shared_preferences/shared_preferences.dart';

class Preferences with ChangeNotifier {
  String _jwtToken = '';

  final SharedPrefs _sharedPrefs = SharedPrefs();
  Preferences.noSync();
  Preferences() {
    syncToSharedPreferences();
  }
  Future<void> syncToSharedPreferences() async {
    _jwtToken = await _sharedPrefs.getJWTtoken();
    notifyListeners();
  }

  String get jwtToken {
    return _jwtToken;
  }

  Future<void> setJwtToken(String token) async {
    _jwtToken = token;
    _sharedPrefs.setJWTtoken(token);
    notifyListeners();
  }
}
