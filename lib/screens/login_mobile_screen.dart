// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../providers/connectivity_change_notifier.dart';
import 'package:provider/provider.dart';
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

  @override
  void dispose() {
    mobileNumbercontroller.dispose();
    super.dispose();
  }

  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

    final String ninNumber =
        ModalRoute.of(context)!.settings.arguments as String;

    void submitMobileNumber() async {
      if (mobileNumbercontroller.text.isEmpty ||
          mobileNumbercontroller.text.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid Mobile Number"),
          duration: Duration(seconds: 2),
        ));
      } else if (!connectionStatus) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No Internet Access"),
          duration: Duration(seconds: 2),
        ));
      } else {
        log("sending mobile and nin");
        setState(() {
          tapped = true;
        });
        var response = await http.post(Uri.parse(postMobileAndNinUrl), body: {
          "NIN": ninNumber,
          "mobile_number": "+977${mobileNumbercontroller.text}"
        });
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              ("Invalid Mobile Number"),
            ),
            duration: Duration(seconds: 2),
          ));
        } else {
          Hive.box("allData").put("firstLogin", "true");
          Hive.box("allData").put("enableFingerprint", false);
          Hive.box("allData").put("darkmode", false);
          Navigator.of(context, rootNavigator: true).pushNamed(
              LoginOtpScreen.routeName,
              arguments: [ninNumber, mobileNumbercontroller.text]);
        }
        setState(() {
          tapped = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Moblie Number',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Enter the mobile number associated with your National Identity Card',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(
              height: customHeight * 0.05,
            ),
            Text(
              "Registered Mobile Number",
              style: Theme.of(context).textTheme.labelLarge,
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
                  constraints: const BoxConstraints(maxHeight: 52),
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    child: SvgPicture.asset(('assets/icons/phone.svg'),
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn)),
                  ),
                  prefixText: "+977 ",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              style: Theme.of(context).textTheme.labelLarge,
              keyboardType: TextInputType.number,
              autofocus: true,

              textAlignVertical: TextAlignVertical.top,

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
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: tapped
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : InkWell(
                  onTap: submitMobileNumber,
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
