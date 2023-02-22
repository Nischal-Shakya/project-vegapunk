import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/conversion.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/all_data.dart';
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
      final Map<String, dynamic> allDocumentData =
          Provider.of<AllData>(context, listen: false).getDocumentData(docType);
      final String documentFrontImageBase64 =
          Provider.of<AllData>(context, listen: false)
              .documentFrontImage(docType);
      final String documentBackImageBase64 =
          Provider.of<AllData>(context, listen: false)
              .documentBackImage(docType);
      documentFrontImage =
          const Base64Decoder().convert(documentFrontImageBase64);
      documentBackImage =
          const Base64Decoder().convert(documentBackImageBase64);

      fieldNames = allDocumentData.keys.toList();
      fieldValues = allDocumentData.values.toList();
    } else if (valueInitialized) {
      String token = Provider.of<AllData>(context).token;
      var response = await http.get(Uri.parse("$getPidDataUrl/$docType/"),
          headers: {"Authorization": "Token $token"});
      print(response.body.toString());
      final Map<String, dynamic> allDocumentData =
          json.decode(response.body)["permitted_document"];
      allDocumentData
          .removeWhere((key, value) => convertedFieldName(key) == "");
      final String documentFrontImageBase64 = allDocumentData['card_front'];
      final String documentBackImageBase64 = allDocumentData['card_back'];

      documentFrontImage =
          const Base64Decoder().convert(documentFrontImageBase64);
      documentBackImage =
          const Base64Decoder().convert(documentBackImageBase64);

      fieldNames = allDocumentData.keys.toList();
      fieldValues = allDocumentData.values.toList();
    }
    valueInitialized = false;
    isLoading = false;

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
    return Scaffold(
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
          : CustomScrollView(physics: const BouncingScrollPhysics(), slivers: <
              Widget>[
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
                            style: Theme.of(context).textTheme.headlineLarge)),
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
                          icon: const Icon(
                            Icons.qr_code_scanner,
                            size: 30,
                          ),
                          color: Theme.of(context).colorScheme.primary,
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
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
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
                                  angle = (angle + pi) % (2 * pi);
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
                                  duration: const Duration(milliseconds: 600));
                            }
                            setState(() {
                              angle = (angle + pi) % (2 * pi);
                            });
                          },
                          child: TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: angle),
                              duration: const Duration(milliseconds: 600),
                              builder: (context, value, _) {
                                if (value >= (pi / 2)) {
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
                                              ..rotateY(pi),
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
                            fieldNames: fieldNames, fieldValues: fieldValues),
                      ],
                    ),
                  ),
                ]),
              ),
            ]),
    );
  }
}
