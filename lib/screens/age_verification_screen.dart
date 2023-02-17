import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../url.dart';
import '../providers/all_data.dart';
import 'package:provider/provider.dart';

class AgeVerificationScreen extends StatefulWidget {
  const AgeVerificationScreen({super.key});

  static const routeName = '/age_verification_screen';

  @override
  State<AgeVerificationScreen> createState() => _AgeVerificationScreenState();
}

class _AgeVerificationScreenState extends State<AgeVerificationScreen> {
  bool isLoading = true;
  late List ageVerificationDataList;
  late Uint8List faceImage;

  @override
  void didChangeDependencies() async {
    String permitId = ModalRoute.of(context)!.settings.arguments as String;
    String token = Provider.of<AllData>(context).token;

    var response = await http.get(Uri.parse("$getPidDataUrl/$permitId/"),
        headers: {"Authorization": "Token $token"});

    Map<String, dynamic> ageVerificationData =
        json.decode(response.body)["permitted_document"];

    faceImage = const Base64Decoder()
        .convert(ageVerificationData["face_image"].split(',')[1]);

    ageVerificationData
        .removeWhere((key, value) => key == "face_image" || value == null);

    ageVerificationDataList = ageVerificationData.values.toList();

    setState(() {
      isLoading = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Image.memory(faceImage),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(ageVerificationDataList[index]),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                  itemCount: ageVerificationDataList.length,
                ),
              ],
            ),
    );
  }
}
