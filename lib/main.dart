import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/qr_scan_screen.dart';
import 'package:parichaya_frontend/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import 'providers/global_theme.dart';
import 'providers/documents.dart';
import '../providers/driving_license.dart';
import '../providers/national_id.dart';
import '../providers/preferences.dart';

import './screens/homescreen.dart';
import './screens/national_identity_screen.dart';
import './screens/driving_license_screen.dart';
import './screens/error_screen.dart';
import './screens/login_screen.dart';
import './screens/login_mobile_screen.dart';
import './screens/login_otp_screen.dart';
import './screens/data_transfer_permission_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = Preferences.noSync();
  await prefs.syncToSharedPreferences();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Preferences>(create: (context) => prefs),
    ChangeNotifierProvider<Documents>(
      create: (context) => Documents(),
    ),
    Provider<GlobalTheme>(
      create: (context) => GlobalTheme(),
    ),
    ChangeNotifierProvider<NationalId>(create: (context) => NationalId()),
    ChangeNotifierProvider<DrivingLicense>(
        create: (context) => DrivingLicense()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData globalTheme = Provider.of<GlobalTheme>(context).globalTheme;
    return Consumer<Preferences>(builder: (context, prefs, child) {
      return MaterialApp(
          title: 'Parichaya',
          theme: globalTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: prefs.jwtToken.isEmpty ? LoginScreen.routeName : '/',
          routes: {
            '/': (ctx) => const HomeScreen(),
            NationalIdentityScreen.routeName: (ctx) =>
                const NationalIdentityScreen(),
            DrivingLicenseScreen.routeName: (ctx) =>
                const DrivingLicenseScreen(),
            ErrorScreen.routeName: (ctx) => const ErrorScreen(),
            SettingsScreen.routeName: (ctx) => const SettingsScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            LoginMobileScreen.routeName: (ctx) => LoginMobileScreen(),
            LoginOtpScreen.routeName: (ctx) => const LoginOtpScreen(),
            DataPermissionScreen.routeName: (ctx) =>
                const DataPermissionScreen(),
            QrScanScreen.routeName: (ctx) => const QrScanScreen(),
          });
    });
  }
}
