import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToggleProvider with ChangeNotifier {
  bool isDarkMode = Hive.box("allData").get("darkmode");
  bool isBiometricEnabled = Hive.box("allData").get("enableFingerprint");

  void changeTheme(bool value) {
    isDarkMode = value;
    Hive.box("allData").put("darkmode", value);
    notifyListeners();
  }

  void changeBiometrics(bool value) {
    isBiometricEnabled = value;
    Hive.box("allData").put("enableFingerprint", value);
    notifyListeners();
  }
}