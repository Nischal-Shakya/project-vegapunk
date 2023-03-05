import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/about_us_screen.dart';
import 'package:parichaya_frontend/screens/qr_scan_screen.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/global_theme.dart';
import 'providers/all_data.dart';
import 'providers/connectivity_change_notifier.dart';
import 'providers/homescreen_index_provider.dart';
import 'providers/toggle_provider.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('allData');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MultiProvider(providers: [
    Provider<AllData>(
      create: (context) => AllData(),
    ),
    Provider<GlobalTheme>(
      create: (context) => GlobalTheme(),
    ),
    ChangeNotifierProvider<HomeScreenIndexProvider>(
      create: (context) => HomeScreenIndexProvider(),
    ),
    ChangeNotifierProvider<ToggleProvider>(
      create: (context) => ToggleProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    GlobalTheme globalTheme = Provider.of<GlobalTheme>(context, listen: false);
    bool isDarkMode = Provider.of<ToggleProvider>(context).isDarkMode;
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
        initialRoute: Hive.box("allData").get("token") == null
            ? LoginScreen.routeName
            : MobilePinScreen.routeName,
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          ErrorScreen.routeName: (ctx) => const ErrorScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          LoginMobileScreen.routeName: (ctx) => const LoginMobileScreen(),
          LoginOtpScreen.routeName: (ctx) => const LoginOtpScreen(),
          DataPermissionScreen.routeName: (ctx) => const DataPermissionScreen(),
          QrScanScreen.routeName: (ctx) => const QrScanScreen(),
          QrShareScreen.routeName: (ctx) => const QrShareScreen(),
          DocumentDetailScreen.routeName: (ctx) => const DocumentDetailScreen(),
          MobilePinScreen.routeName: (ctx) => const MobilePinScreen(),
          SetupPinScreen.routeName: (ctx) => const SetupPinScreen(),
          ChangePinScreen.routeName: (ctx) => const ChangePinScreen(),
          VerifyAgeScreen.routeName: (ctx) => const VerifyAgeScreen(),
          AboutUsScreen.routeName: (ctx) => const AboutUsScreen()
        },
      ),
    );
  }
}
