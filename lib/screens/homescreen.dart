import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/documents_screen.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  final List<int> _pageIndex = [0];

  static const List<Widget> homeScreenWidgets = [
    DocumentsScreen(),
    QrScanScreen(),
    HistoryScreen(),
    MoreScreen(),
  ];

  Future<bool> _onWillPop() async {
    if (_pageIndex.last == 0) {
      SystemNavigator.pop();
    } else {
      setState(() {
        _pageIndex.removeLast();
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _pageIndex.last == 0
            ? AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent),
                // automaticallyImplyLeading: false,
                title: Text('PARICHAYA',
                    style: Theme.of(context).textTheme.headline3),
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
              )
            : AppBar(
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    if (_pageIndex.last == 0) {
                      SystemNavigator.pop();
                    } else {
                      setState(() {
                        _pageIndex.removeLast();
                      });
                    }
                  },
                ),
                title: Text(_pageIndex.last == 2 ? 'History' : 'More',
                    style: Theme.of(context).textTheme.headline3),
                titleSpacing: 0,
                elevation: 1,
                backgroundColor: Colors.white,
              ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 550),
          switchInCurve: Curves.easeInSine,
          child: homeScreenWidgets[_pageIndex.last],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex.last,
          onTap: (index) {
            setState(() {
              if (index == 0) {
                _pageIndex.removeRange(1, _pageIndex.length);
              } else if (index == 1) {
                Navigator.of(context).push(
                    PageRouteBuilder(pageBuilder: (context, animation, _) {
                  return homeScreenWidgets[index];
                }));
              } else {
                _pageIndex.add(index);
              }
            });
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
        ),
      ),
    );
  }
}
