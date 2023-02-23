import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import '../url.dart';
import '../providers/all_data.dart';

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

class VerifyAgeScreen extends StatefulWidget {
  const VerifyAgeScreen({super.key});

  static const routeName = '/verify_age_screen';

  @override
  State<VerifyAgeScreen> createState() => _VerifyAgeScreenState();
}

class _VerifyAgeScreenState extends State<VerifyAgeScreen> {
  late String faceImageByte64;
  late Uint8List faceImage;
  late String dob;
  bool isLoading = true;
  bool isSharedData = false;

  @override
  void didChangeDependencies() async {
    final String permitId =
        ModalRoute.of(context)!.settings.arguments as String;
    if (permitId.isNotEmpty) {
      String token = Provider.of<AllData>(context).token;
      var response = await http.get(Uri.parse("$getPidDataUrl/$permitId/"),
          headers: {"Authorization": "Token $token"});
      setState(() {
        isLoading = false;
        isSharedData = true;
      });
      final Map<String, dynamic> documentData =
          json.decode(response.body)["permitted_document"];
      faceImageByte64 = documentData['face_image'];
      faceImage = const Base64Decoder().convert(faceImageByte64);
      dob = documentData['dob'];
    } else {
      faceImageByte64 = Provider.of<AllData>(context).faceImage;
      faceImage = const Base64Decoder().convert(faceImageByte64);
      dob = Provider.of<AllData>(context).dob;
      setState(() {
        isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(
                  "Fetching Proof of Age",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: true,
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: 160,
                    height: 160,
                    child: ClipOval(
                      child: Image.memory(
                        // "https://thumbs.dreamstime.com/z/portrait-young-handsome-happy-man-wearing-glasses-casual-smart-blue-clothing-yellow-color-background-square-composition-200740125.jpg",
                        faceImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(calculateAge(DateTime.parse(dob)).toString(),
                    style: Theme.of(context).textTheme.titleLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(('assets/icons/verified.svg'),
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn)),
                    ),
                    Text(
                      "Verified Age",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Text(
                  DateFormat("h:mm:s").format(DateTime.now()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                isSharedData
                    ? const SizedBox()
                    : ElevatedButton.icon(
                        icon: SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset(
                              ('assets/icons/scan-qrcode.svg'),
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn)),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blue),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                              QrShareScreen.routeName,
                              arguments: 'AGE');
                        },
                        label: const Text(
                          "Create a QR Code",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ))
              ],
            ),
          );
  }
}
