import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parichaya_frontend/providers/global_theme.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';
import 'package:provider/provider.dart';

import './settings_screen.dart';
import './login_screen.dart';
import '../providers/homescreen_index_provider.dart';
import 'package:hive/hive.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final indexProvider = Provider.of<HomeScreenIndexProvider>(context);
    const moreList = [
      {
        'name': 'Verify Age',
        'description': 'Verify your age',
        'icon': FontAwesomeIcons.cakeCandles,
        'trailing': false
      },
      {
        'name': 'Settings',
        'description': 'Manage MPIN, Fingerprint and Appearance',
        'icon': Icons.settings_outlined,
        'trailing': true
      },
      {
        'name': 'About Parichaya',
        'description': 'Know more about Parichaya',
        'icon': Icons.info_outline_rounded,
        'trailing': true
      },
      {
        'name': 'Logout',
        'description': 'Logout from the app',
        'icon': Icons.logout,
        'trailing': false
      },
    ];
    return WillPopScope(
      onWillPop: () async {
        indexProvider.indexBack();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: Colors.black),
            title:
                Text('More', style: Theme.of(context).textTheme.headlineSmall),
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 20, horizontal: customWidth * 0.05),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      moreList[index]['name'].toString(),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Text(
                    moreList[index]['description'].toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  leading: FaIcon(
                    moreList[index]['icon'] as IconData,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  trailing: moreList[index]['trailing'] as bool
                      ? const FaIcon(
                          Icons.keyboard_arrow_right_outlined,
                          size: 30,
                          color: Colors.black,
                        )
                      : null,
                  horizontalTitleGap: 10,
                  onTap: () {
                    switch (index) {
                      case 0:
                        Navigator.of(context, rootNavigator: true).pushNamed(
                            QrShareScreen.routeName,
                            arguments: "AGE");
                        break;
                      case 1:
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(SettingsScreen.routeName);
                        break;
                      case 2:
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
                        break;
                      case 3:
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Log Out",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                content: const Text(
                                    "Are you sure you want to log out?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Hive.box("allData").clear();
                                      indexProvider.selectedIndexList
                                          .removeRange(
                                              1,
                                              indexProvider
                                                  .selectedIndexList.length);
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamedAndRemoveUntil(
                                        LoginScreen.routeName,
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              );
                            });
                    }
                  },
                  isThreeLine: true,
                );
              },
              itemCount: moreList.length,
            ),
          )

          //  Column(
          //   children: [
          //     const SizedBox(
          //       height: 20,
          //     ),
          //     Expanded(
          //       child: ListView(children: [
          //         Card(
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: customWidth * 0.05, vertical: 10),
          //             child: InkWell(
          //               child: const SettingsListViewHelper(
          //                   option: 'Verify Your Age'),
          //               onTap: () {
          //                 Navigator.of(context, rootNavigator: true).pushNamed(
          //                     QrShareScreen.routeName,
          //                     arguments: "AGE");
          //               },
          //             ),
          //           ),
          //         ),
          //         Card(
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: customWidth * 0.05, vertical: 10),
          //             child: InkWell(
          //               child: const SettingsListViewHelper(option: 'Settings'),
          //               onTap: () {
          // Navigator.of(context, rootNavigator: true)
          //     .pushNamed(SettingsScreen.routeName);
          //               },
          //             ),
          //           ),
          //         ),
          //         Card(
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: customWidth * 0.05, vertical: 10),
          //             child: InkWell(
          //               child: const SettingsListViewHelper(
          //                   option: 'About Parichaya'),
          //               onTap: () {
          // showLicensePage(
          //   context: context,
          //   applicationIcon: const Icon(
          //     Icons.fingerprint,
          //     color: Colors.blue,
          //   ),
          //   applicationLegalese: "View all open source licenses.",
          //   useRootNavigator: true,
          //   applicationVersion: "v2.15",
          // );
          //               },
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.symmetric(
          //               horizontal: customWidth * 0.05, vertical: 10),
          //           child: InkWell(
          //             child: const SettingsListViewHelper(option: 'Logout'),
          //             onTap: () {
          // Hive.box("allData").clear();
          // indexProvider.selectedIndexList.removeRange(
          //     1, indexProvider.selectedIndexList.length);
          // Navigator.of(context, rootNavigator: true)
          //     .pushNamedAndRemoveUntil(
          //   LoginScreen.routeName,
          //   (route) => false,
          // );
          //             },
          //           ),
          //         ),
          //       ]),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
