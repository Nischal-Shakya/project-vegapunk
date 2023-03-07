// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/conversion.dart';
import 'package:parichaya_frontend/providers/auth_provider.dart';
import 'package:parichaya_frontend/screens/error_screen.dart';
import 'package:parichaya_frontend/screens/login_screen.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';
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

class _DocumentDetailScreenState extends State<DocumentDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isSelectedImage = true;
  bool firstTap = true;
  bool valueInitialized = true;
  double angle = 0;
  TabController? _tabController;
  late Uint8List documentFrontImage;
  late Uint8List documentBackImage;
  late List fieldNames;
  late List fieldValues;
  late String docType;

  @override
  void didChangeDependencies() async {
    docType = ModalRoute.of(context)!.settings.arguments as String;
    if (valueInitialized &&
        (docType == 'CTZ' || docType == 'DVL' || docType == 'NID')) {
      final documentsDataProvider = Provider.of<DocumentsDataProvider>(context);
      final Map<String, dynamic> allDocumentData = documentsDataProvider
          .getFilteredDocumentData(documentsDataProvider.documents![docType])!;

      documentFrontImage = documentsDataProvider.documentFrontImage(docType)!;
      documentBackImage = documentsDataProvider.documentBackImage(docType)!;

      fieldNames = allDocumentData.keys.toList();
      fieldValues = allDocumentData.values.toList();
      setState(() {
        isLoading = false;
        valueInitialized = false;
      });
    } else if (valueInitialized) {
      String token = Provider.of<AuthDataProvider>(context).token ?? "";
      var response = await http.get(Uri.parse("$getPidDataUrl/$docType/"),
          headers: {"Authorization": "Token $token"});

      final Map<String, dynamic> allDocumentData =
          json.decode(response.body)["permitted_document"];

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
      fieldNames = allDocumentData.keys.toList();
      fieldValues = allDocumentData.values.toList();
      setState(() {
        isLoading = false;
        valueInitialized = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final AuthDataProvider authDataProvider =
        Provider.of<AuthDataProvider>(context, listen: false);
    final DocumentsDataProvider documentsDataProvider =
        Provider.of<DocumentsDataProvider>(context, listen: false);
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
          Map<String, dynamic> fetchedDocuments =
              json.decode(response.body)["documents"] as Map<String, dynamic>;
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
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      5.0,
                                    ),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                child: TabBar(
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  unselectedLabelColor:
                                      Theme.of(context).colorScheme.primary,
                                  tabs: const [
                                    Tab(
                                      text: 'Front View',
                                    ),
                                    Tab(
                                      text: 'Back View',
                                    ),
                                  ],
                                  onTap: (value) {
                                    if (_tabController!.indexIsChanging) {
                                      setState(() {
                                        angle =
                                            (angle + math.pi) % (2 * math.pi);
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (firstTap &&
                                      _tabController!.previousIndex ==
                                          _tabController!.index) {
                                    _tabController!
                                        .animateTo(_tabController!.index + 1);
                                    firstTap = false;
                                  } else {
                                    _tabController!.animateTo(
                                        _tabController!.previousIndex,
                                        duration:
                                            const Duration(milliseconds: 600));
                                  }
                                  setState(() {
                                    angle = (angle + math.pi) % (2 * math.pi);
                                  });
                                },
                                child: TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: angle),
                                    duration: const Duration(milliseconds: 600),
                                    builder: (context, value, _) {
                                      if (value >= (math.pi / 2)) {
                                        isSelectedImage = false;
                                      } else {
                                        isSelectedImage = true;
                                      }
                                      return Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..setEntry(3, 2, 0.001)
                                          ..rotateY(value),
                                        child: SizedBox(
                                          width: width,
                                          height: 230,
                                          child: isSelectedImage
                                              ? Image.memory(
                                                  documentFrontImage,
                                                  fit: BoxFit.contain,
                                                )
                                              : Transform(
                                                  alignment: Alignment.center,
                                                  transform: Matrix4.identity()
                                                    ..rotateY(math.pi),
                                                  child: Image.memory(
                                                    documentBackImage,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                        ),
                                      );
                                    }),
                              ),
                              DocumentDetailList(
                                  fieldNames: fieldNames,
                                  fieldValues: fieldValues),
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
