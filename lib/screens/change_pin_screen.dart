// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:parichaya_frontend/screens/setup_pin_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'package:parichaya_frontend/providers/all_data.dart';

import '../widgets/biometrics_widget.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({Key? key}) : super(key: key);
  static const routeName = '/change_pin_screen';

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  TextEditingController textEditingController = TextEditingController();
  String pin = "";
  bool pinObscure = true;
  final formKey = const Key("1");

  final pinFocusNode = FocusNode();

  @override
  void dispose() {
    pinFocusNode.dispose();
    textEditingController.clearComposing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AllData>(context, listen: false);
    final double customWidth = MediaQuery.of(context).size.width;
    bool hasFingerPrint = Hive.box("allData").get("enableFingerprint");

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter MPIN',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Enter your current MPIN",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(right: customWidth * 0.3),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: pinObscure,
                    autoDismissKeyboard: false,
                    obscuringCharacter: '\u2B24',
                    textStyle:
                        const TextStyle(color: Colors.black45, fontSize: 16),
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
                    // autoFocus: true,
                  ),
                ),
              ),
              Positioned(
                right: 70,
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
            SizedBox(
              height: hasFingerPrint ? 10 : 0,
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
              height: hasFingerPrint ? 20 : 0,
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
                              .pushNamed(SetupPinScreen.routeName);
                        }
                      },
                    )
                  : null,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
        child: InkWell(
          onTap: () {
            if (pin == data.mpin) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(SetupPinScreen.routeName);
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
