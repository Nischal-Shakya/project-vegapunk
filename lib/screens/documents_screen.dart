import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parichaya_frontend/providers/homescreen_index_provider.dart';
import 'package:parichaya_frontend/providers/toggle_provider.dart';
import 'package:parichaya_frontend/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../providers/all_data.dart';
import '../providers/connectivity_change_notifier.dart';
import 'package:hive/hive.dart';

import '../widgets/documents_screen_list.dart';
import '../widgets/documents_profile_box.dart';

import './error_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  static const routeName = "document_screen/";

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool isFirstLoading = true;
  @override
  void didChangeDependencies() async {
    final data = Provider.of<AllData>(context, listen: false);
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();
    String firstLogin = data.getData("firstLogin");
    final indexProvider = Provider.of<HomeScreenIndexProvider>(context);
    final toggler = Provider.of<ToggleProvider>(context);

    if (isFirstLoading && connectionStatus) {
      data.storeAllDataInBox().then((isTokenValid) {
        if (isTokenValid) {
          setState(() {
            isFirstLoading = false;
          });
        } else {
          toggler.changeBiometrics(false);
          toggler.changeTheme(false);
          Hive.box("allData").clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              ("Your session has expired."),
            ),
            duration: Duration(seconds: 2),
          ));
          indexProvider.selectedIndexList
              .removeRange(1, indexProvider.selectedIndexList.length);
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            LoginScreen.routeName,
            (route) => false,
          );
        }
      });
    } else if (firstLogin == "true") {
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed(ErrorScreen.routeName);
    } else {
      setState(() {
        isFirstLoading = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final data = Provider.of<AllData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        title:
            Text('PARICHAYA', style: Theme.of(context).textTheme.headlineLarge),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: SizedBox(
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            ('assets/icons/logo.svg'),
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary, BlendMode.srcIn),
          ),
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
      ),
      body: isFirstLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Fetching Data",
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return data.storeAllDataInBox().then((_) {
                  setState(() {});
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DocumentsProfileBox(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: customWidth * 0.08),
                    child: Text(
                      data.allDocumentTypes().isEmpty
                          ? "No Document Available"
                          : "DOCUMENTS",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const DocumentsScreenList(),
                ],
              ),
            ),
    );
  }
}
