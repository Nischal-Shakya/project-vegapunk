// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/setup_pin_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

import '../url.dart';
import '../providers/connectivity_change_notifier.dart';

import 'package:hive/hive.dart';
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
  late Map<String, dynamic> deviceData;
  bool isLoading = true;
  bool tapped = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.baseOS': build.version.baseOS,
      'device': build.device,
    };
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  @override
  void didChangeDependencies() async {
    deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    setState(() {
      isLoading = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

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
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: customWidth * 0.1),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
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
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.blue)),
                        child: Center(
                          child: Text(
                            'Resend',
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          if (connectionStatus) {
                            log("Sending Otp");
                            setState(() {
                              tapped = true;
                            });
                            var response = await http.post(Uri.parse(postOtp),
                                body: {
                                  "NIN": resendOtp[0],
                                  "mobile_number": "+977${resendOtp[1]}",
                                  "otp": otp
                                });

                            if (response.statusCode >= 400) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Invalid OTP"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              final String token =
                                  json.decode(response.body)["token"];
                              log("token : $token");
                              Hive.box("allData").put("token", token);
                              Hive.box("allData")
                                  .put("ninNumber", resendOtp[0]);
                              Hive.box("allData")
                                  .put("mobileNumber", resendOtp[1]);
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacementNamed(
                                      SetupPinScreen.routeName);
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
                      child: Container(
                        height: 50,
                        width: 150,
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
                  ]),
            ),
          );
  }
}
