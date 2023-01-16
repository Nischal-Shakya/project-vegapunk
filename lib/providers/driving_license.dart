import 'package:flutter/material.dart';
import '../models/driving_license_model.dart';

class DrivingLicense with ChangeNotifier {
  DrivingLicenseModel drivingLicense =
      DrivingLicenseModel('Dr-1', 'Nischal Shakya');

  DrivingLicenseModel get drivingLicenseData {
    return drivingLicense;
  }
}
