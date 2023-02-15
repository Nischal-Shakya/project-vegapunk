import 'dart:developer';

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
  // late Map<String, dynamic> ageVerificationData;
  bool isLoading = true;

  @override
  void didChangeDependencies() async {
    String permitId = ModalRoute.of(context)!.settings.arguments as String;
    String token = Provider.of<AllData>(context).token;

    var response = await http.get(Uri.parse("$getPidDataUrl/$permitId/"),
        headers: {"Authorization": "Token $token"}).then((value) {
      log(value.toString());
      isLoading = false;
    });
    log("response =$response");
    // ageVerificationData = json.decode(response.toString());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Center(
              child: Text("ageVerificationData"),
            ),
    );
  }
}
