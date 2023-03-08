// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/conversion.dart';
import 'package:parichaya_frontend/providers/auth_provider.dart';
import 'package:parichaya_frontend/screens/error_screen.dart';
import 'package:parichaya_frontend/screens/login_screen.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';
import 'package:parichaya_frontend/widgets/document_card_image.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/documents_provider.dart';
import '../widgets/document_detail_list.dart';
import '../url.dart';

class DocumentDetailScreen extends StatefulWidget {
  const DocumentDetailScreen({super.key});

  static const routeName = '/document_detail_screen';

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  bool isLoading = true;

  bool valueInitialized = true;

  @override
  Widget build(BuildContext context) {
    final AuthDataProvider authDataProvider =
        Provider.of<AuthDataProvider>(context, listen: false);
    final DocumentsDataProvider documentsDataProvider =
        Provider.of<DocumentsDataProvider>(context);
    late Uint8List documentFrontImage;
    late Uint8List documentBackImage;
    late Map allDocumentData;

    String docType = ModalRoute.of(context)!.settings.arguments as String;
    if (valueInitialized &&
        (docType == 'CTZ' || docType == 'DVL' || docType == 'NID')) {
      allDocumentData = documentsDataProvider.getFilteredDocumentData(docType)!;

      documentFrontImage = documentsDataProvider
          .getDocumentCardFrontImage(documentsDataProvider.documents![docType]);
      documentBackImage = documentsDataProvider
          .getDocumentCardBackImage(documentsDataProvider.documents![docType]);
      setState(() {
        isLoading = false;
        valueInitialized = false;
      });
    } else if (valueInitialized) {
      final Map allDocumentData = json.decode(docType)["permitted_document"];

      final String documentFrontImageBase64 = allDocumentData['card_front'];
      final String documentBackImageBase64 = allDocumentData['card_back'];

      documentFrontImage =
          const Base64Decoder().convert(documentFrontImageBase64);
      documentBackImage =
          const Base64Decoder().convert(documentBackImageBase64);
      allDocumentData.remove("face_image");
      allDocumentData.remove("card_front");
      allDocumentData.remove("card_back");
      allDocumentData.removeWhere(
          (key, value) => value == null || key == "docType" || key == "NIN");
      allDocumentData.update(
          "date_of_birth", (value) => value.toString().substring(0, 10));
      allDocumentData.update("DVL_blood_group", (value) => value.toString());
      allDocumentData.update(
          "DVL_date_of_issue", (value) => value.toString().substring(0, 10));
      allDocumentData.update(
          "DVL_date_of_expiry", (value) => value.toString().substring(0, 10));
      allDocumentData.update(
          "createdAt", (value) => value.toString().substring(0, 10));
      allDocumentData.update(
          "updatedAt", (value) => value.toString().substring(0, 10));
      setState(() {
        isLoading = false;
        valueInitialized = false;
      });
    }

    return RefreshIndicator(
      onRefresh: () async {
        String token = authDataProvider.token!;
        var response = await http.get(Uri.parse(getDataUrl),
            headers: {"Authorization": "Token $token"});
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
          log("Couldnt refresh data");
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
      },
      child: Scaffold(
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      "Fetching Driving License",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                    SliverAppBar(
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(30.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                  (docType == 'CTZ' ||
                                          docType == 'DVL' ||
                                          docType == 'NID')
                                      ? convertedFieldName(docType)
                                      : "Driving License",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge)),
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.background,
                      elevation: 1,
                      automaticallyImplyLeading: true,
                      floating: true,
                      actions: docType == "DVL"
                          ? [
                              IconButton(
                                splashRadius: 30,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(QrShareScreen.routeName,
                                          arguments: "DVL");
                                },
                                icon: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: SvgPicture.asset(
                                    ('assets/icons/scan-qrcode.svg'),
                                  ),
                                ),
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            ]
                          : null,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DocumentCardImage(
                                cardFront: documentFrontImage,
                                cardBack: documentBackImage,
                              ),
                              DocumentDetailList(
                                  fieldNames: allDocumentData.keys.toList(),
                                  fieldValues: allDocumentData.values.toList()),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ]),
      ),
    );
  }
}
