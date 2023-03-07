// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parichaya_frontend/providers/auth_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'package:parichaya_frontend/screens/login_otp_screen.dart';
import 'package:parichaya_frontend/screens/homescreen.dart';
import '../providers/connectivity_change_notifier.dart';
import 'package:http/http.dart' as http;
import '../url.dart';

import '../widgets/biometrics_widget.dart';

class MobilePinScreen extends StatefulWidget {
  const MobilePinScreen({Key? key}) : super(key: key);
  static const routeName = '/mobile_pin_screen';

  @override
  State<MobilePinScreen> createState() => _MobilePinScreenState();
}

class _MobilePinScreenState extends State<MobilePinScreen> {
  TextEditingController textEditingController = TextEditingController();
  String pin = "";
  bool pinObscure = true;
  final formKey = const Key("2");

  @override
  void dispose() {
    textEditingController.clearComposing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;
    final AuthDataProvider authDataProvider =
        Provider.of<AuthDataProvider>(context, listen: false);
    final mobilePin = authDataProvider.MPIN;
    final String ninNumber = authDataProvider.NIN!;
    final String mobileNumber = authDataProvider.mobileNumber!;
    bool hasFingerPrint = authDataProvider.isBiometricEnabled;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'PARICHAYA',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            SizedBox(
              height: customHeight * 0.025,
            ),
            Text(
              "Enter MPIN to unlock app",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(right: customWidth * 0.15),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: pinObscure,
                    textStyle:
                        const TextStyle(color: Colors.black45, fontSize: 16),
                    obscuringCharacter: '\u2B24',
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
                      log("pin : $v");
                    },
                    onChanged: (value) {
                      setState(() {
                        pin = value;
                      });
                    },
                    autoDismissKeyboard: false,
                    autoFocus: true,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      pinObscure = !pinObscure;
                    });
                  },
                  icon: Icon(
                    Icons.visibility,
                    color: pinObscure
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                if (pin == mobilePin) {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(HomeScreen.routeName,
                          (Route<dynamic> route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid Pin Code"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: customHeight * 0.025,
            ),
            Row(
              children: [
                Text(
                  "Forgot MPIN? ",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                GestureDetector(
                  child: Text(
                    "Reset",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  onTap: () {
                    if (connectionStatus) {
                      log("sending mobile and nin");
                      http.post(Uri.parse(postMobileAndNinUrl), body: {
                        "NIN": ninNumber,
                        "mobile_number": "+977$mobileNumber"
                      });
                      Navigator.of(context, rootNavigator: true).pushNamed(
                          LoginOtpScreen.routeName,
                          arguments: [ninNumber, mobileNumber]);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("No Internet Access"),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: hasFingerPrint ? customHeight * 0.025 : 0,
            ),
            hasFingerPrint
                ? Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "OR",
                            style: Theme.of(context).textTheme.labelLarge,
                          )),
                      const Expanded(child: Divider(color: Colors.grey)),
                    ],
                  )
                : Container(),
            SizedBox(
              height: hasFingerPrint ? customHeight * 0.025 : 0,
            ),
            Center(
              child: hasFingerPrint
                  ? InkWell(
                      borderRadius: BorderRadius.circular(5),
                      radius: 300,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            ('assets/icons/fingerprint-scan.svg'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "USE BIOMETRICS",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      onTap: () async {
                        final isAuthenticated =
                            await LocalAuthApi.authenticate();
                        if (isAuthenticated) {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamedAndRemoveUntil(HomeScreen.routeName,
                                  (Route<dynamic> route) => false);
                        }
                      },
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
