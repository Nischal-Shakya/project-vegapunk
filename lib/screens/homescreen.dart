import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/documents_screen.dart';
import 'package:provider/provider.dart';
import '../providers/homescreen_index_provider.dart';
import '../providers/connectivity_change_notifier.dart';

import '../custom_icons/custom_icons.dart';
import 'qr_scan_screen.dart';
import 'more_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = "homescreen/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "navigatorKey");

class _HomeScreenState extends State<HomeScreen> {
  static const List<Widget> homeScreenWidgets = [
    DocumentsScreen(),
    QrScanScreen(),
    HistoryScreen(),
    MoreScreen(),
  ];
  bool firstLoading = true;
  bool prevConnection = true;

  @override
  void didChangeDependencies() async {
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

    if (connectionStatus != prevConnection) {
      if (!firstLoading) {
        if (!connectionStatus) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: const [
                        Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('No Internet Access'),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  )));

          log("no internet");
        } else if (connectionStatus) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: const [
                        Icon(
                          Icons.wifi,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Internet Connection Restored'),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.grey,
                  )));
          log("got internet");
        }
      }
    }

    prevConnection = connectionStatus;
    firstLoading = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final indexProvider = Provider.of<HomeScreenIndexProvider>(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (indexProvider.selectedIndex == 0) {
            SystemNavigator.pop();
          }
          indexProvider.indexBack();
          if (indexProvider.selectedIndex == 0) {
            navigatorKey.currentState?.popUntil(
              (route) => route.isFirst,
            );
          } else {
            navigatorKey.currentState?.pop();
          }
          return false;
        },
        child: Navigator(
          initialRoute: DocumentsScreen.routeName,
          onGenerateRoute: (settings) {
            if (settings.name == "/") {
              return MaterialPageRoute(builder: (_) => const DocumentsScreen());
            }
            return null;
          },
          key: navigatorKey,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            indexProvider.changeIndex(index);
            navigatorKey.currentState?.popUntil(
              (route) => route.isFirst,
            );
          } else if (index != indexProvider.selectedIndex) {
            indexProvider.changeIndex(index);
            if (index == 1) {
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => homeScreenWidgets[index]));
            } else {
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (_) => homeScreenWidgets[index]),
              );
            }
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.note, size: 20),
            label: 'My Id',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_edu_outlined),
            label: 'History',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CustomIcons.more,
              size: 20,
            ),
            label: 'More',
            tooltip: '',
          ),
        ],
        fixedColor: Theme.of(context).colorScheme.primary,
        selectedFontSize: 12,
        currentIndex: indexProvider.selectedIndex,
      ),
    );
  }
}
