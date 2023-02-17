import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/documents_screen.dart';
import 'package:parichaya_frontend/screens/error_screen.dart';
import 'package:provider/provider.dart';
import '../providers/all_data.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  final List<int> _pageIndex = [0];
  bool isFirstLoading = true;

  static const List<Widget> homeScreenWidgets = [
    DocumentsScreen(),
    QrScanScreen(),
    HistoryScreen(),
    MoreScreen(),
  ];

  @override
  void didChangeDependencies() async {
    final data = Provider.of<AllData>(context, listen: false);
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();
    String firstLogin = data.getData("firstLogin");

    if (!isFirstLoading && !connectionStatus) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No Internet Access'),
        duration: Duration(seconds: 2),
      ));
    } else if (!isFirstLoading && connectionStatus) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Internet Connection Restored'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.grey,
      ));
    }
    if (isFirstLoading && connectionStatus) {
      data.storeAllDataInBox().then((_) {
        setState(() {
          isFirstLoading = false;
        });
      });
    } else if (firstLogin == "true") {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, ErrorScreen.routeName);
    } else {
      setState(() {
        isFirstLoading = false;
      });
    }

    super.didChangeDependencies();
  }

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
                    style: Theme.of(context).textTheme.headlineSmall),
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
                    style: Theme.of(context).textTheme.headlineSmall),
                titleSpacing: 0,
                elevation: 1,
                backgroundColor: Colors.white,
              ),
        body: isFirstLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Fetching Data")
                  ],
                ),
              )
            : AnimatedSwitcher(
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
