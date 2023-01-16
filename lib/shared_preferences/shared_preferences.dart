import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const jwtTokenKey = "JwtTokenKey";

  static final SharedPrefs _sharedPrefs = SharedPrefs._internal();
  factory SharedPrefs() => _sharedPrefs;
  SharedPrefs._internal();

  static SharedPreferences? _instance;

  Future<SharedPreferences> get instance async {
    if (_instance != null) return _instance!;
    _instance = await _initPrefInstance();
    return _instance!;
  }

  Future<SharedPreferences> _initPrefInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setJWTtoken(String token) async {
    log('Completing set token');
    final prefInstance = await _sharedPrefs.instance;
    prefInstance.setString(SharedPrefs.jwtTokenKey, token);
  }

  Future<String> getJWTtoken() async {
    log('Getting token');
    final prefInstance = await _sharedPrefs.instance;
    final token = prefInstance.getString(SharedPrefs.jwtTokenKey) ?? '';
    return token;
  }
}
