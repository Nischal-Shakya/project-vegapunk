// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/providers/auth_provider.dart';
import 'package:parichaya_frontend/providers/documents_provider.dart';
import 'package:parichaya_frontend/providers/preference_provider.dart';
import 'package:parichaya_frontend/screens/about_parichaya_screen.dart';
import 'package:parichaya_frontend/screens/change_pin_screen.dart';
import 'package:parichaya_frontend/widgets/more_screen_listtile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './verify_age_screen.dart';
import './login_screen.dart';
import '../providers/homescreen_index_provider.dart';
import '../widgets/biometrics_widget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final indexProvider = Provider.of<HomeScreenIndexProvider>(context);
    final preferencesProvider = Provider.of<PreferencesProvider>(context);
    final authDataProvider = Provider.of<AuthDataProvider>(context);
    final documentsDataProvider = Provider.of<DocumentsDataProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        indexProvider.indexBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('More',
                      style: Theme.of(context).textTheme.headlineLarge)),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: customWidth * 0.05),
                  child: Text(
                    "Features",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                MoreScreenListTile(
                  name: "Verify Age",
                  description: "Verify your age",
                  icon: SvgPicture.asset(('assets/icons/cake.svg'),
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn)),
                  trailingIcon: null,
                  onTap: () => Navigator.of(context, rootNavigator: true)
                      .pushNamed(VerifyAgeScreen.routeName, arguments: ""),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: customWidth * 0.05),
                  child: Text(
                    "Preferences",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                MoreScreenListTile(
                  name: "Dark Mode",
                  description: "Choose your light or dark theme preference",
                  icon: SvgPicture.asset(('assets/icons/moon-star.svg'),
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn)),
                  trailingIcon: Switch(
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: preferencesProvider.darkMode,
                    onChanged: (bool value) {
                      preferencesProvider.setDarkMode(value);
                    },
                  ),
                  onTap: null,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: customWidth * 0.05),
                  child: Text(
                    "Security",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                MoreScreenListTile(
                  name: "Change PIN",
                  description: "Set up a PIN to protect your app",
                  icon: SvgPicture.asset(('assets/icons/shield-lock.svg'),
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn)),
                  trailingIcon: null,
                  onTap: () => Navigator.of(context, rootNavigator: true)
                      .pushNamed(ChangePinScreen.routeName),
                ),
                MoreScreenListTile(
                  name: "Enable Fingerprint",
                  description: "Use fingerprint to login",
                  icon: SvgPicture.asset(('assets/icons/fingerprint.svg'),
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn)),
                  trailingIcon: Switch(
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: authDataProvider.isBiometricEnabled,
                    onChanged: (bool value) async {
                      final isAuthenticated = await LocalAuthApi.authenticate();
                      if (isAuthenticated) {
                        authDataProvider.setIsBiometricEnabled(value);
                      }
                    },
                  ),
                  onTap: null,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: customWidth * 0.05),
                  child: Text(
                    "Other",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                MoreScreenListTile(
                  name: "About Parichaya",
                  description: "Know more about Parichaya",
                  icon: SvgPicture.asset(('assets/icons/info.svg'),
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn)),
                  trailingIcon: null,
                  onTap: () => Navigator.of(context, rootNavigator: true)
                      .pushNamed(AboutParichayaScreen.routeName),
                ),
                MoreScreenListTile(
                  name: "Logout",
                  description: "Logout from the app",
                  icon: SvgPicture.asset(('assets/icons/logout.svg'),
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn)),
                  trailingIcon: null,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Log Out",
                              style: Theme.of(context).textTheme.titleMedium),
                          content: Text("Are you sure you want to log out?",
                              style: Theme.of(context).textTheme.labelLarge),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            TextButton(
                              onPressed: () async {
                                documentsDataProvider.lastUpdatedAt = null;
                                await authDataProvider.logout();
                                indexProvider.selectedIndexList.removeRange(
                                    1, indexProvider.selectedIndexList.length);
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamedAndRemoveUntil(
                                  LoginScreen.routeName,
                                  (route) => false,
                                );
                              },
                              child: Text("Yes",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
