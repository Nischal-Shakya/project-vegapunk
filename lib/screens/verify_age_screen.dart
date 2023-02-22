import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.blue),
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
                child: Image.network(
                  "https://thumbs.dreamstime.com/z/portrait-young-handsome-happy-man-wearing-glasses-casual-smart-blue-clothing-yellow-color-background-square-composition-200740125.jpg",
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
              const Icon(
                Icons.verified,
                color: Colors.blue,
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
            DateFormat("h:m:s").format(DateTime.now()),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            DateFormat.yMMMd().format(DateTime.now()),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              icon: const Icon(
                Icons.verified,
                color: Colors.white,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              onPressed: null,
              label: Text(
                "Create a QR Code",
                style: Theme.of(context).textTheme.labelMedium,
              ))
        ],
      ),
    );
  }
}
