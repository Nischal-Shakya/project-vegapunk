import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/setup_pin_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:parichaya_frontend/providers/all_data.dart';
import '../url.dart';
import '../providers/preferences.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({Key? key}) : super(key: key);
  static const routeName = '/login_otp_screen';

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  TextEditingController textEditingController = TextEditingController();
  late String otp;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<Preferences>(context, listen: false);
    final data = Provider.of<AllData>(context, listen: false);
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;

    final List<String> resendOtp =
        ModalRoute.of(context)!.settings.arguments as List<String>;

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
              'Verification Code',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Enter the verification code sent via SMS to +977*******${resendOtp[1].substring(7)}',
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(
              height: customHeight * 0.05,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  // obscureText: true,
                  // obscuringCharacter: '*',
                  // blinkWhenObscuring: true,

                  autoDisposeControllers: false,
                  animationType: AnimationType.slide,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    inactiveColor: Colors.black45,
                    activeColor: Colors.black45,
                    selectedColor: Theme.of(context).colorScheme.primary,
                  ),
                  showCursor: false,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    otp = v;
                    debugPrint(otp);
                    Navigator.of(context).pushNamed(SetupPinScreen.routeName);
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  autoFocus: true,
                  autoDismissKeyboard: false,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              width: 150,
              child: ListTile(
                onTap: () {
                  http.post(Uri.parse('$url/api/v1/auth/'), body: {
                    "NIN": resendOtp[0],
                    "mobile_number": "+977${resendOtp[1]}"
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "OTP has been resent",
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.grey,
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                title: const Text(
                  'Resend',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ListTile(
                onTap: () async {
                  try {
                    debugPrint("Sending Otp");
                    var response = await http
                        .post(Uri.parse('$url/api/v1/auth/verify/'), body: {
                      "NIN": resendOtp[0],
                      "mobile_number": "+977${resendOtp[1]}",
                      "otp": otp
                    });

                    if (response.statusCode >= 400) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid OTP"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      final String token = json.decode(response.body)["token"];
                      prefs.setJwtToken(token);
                      log("token : $token");
                      data.putData(token, token);
                      data.putData("ninNumber", resendOtp[0]);
                      data.putData("mobileNumber", resendOtp[1]);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Fetching Data...",
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.grey,
                        ),
                      );
                      data.storeDataInBox(token).then((_) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SetupPinScreen()));
                      });
                    }
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid OTP"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                title: const Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                tileColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
