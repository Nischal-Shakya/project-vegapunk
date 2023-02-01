import 'package:flutter/material.dart';

import '../widgets/settings_listview_helper.dart';
import './change_pin_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings_screen';

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: ListView(children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: customWidth * 0.05, vertical: 10),
                child: InkWell(
                  child:
                      const SettingsListViewHelper(option: 'Setup Biometrics'),
                  onTap: () async {},
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: customWidth * 0.05, vertical: 10),
                child: InkWell(
                  child: const SettingsListViewHelper(option: 'Change Mpin'),
                  onTap: () {
                    Navigator.pushNamed(context, ChangePinScreen.routeName);
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
