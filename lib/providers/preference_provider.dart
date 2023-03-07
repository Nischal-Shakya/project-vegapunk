import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final userPreferencesBox = Hive.box("userPreferences");

class PreferencesProvider with ChangeNotifier {
  bool darkMode = userPreferencesBox.get("darkMode") ?? false;

  void setDarkMode(bool darkMode) {
    Hive.box("userPreferences").put("darkMode", darkMode);
    this.darkMode = darkMode;
    notifyListeners();
  }
}
