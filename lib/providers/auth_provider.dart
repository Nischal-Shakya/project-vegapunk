// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//data,token,mpin,first login, darkmode, fingerprint;

// userData: documents
// userPreferences:  darkMode
// authData: isBiometricEnabled, MPIN, token, NIN, mobileNumber

final userDataBox = Hive.box("userData");
final userPreferencesBox = Hive.box("userPreferences");
final authDataBox = Hive.box("authData");

class AuthDataProvider with ChangeNotifier {
  bool isBiometricEnabled = authDataBox.get('isBiometricEnabled') ?? false;
  String? MPIN = authDataBox.get('MPIN');
  String? token = authDataBox.get('token');
  String? NIN = authDataBox.get('NIN');
  String? mobileNumber = authDataBox.get('mobileNumber');

  // AuthDataProvider() {
  //   // If internet is connected
  //   // Check if token is valid.
  //   // if not valid logout

  //   syncWithDB();
  // }

  // void syncWithDB() async {
  //   log("Syncing authData Provider with DB");
  //   isBiometricEnabled = authDataBox.get('isBiometricEnabled') ?? false;
  //   MPIN = authDataBox.get('MPIN');
  //   token = authDataBox.get('token');
  //   NIN = authDataBox.get('NIN');
  //   mobileNumber = authDataBox.get('mobileNumber');

  //   notifyListeners();
  // }

  void setToken(String token) {
    authDataBox.put('token', token);
    this.token = token;
    notifyListeners();
  }

  void setMPIN(String MPIN) {
    authDataBox.put('MPIN', MPIN);
    this.MPIN = MPIN;
    notifyListeners();
  }

  void setMobileNumber(String mobileNumber) {
    authDataBox.put('mobileNumber', mobileNumber);
    this.mobileNumber = mobileNumber;
    notifyListeners();
  }

  void setNIN(String NIN) {
    authDataBox.put('NIN', NIN);
    this.NIN = NIN;
    notifyListeners();
  }

  void setIsBiometricEnabled(bool isBiometricEnabled) {
    authDataBox.put('isBiometricEnabled', isBiometricEnabled);
    this.isBiometricEnabled = isBiometricEnabled;
    notifyListeners();
  }

  Future<void> logout() async {
    log("Deleting data from box");
    await Hive.box("userData").clear();
    await Hive.box("userPreferences").clear();
    await Hive.box("authData").clear();

    log("Deleting data from state");
    isBiometricEnabled = false;
    MPIN = null;
    token = null;
    NIN = null;
    mobileNumber = null;

    notifyListeners();
  }
}
