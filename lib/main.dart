import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/about_parichaya_screen.dart';
import 'package:parichaya_frontend/screens/qr_scan_screen.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/global_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/documents_provider.dart';
import 'providers/preference_provider.dart';

import 'providers/connectivity_change_notifier.dart';
import 'providers/homescreen_index_provider.dart';

import './screens/verify_age_screen.dart';
import './screens/homescreen.dart';
import './screens/error_screen.dart';
import './screens/login_screen.dart';
import './screens/login_mobile_screen.dart';
import './screens/login_otp_screen.dart';
import './screens/data_transfer_permission_screen.dart';
import 'screens/document_detail_screen.dart';
import './screens/mobile_pin_screen.dart';
import './screens/setup_pin_screen.dart';
import './screens/change_pin_screen.dart';
import './screens/about_us_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userData');
  await Hive.openBox('userPreferences');
  await Hive.openBox('authData');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DocumentsDataProvider>(
      create: (context) => DocumentsDataProvider(),
    ),
    ChangeNotifierProvider<AuthDataProvider>(
      create: (context) => AuthDataProvider(),
    ),
    ChangeNotifierProvider<PreferencesProvider>(
      create: (context) => PreferencesProvider(),
    ),
    Provider<GlobalTheme>(
      create: (context) => GlobalTheme(),
    ),
    ChangeNotifierProvider<HomeScreenIndexProvider>(
      create: (context) => HomeScreenIndexProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    GlobalTheme globalTheme = Provider.of<GlobalTheme>(context, listen: false);
    bool isDarkMode = Provider.of<PreferencesProvider>(context).darkMode;
    String? token = Provider.of<AuthDataProvider>(context).token;
    bool isLoggedIn = token != null;
    return ChangeNotifierProvider(
      create: (context) {
        ConnectivityChangeNotifier changeNotifier =
            ConnectivityChangeNotifier();
        changeNotifier.initialLoad();
        return changeNotifier;
      },
      child: MaterialApp(
        title: 'Parichaya',
        theme: isDarkMode ? globalTheme.darkTheme : globalTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute:
            isLoggedIn ? MobilePinScreen.routeName : LoginScreen.routeName,
        routes: {
          AboutParichayaScreen.routeName: (ctx) => const AboutParichayaScreen(),
          ChangePinScreen.routeName: (ctx) => const ChangePinScreen(),
          DataPermissionScreen.routeName: (ctx) => const DataPermissionScreen(),
          DocumentDetailScreen.routeName: (ctx) => const DocumentDetailScreen(),
          ErrorScreen.routeName: (ctx) => const ErrorScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          LoginMobileScreen.routeName: (ctx) => const LoginMobileScreen(),
          LoginOtpScreen.routeName: (ctx) => const LoginOtpScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          MobilePinScreen.routeName: (ctx) => const MobilePinScreen(),
          QrScanScreen.routeName: (ctx) => const QrScanScreen(),
          QrShareScreen.routeName: (ctx) => const QrShareScreen(),
          SetupPinScreen.routeName: (ctx) => const SetupPinScreen(),
          VerifyAgeScreen.routeName: (ctx) => const VerifyAgeScreen(),
          AboutUsScreen.routeName: (ctx) => const AboutUsScreen(),
        },
      ),
    );
  }
}
