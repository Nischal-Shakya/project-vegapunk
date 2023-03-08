// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parichaya_frontend/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../url.dart';

import '../providers/auth_provider.dart';
import '../providers/documents_provider.dart';
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
  bool valueInitialized = false;
  late AuthDataProvider authDataProvider;
  late DocumentsDataProvider documentsDataProvider;

  Future<void> updateDBData() async {
    String token = authDataProvider.token!;
    var response = await http
        .get(Uri.parse(getDataUrl), headers: {"Authorization": "Token $token"});
    // TODO:Check if data has been updated since last fetch.
    // If updated, fetch it.
    // Else, skip it.
    // log(response.statusCode.toString());
    if (response.statusCode == 401) {
      authDataProvider.logout();
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    }
    if (response.statusCode != 200) {
      return;
    }
    if (response.statusCode == 200) {
      Map fetchedDocuments = json.decode(response.body)["documents"] as Map;
      fetchedDocuments.removeWhere((key, value) => value == null);
      await documentsDataProvider.setDocumentsData(fetchedDocuments);
    } else {
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed(ErrorScreen.routeName);
    }
  }

  @override
  void didChangeDependencies() async {
    if (!valueInitialized) {
      authDataProvider = Provider.of<AuthDataProvider>(context, listen: false);
      documentsDataProvider =
          Provider.of<DocumentsDataProvider>(context, listen: false);
      bool connectionStatus =
          Provider.of<ConnectivityChangeNotifier>(context).connectivity();

      if (!connectionStatus) {
        if (documentsDataProvider.documents == null) {
          Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed(ErrorScreen.routeName);
        }
      } else {
        await updateDBData();
      }

      setState(() {
        isFirstLoading = false;
        valueInitialized = true;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    // final data = Provider.of<AllData>(context);
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
            // colorFilter: ColorFilter.mode(
            //     Theme.of(context).colorScheme.primary, BlendMode.srcIn),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.notifications_none_outlined,
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
              onRefresh: () async {
                await updateDBData();
              },
              color: Theme.of(context).colorScheme.onBackground,
              backgroundColor: Theme.of(context).colorScheme.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DocumentsProfileBox(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: customWidth * 0.08),
                    child: Text(
                      "DOCUMENTS",
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
