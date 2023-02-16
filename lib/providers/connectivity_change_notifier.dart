import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityChangeNotifier extends ChangeNotifier {
  ConnectivityChangeNotifier() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityResult = result;
      notifyListeners();
    });
  }
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  bool connectivity() {
    if (_connectivityResult == ConnectivityResult.wifi ||
        _connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else {
      return false;
    }
  }

  void initialLoad() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    _connectivityResult = connectivityResult;
  }
}
