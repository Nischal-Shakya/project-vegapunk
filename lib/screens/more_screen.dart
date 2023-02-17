import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';

import '../widgets/settings_listview_helper.dart';
import '../providers/all_data.dart';

import './settings_screen.dart';
import './login_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('More', style: Theme.of(context).textTheme.headlineSmall),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView(children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: customWidth * 0.05, vertical: 10),
                  child: InkWell(
                    child:
                        const SettingsListViewHelper(option: 'Verify Your Age'),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(QrShareScreen.routeName, arguments: "AGE");
                    },
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: customWidth * 0.05, vertical: 10),
                  child: InkWell(
                    child: const SettingsListViewHelper(option: 'Settings'),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(SettingsScreen.routeName);
                    },
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: customWidth * 0.05, vertical: 10),
                  child: InkWell(
                    child:
                        const SettingsListViewHelper(option: 'About Parichaya'),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationIcon: const Icon(
                          Icons.fingerprint,
                          color: Colors.blue,
                        ),
                        applicationLegalese: "View all open source licenses.",
                        useRootNavigator: true,
                        applicationVersion: "v2.15",
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: customWidth * 0.05, vertical: 10),
                child: InkWell(
                  child: const SettingsListViewHelper(option: 'Logout'),
                  onTap: () {
                    AllData().deleteDataFromBox();
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(
                      LoginScreen.routeName,
                      (route) => false,
                    );
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
