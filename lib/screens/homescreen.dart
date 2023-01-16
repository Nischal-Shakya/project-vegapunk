import 'package:flutter/material.dart';

import '../custom_icons/custom_icons.dart';
import 'documents_screen.dart';
import 'qr_scan_screen.dart';
import 'more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DocumentsScreen(),
    QrScanScreen(),
    Center(
      child: Text(
        'History : Coming Soon',
      ),
    ),
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const Icon(Icons.fingerprint),
              const SizedBox(
                width: 5,
              ),
              Text(
                'PARICHAYA',
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.search),
          //     onPressed: (() {
          //     }),
          //   ),
          // ],
        ),
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.note, size: 20),
              label: 'My ID',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code_scanner,
              ),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_edu_outlined),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcons.more,
                size: 20,
              ),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.background,
          unselectedItemColor: Theme.of(context).colorScheme.shadow,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
