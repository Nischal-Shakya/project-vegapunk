import 'package:flutter/material.dart';

import '../custom_icons/custom_icons.dart';
import 'documents_screen.dart';
import 'qr_scan_screen.dart';
import 'more_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = "homescreen/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List homeScreenPages = [
    null,
    QrScanScreen.routeName,
    HistoryScreen.routeName,
    MoreScreen.routeName,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('PARICHAYA', style: Theme.of(context).textTheme.headline3),
        titleSpacing: 0,
        leading: Icon(
          Icons.account_circle_sharp,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.search,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: const DocumentsScreen(),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) => setState(() {
          if (index == 0) {
            return;
          }
          Navigator.pushNamed(context, homeScreenPages[index]);
        }),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.note, size: 20),
            label: 'My Id',
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history_edu_outlined),
            label: 'History',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              CustomIcons.more,
              size: 20,
            ),
            label: 'More',
          ),
        ],
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
