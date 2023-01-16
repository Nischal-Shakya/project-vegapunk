import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/driving_license.dart';

class DrivingLicenseScreen extends StatelessWidget {
  const DrivingLicenseScreen({super.key});

  static const routeName = '/driving_license_screen';

  @override
  Widget build(BuildContext context) {
    final drivingLicenseData =
        Provider.of<DrivingLicense>(context, listen: false).drivingLicenseData;
    return Scaffold(
      appBar: AppBar(title: const Text('Driving License Card')),
      body: Column(
        children: [
          Text(drivingLicenseData.name),
          Text(drivingLicenseData.licenseNumber),
        ],
      ),
    );
  }
}
