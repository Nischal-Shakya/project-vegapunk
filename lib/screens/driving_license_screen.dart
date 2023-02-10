import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/all_data.dart';
import '../widgets/document_detail_list.dart';

class DrivingLicenseScreen extends StatefulWidget {
  const DrivingLicenseScreen({super.key});

  static const routeName = 'DVL';

  @override
  State<DrivingLicenseScreen> createState() => _DrivingLicenseScreenState();
}

class _DrivingLicenseScreenState extends State<DrivingLicenseScreen> {
  bool isSelectedImage = true;
  double angle = 0;
  @override
  Widget build(BuildContext context) {
    final allDvlData =
        Provider.of<AllData>(context, listen: false).getDvlData();
    debugPrint(allDvlData.toString());
    final faceImageBase64 =
        Provider.of<AllData>(context, listen: false).nidFaceImage;
    final faceImage = const Base64Decoder().convert(faceImageBase64);

    final List fieldNames = allDvlData.keys.toList();
    final List fieldValues = allDvlData.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'National Identity',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      ),
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
                },
              ),
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
