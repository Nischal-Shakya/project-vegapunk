// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/setup_pin_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

import '../url.dart';
import '../providers/connectivity_change_notifier.dart';

import '../providers/auth_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  late BaseDeviceInfo deviceData;
  bool isLoading = true;
  bool tapped = false;
  bool resend = false;
  Timer _timer = Timer(Duration.zero, () {});
  int totalTime = 5;
  late int startTime;
  void startTimer() {
    startTime = totalTime;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (startTime == 0) {
          setState(() {
            timer.cancel();
            totalTime += 5;
            resend = false;
          });
        } else {
          setState(() {
            startTime--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _timer.cancel();
    super.dispose();
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  @override
  void didChangeDependencies() async {
    if (isLoading) {
      deviceData = await deviceInfoPlugin.deviceInfo;

      setState(() {
        isLoading = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();
    AuthDataProvider authDataProvider =
        Provider.of<AuthDataProvider>(context, listen: false);

    final List<String> resendOtp =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
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
                    'Verification Code',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Enter the verification code sent via SMS to +977*******${resendOtp[1].substring(7)}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(
                    height: customHeight * 0.05,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: customWidth * 0.05),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
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
                        textStyle: Theme.of(context).textTheme.titleSmall,
                        showCursor: false,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {
                          otp = v;
                          log(otp);
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        resend = true;
                      });
                      startTimer();
                      if (connectionStatus) {
                        http.post(Uri.parse(postMobileAndNinUrl), body: {
                          "NIN": resendOtp[0],
                          "mobile_number": "+977${resendOtp[1]}"
                        }, headers: {
                          "device_info": deviceData.toString()
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No Internet Connection"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: !resend
                        ? Center(
                            child: Text(
                              'Resend',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          )
                        : const SizedBox(),
                  ),
                  resend
                      ? Center(
                          child: Text(
                            "Resend code after ${startTime}s",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
              child: InkWell(
                onTap: () async {
                  try {
                    if (connectionStatus) {
                      log("Sending Otp");
                      setState(() {
                        tapped = true;
                      });
                      var response = await http.post(Uri.parse(postOtp), body: {
                        "NIN": resendOtp[0],
                        "mobile_number": "+977${resendOtp[1]}",
                        "otp": otp
                      }, headers: {
                        'model': deviceData.data['model'].toString(),
                        'os': Platform.operatingSystem.toString()
                      });
                      if (response.statusCode >= 400) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid OTP"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        setState(() {
                          tapped = false;
                        });
                      } else {
                        final String token =
                            json.decode(response.body)["token"];
                        log("token : $token");

                        authDataProvider.setToken(token);
                        authDataProvider.setNIN(resendOtp[0]);
                        authDataProvider.setMobileNumber(resendOtp[1]);

                        Navigator.of(context, rootNavigator: true)
                            .pushReplacementNamed(SetupPinScreen.routeName);
                      }
                      setState(() {
                        tapped = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No Internet Connection"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      setState(() {
                        tapped = false;
                      });
                    }
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid OTP"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() {
                      tapped = false;
                    });
                  }
                },
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
                      : const Center(
                          child: Text(
                            'Confirm',
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
