import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
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

    debugPrint(ageVerificationData.toString());

    ageVerificationDataList = ageVerificationData.values.toList();
    setState(() {
      isLoading = false;
    });

    super.didChangeDependencies();
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
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
                Image.memory(cacheHeight: 200, faceImage),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Text("Name :",
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(
                          width: 15,
                          height: 50,
                        ),
                        Text(
                            "${ageVerificationDataList[1]} ${ageVerificationDataList[2]}",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Text("DOB :",
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(
                          width: 20,
                          height: 50,
                        ),
                        Text(
                            DateFormat.yMMMEd().format(
                                DateTime.parse(ageVerificationDataList[3])),
                            style: Theme.of(context).textTheme.bodyMedium)
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Text("Age :",
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(
                          width: 30,
                          height: 50,
                        ),
                        Text(
                            calculateAge(
                              DateTime.parse(ageVerificationDataList[3]),
                            ).toString(),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
