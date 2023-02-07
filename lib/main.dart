import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/history_screen.dart';
import 'package:parichaya_frontend/screens/more_screen.dart';
import 'package:parichaya_frontend/screens/qr_scan_screen.dart';
import 'package:parichaya_frontend/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/global_theme.dart';
import '../providers/preferences.dart';
import 'providers/all_data.dart';

import './screens/homescreen.dart';
import './screens/error_screen.dart';
import './screens/login_screen.dart';
import './screens/login_mobile_screen.dart';
import './screens/login_otp_screen.dart';
import './screens/data_transfer_permission_screen.dart';
import './screens/national_id_screen.dart';
import './screens/mobile_pin_screen.dart';
import './screens/setup_pin_screen.dart';
import './screens/change_pin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('allData');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = Preferences.noSync();
  await prefs.syncToSharedPreferences();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Preferences>(create: (context) => prefs),
    Provider<AllData>(
      create: (context) => AllData(),
    ),
    Provider<GlobalTheme>(
      create: (context) => GlobalTheme(),
    ),
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
          initialRoute: prefs.jwtToken.isEmpty
              ? LoginScreen.routeName
              : MobilePinScreen.routeName,
          routes: {
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            HistoryScreen.routeName: (ctx) => const HistoryScreen(),
            MoreScreen.routeName: (ctx) => const MoreScreen(),
            ErrorScreen.routeName: (ctx) => const ErrorScreen(),
            SettingsScreen.routeName: (ctx) => const SettingsScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            LoginMobileScreen.routeName: (ctx) => LoginMobileScreen(),
            LoginOtpScreen.routeName: (ctx) => const LoginOtpScreen(),
            DataPermissionScreen.routeName: (ctx) =>
                const DataPermissionScreen(),
            QrScanScreen.routeName: (ctx) => const QrScanScreen(),
            NationalIdentityScreen.routeName: (ctx) =>
                const NationalIdentityScreen(),
            MobilePinScreen.routeName: (ctx) => const MobilePinScreen(),
            SetupPinScreen.routeName: (ctx) => const SetupPinScreen(),
            ChangePinScreen.routeName: (ctx) => const ChangePinScreen(),
          });
    });
  }
}
