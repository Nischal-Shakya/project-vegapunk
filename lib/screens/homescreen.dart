import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

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
  int _currentIndex = 0;
  int _previousIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const inactiveColor = Colors.black45;
    return Scaffold(
      appBar: (_currentIndex != 1)
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text('PARICHAYA',
                  style: Theme.of(context).textTheme.headline3),
              titleSpacing: 0,
              leading: const Icon(Icons.fingerprint),
              elevation: 6,
            )
          : AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentIndex = _previousIndex;
                    _pageController.animateToPage(_previousIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear);
                  });
                },
              ),
              elevation: 0,
            ),
      extendBodyBehindAppBar: (_currentIndex != 1) ? false : true,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: const <Widget>[
            DocumentsScreen(),
            QrScanScreen(),
            HistoryScreen(),
            MoreScreen(),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: (_currentIndex != 1)
          ? BottomNavyBar(
              selectedIndex: _currentIndex,
              showElevation: true,
              curve: Curves.easeInBack,
              onItemSelected: (index) => setState(() {
                _previousIndex = _currentIndex;
                _currentIndex = index;
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeIn);
              }),
              items: [
                BottomNavyBarItem(
                  icon: const Icon(CustomIcons.note, size: 20),
                  title: const Text('My ID'),
                  textAlign: TextAlign.center,
                  inactiveColor: inactiveColor,
                  activeColor: Colors.white,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.qr_code_scanner),
                  title: const Text('Scan'),
                  textAlign: TextAlign.center,
                  inactiveColor: inactiveColor,
                  activeColor: Colors.white,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.history_edu_outlined),
                  title: const Text('History'),
                  textAlign: TextAlign.center,
                  inactiveColor: inactiveColor,
                  activeColor: Colors.white,
                ),
                BottomNavyBarItem(
                  icon: const Icon(
                    CustomIcons.more,
                    size: 20,
                  ),
                  title: const Text('More'),
                  textAlign: TextAlign.center,
                  inactiveColor: inactiveColor,
                  activeColor: Colors.white,
                ),
              ],
              itemCornerRadius: 5,
              backgroundColor: Theme.of(context).colorScheme.primary,
              animationDuration: const Duration(milliseconds: 500),
              containerHeight: 60,
            )
          : null,
    );
  }
}
