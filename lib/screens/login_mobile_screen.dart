// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../providers/internet_connectivity.dart';
import 'package:hive/hive.dart';

import '../url.dart';

import './login_otp_screen.dart';

class LoginMobileScreen extends StatefulWidget {
  const LoginMobileScreen({super.key});

  static const routeName = '/login_mobile_screen';

  @override
  State<LoginMobileScreen> createState() => _LoginMobileScreenState();
}

class _LoginMobileScreenState extends State<LoginMobileScreen> {
  final mobileNumbercontroller = TextEditingController();

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();

  @override
  void dispose() {
    mobileNumbercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;

    final String ninNumber =
        ModalRoute.of(context)!.settings.arguments as String;

    void submitMobileNumber() async {
      await connectionStatus.checkConnection();
      if (mobileNumbercontroller.text.isEmpty ||
          mobileNumbercontroller.text.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid Mobile Number"),
          duration: Duration(seconds: 2),
        ));
        return;
      } else if (!connectionStatus.hasConnection) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No Internet Access"),
          duration: Duration(seconds: 2),
        ));
        return;
      }
      debugPrint("sending mobile and nin");
      http.post(Uri.parse(postMobileAndNinUrl), body: {
        "NIN": ninNumber,
        "mobile_number": "+977${mobileNumbercontroller.text}"
      });
      Hive.box("allData").put("firstLogin", "true");
      Navigator.pushNamed(context, LoginOtpScreen.routeName,
          arguments: [ninNumber, mobileNumbercontroller.text]);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Moblie Number',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Enter the mobile number associated with your National Identity Card',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(
              height: customHeight * 0.05,
            ),
            const Text(
              "Registered Mobile Number",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: mobileNumbercontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.blue)),
                  constraints: const BoxConstraints(maxHeight: 50),
                  prefixIcon: const Icon(Icons.phone_android),
                  prefixText: "+977 ",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              keyboardType: TextInputType.number,
              autofocus: true,
              // textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.1),
        child: InkWell(
          onTap: submitMobileNumber,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Center(
              child: Text(
                'Next',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
