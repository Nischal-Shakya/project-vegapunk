import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/conversion.dart';
import 'package:provider/provider.dart';

import '../providers/all_data.dart';
import '../widgets/document_detail_list.dart';

class DocumentDetailScreen extends StatefulWidget {
  const DocumentDetailScreen({super.key});

  static const routeName = '/document_detail_screen';

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isSelectedImage = true;
  bool firstTap = true;
  double angle = 0;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final docType = ModalRoute.of(context)!.settings.arguments as String;
    final allDocumentData =
        Provider.of<AllData>(context, listen: false).getDocumentData(docType);
    final faceImageBase64 = Provider.of<AllData>(context, listen: false)
        .documentFrontImage(docType);
    final Uint8List faceImage = const Base64Decoder().convert(faceImageBase64);

    final List fieldNames = allDocumentData.keys.toList();
    final List fieldValues = allDocumentData.values.toList();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     convertedFieldName(docType),
      //     style: Theme.of(context).textTheme.headlineSmall,
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   automaticallyImplyLeading: true,
      //   iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      // ),
      body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                convertedFieldName(docType),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 1,
              automaticallyImplyLeading: true,
              iconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.primary),
              floating: true,
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
                                color: Theme.of(context).colorScheme.primary)),
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
                          debugPrint(_tabController!.previousIndex.toString());
                          if (firstTap &&
                              _tabController!.previousIndex ==
                                  _tabController!.index) {
                            _tabController!
                                .animateTo(_tabController!.index + 1);
                            firstTap = false;
                          } else {
                            _tabController!
                                .animateTo(_tabController!.previousIndex);
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
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                                  child: isSelectedImage
                                      ? Image.memory(
                                          faceImage,
                                          fit: BoxFit.cover,
                                        )
                                      : Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..rotateY(pi),
                                          child: Image.network(
                                            'https://www.hellotech.com/guide/wp-content/uploads/2020/05/HelloTech-qr-code-1024x1024.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              );
                            }),
                      ),
                      const Divider(
                        height: 20,
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
