import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences.dart';
import '../widgets/settings_listview_helper.dart';
import './settings_screen.dart';
import './login_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<Preferences>(context, listen: false);
    final double customWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          'Nischal Shakya',
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(
          height: 50,
        ),
        Expanded(
          child: ListView(children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: customWidth * 0.05, vertical: 10),
              child: InkWell(
                child: const SettingsListViewHelper(option: 'Verify Your Age'),
                onTap: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: customWidth * 0.05, vertical: 10),
              child: InkWell(
                child: const SettingsListViewHelper(option: 'Settings'),
                onTap: () {
                  Navigator.pushNamed(context, SettingsScreen.routeName);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: customWidth * 0.05, vertical: 10),
              child: InkWell(
                child: const SettingsListViewHelper(option: 'About Parichaya'),
                onTap: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: customWidth * 0.05, vertical: 10),
              child: InkWell(
                child: const SettingsListViewHelper(option: 'Logout'),
                onTap: () {
                  prefs.setJwtToken('');
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                },
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
