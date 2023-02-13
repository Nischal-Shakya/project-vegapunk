import 'dart:convert';
import 'dart:math';

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

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  bool isSelectedImage = true;
  double angle = 0;
  @override
  Widget build(BuildContext context) {
    final docType = ModalRoute.of(context)!.settings.arguments as String;
    final allDocumentData =
        Provider.of<AllData>(context, listen: false).getDocumentData(docType);
    final faceImageBase64 = Provider.of<AllData>(context, listen: false)
        .documentFrontImage(docType);
    final faceImage = const Base64Decoder().convert(faceImageBase64);

    final List fieldNames = allDocumentData.keys.toList();
    final List fieldValues = allDocumentData.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          convertedFieldName(docType),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  angle = (angle + pi) % (2 * pi);
                });
              },
              child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: angle),
                  duration: const Duration(seconds: 1),
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
                        // color: Theme.of(context).colorScheme.primary,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                        child: isSelectedImage
                            ? Image.memory(
                                faceImage,
                                fit: BoxFit.cover,
                              )
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
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
    );
  }
}
