import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../providers/all_data.dart';
import '../providers/connectivity_change_notifier.dart';

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

    if (isFirstLoading && connectionStatus) {
      data.storeAllDataInBox().then((_) {
        setState(() {
          isFirstLoading = false;
        });
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
            Text('PARICHAYA', style: Theme.of(context).textTheme.headlineSmall),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
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
