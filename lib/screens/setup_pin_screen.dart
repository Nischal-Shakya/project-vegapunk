import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/homescreen.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:parichaya_frontend/providers/all_data.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({Key? key}) : super(key: key);
  static const routeName = '/setup_pin_screen';

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  String pin = "";
  String confirmPin = "";
  bool pinObscure = true;
  bool confirmPinObscure = true;
  bool pinValidated = false;
  bool confirmPinValidated = false;
  final formKey = const Key("1");
  final formKey2 = const Key("2");

  final confirmPinFocusNode = FocusNode();
  final pinFocusNode = FocusNode();

  bool checkPattern(String pin) {
    final intPin = int.parse(pin);
    for (var i = 1; i <= 9; i++) {
      if (intPin == 0) {
        return true;
      }
      if (intPin / i == 1111) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingController2.dispose();
    confirmPinFocusNode.dispose();
    pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AllData>(context, listen: false);
    final double customWidth = MediaQuery.of(context).size.width;

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Setup MPIN',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Set up your account with a string MPIN",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "PIN",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(children: [
              Form(
                key: formKey,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  obscureText: pinObscure,
                  textStyle:
                      const TextStyle(color: Colors.black45, fontSize: 16),
                  obscuringCharacter: '\u2B24',
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
                      fieldOuterPadding: const EdgeInsets.only(right: 15)),
                  mainAxisAlignment: MainAxisAlignment.start,
                  showCursor: false,
                  validator: (value) {
                    if (value?.length != 4) {
                      confirmPinValidated = false;

                      return "";
                    }

                    if (checkPattern(value!)) {
                      confirmPinValidated = false;

                      return "*MPIN should not be repetitive";
                    }

                    pinValidated = true;
                    return null;
                  },
                  onChanged: (_) {},
                  errorTextSpace: 30,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    setState(() {
                      pin = value;
                    });
                    log("pin : $value");
                    FocusScope.of(context).requestFocus(confirmPinFocusNode);
                  },
                  focusNode: pinFocusNode,
                  autoDismissKeyboard: false,
                  autoFocus: true,
                ),
              ),
              Positioned(
                right: 60,
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
              height: 20,
            ),
            Text(
              "Confirm PIN",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Form(
                  key: formKey2,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: confirmPinObscure,
                    textStyle:
                        const TextStyle(color: Colors.black45, fontSize: 16),

                    obscuringCharacter: '\u2B24',

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
                      fieldOuterPadding: const EdgeInsets.only(right: 15),
                    ),
                    mainAxisAlignment: MainAxisAlignment.start,
                    showCursor: false,
                    controller: textEditingController2,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.length != 4) {
                        confirmPinValidated = false;
                        return "";
                      } else if (value != pin) {
                        confirmPinValidated = false;
                        return "*MPIN does not match";
                      }
                      confirmPinValidated = true;
                      return null;
                    },

                    errorTextSpace: 30,
                    onCompleted: (v) {
                      log("confirm pin : $v");
                    },
                    onChanged: (value) {
                      setState(() {
                        confirmPin = value;
                      });
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(pinFocusNode);
                      }
                    },
                    focusNode: confirmPinFocusNode,
                    autoDismissKeyboard: false,
                  ),
                ),
                Positioned(
                  right: 60,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        confirmPinObscure = !confirmPinObscure;
                      });
                    },
                    icon: Icon(
                      Icons.visibility,
                      color: confirmPinObscure
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
        child: InkWell(
          onTap: () {
            if (pinValidated && confirmPinValidated) {
              data.putData("mpin", pin);
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil(
                      HomeScreen.routeName, (Route<dynamic> route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Pin code has been set"),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.grey,
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
