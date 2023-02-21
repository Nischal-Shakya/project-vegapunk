import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/all_data.dart';

class VerifyAgeScreen extends StatelessWidget {
  const VerifyAgeScreen({super.key});

  static const routeName = '/verify_age_screen';

  @override
  Widget build(BuildContext context) {
    final String faceImageByte64 = Provider.of<AllData>(context).faceImage;
    final Uint8List faceImage = const Base64Decoder().convert(faceImageByte64);
    final String dob = Provider.of<AllData>(context).dob;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
    );
  }
}
