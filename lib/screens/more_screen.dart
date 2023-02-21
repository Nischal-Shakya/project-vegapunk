import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parichaya_frontend/providers/toggle_provider.dart';
import 'package:parichaya_frontend/screens/change_pin_screen.dart';
import 'package:parichaya_frontend/widgets/more_screen_listtile.dart';
import 'package:provider/provider.dart';

import './verify_age_screen.dart';
import './login_screen.dart';
import '../providers/homescreen_index_provider.dart';
import 'package:hive/hive.dart';
import '../widgets/biometrics_widget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final indexProvider = Provider.of<HomeScreenIndexProvider>(context);
    final toggler = Provider.of<ToggleProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        indexProvider.indexBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text('More', style: Theme.of(context).textTheme.headlineSmall),
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10, left: customWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Features",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              MoreScreenListTile(
                name: "Verify Age",
                description: "Verify your age",
                icon: FontAwesomeIcons.cakeCandles,
                trailingIcon: null,
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(VerifyAgeScreen.routeName),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Preferences",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              MoreScreenListTile(
                name: "Dark Mode",
                description: "Choose your light or dark theme preference",
                icon: toggler.isDarkMode
                    ? FontAwesomeIcons.cloudMoon
                    : FontAwesomeIcons.solidSun,
                trailingIcon: Switch(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: toggler.isDarkMode,
                  onChanged: (bool value) {
                    toggler.changeTheme(value);
                  },
                ),
                onTap: null,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Security",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              MoreScreenListTile(
                name: "Change PIN",
                description: "Set up a PIN to protect your app",
                icon: FontAwesomeIcons.lock,
                trailingIcon: null,
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed(ChangePinScreen.routeName),
              ),
              MoreScreenListTile(
                name: "Enable Fingerprint",
                description: "Use fingerprint to login",
                icon: FontAwesomeIcons.fingerprint,
                trailingIcon: Switch(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: toggler.isBiometricEnabled,
                  onChanged: (bool value) async {
                    final isAuthenticated = await LocalAuthApi.authenticate();
                    if (isAuthenticated) {
                      toggler.changeBiometrics(value);
                    }
                  },
                ),
                onTap: null,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Other",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              MoreScreenListTile(
                name: "About Parichaya",
                description: "Know more about Parichaya",
                icon: Icons.info_outline_rounded,
                trailingIcon: null,
                onTap: () => showLicensePage(
                  context: context,
                  applicationIcon: const Icon(
                    Icons.fingerprint,
                    color: Colors.blue,
                  ),
                  applicationLegalese: "View all open source licenses.",
                  useRootNavigator: true,
                  applicationVersion: "v2.15",
                ),
              ),
              MoreScreenListTile(
                name: "Logout",
                description: "Logout from the app",
                icon: Icons.logout,
                trailingIcon: null,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text("Log Out",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            content:
                                const Text("Are you sure you want to log out?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Hive.box("allData").clear();
                                  indexProvider.selectedIndexList.removeRange(1,
                                      indexProvider.selectedIndexList.length);
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamedAndRemoveUntil(
                                    LoginScreen.routeName,
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))
                            ]);
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
