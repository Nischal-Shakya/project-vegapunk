import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parichaya_frontend/providers/auth_provider.dart';
import 'package:parichaya_frontend/providers/documents_provider.dart';
import 'package:parichaya_frontend/screens/qr_share_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../url.dart';

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
  String? _timeString;

  @override
  void didChangeDependencies() async {
    final String permitId =
        ModalRoute.of(context)!.settings.arguments as String;
    if (permitId.isNotEmpty) {
      String token = Provider.of<AuthDataProvider>(context).token ?? "";
      var response = await http.get(Uri.parse("$getPidDataUrl/$permitId/"),
          headers: {"Authorization": "Token $token"});
      log(response.body.toString());
      final Map<String, dynamic> documentData =
          json.decode(response.body)["permitted_document"];
      faceImageByte64 = documentData['face_image'];
      faceImage = const Base64Decoder().convert(faceImageByte64);
      dob = documentData['date_of_birth'];
      setState(() {
        isLoading = false;
        isSharedData = true;
      });
    } else {
      faceImage = Provider.of<DocumentsDataProvider>(context).getFaceImage()!;
      dob = Provider.of<DocumentsDataProvider>(context).getDateOfbirth()!;
      setState(() {
        isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: isLoading
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
          : Column(
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
                  height: 18,
                ),
                Text("Over ${calculateAge(DateTime.parse(dob)).toString()}",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: SvgPicture.asset(('assets/icons/verified.svg'),
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn)),
                    ),
                    const SizedBox(
                      width: 4,
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
                  _timeString!,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.labelLarge!.color),
                ),
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.labelLarge!.color),
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
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.primary),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                        ),
                      ),
              ],
            ),
    );
  }
}
