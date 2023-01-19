import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import '../custom_icons/custom_icons.dart';
import 'documents_screen.dart';
import 'qr_scan_screen.dart';
import 'more_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
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
    const inactiveColor = Colors.black;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('PARICHAYA', style: Theme.of(context).textTheme.headline3),
        titleSpacing: 0,
        leading: const Icon(Icons.fingerprint),
        elevation: 6,
      ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
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
              icon: const Icon(
                Icons.qr_code_scanner,
              ),
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
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
