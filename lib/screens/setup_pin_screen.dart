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
    const List condition = [
      "Be a 4-digit number",
      "Not be a repetitive pattern",
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Your Mpin Must:",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            child: Text(
                              "${index + 1}. ${condition[index].toString()}",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          );
                        },
                        itemCount: condition.length),
                  ]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "PIN",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(children: [
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.only(right: customWidth * 0.2),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: pinObscure,
                      obscuringCharacter: '*',
                      // blinkWhenObscuring: true,
                      textStyle: Theme.of(context).textTheme.titleSmall,

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
                        log("pin : $v");
                        FocusScope.of(context)
                            .requestFocus(confirmPinFocusNode);
                      },
                      onChanged: (value) {
                        setState(() {
                          pin = value;
                        });
                      },
                      focusNode: pinFocusNode,
                      autoDismissKeyboard: false,
                      autoFocus: true,
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
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
              Text(
                "Confirm PIN",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Form(
                    key: formKey2,
                    child: Padding(
                      padding: EdgeInsets.only(right: customWidth * 0.2),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        obscureText: confirmPinObscure,
                        textStyle: Theme.of(context).textTheme.titleSmall,

                        // obscuringCharacter: '\u1F311',

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
                        controller: textEditingController2,
                        keyboardType: TextInputType.number,
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
                  ),
                  Positioned(
                    right: 30,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.1),
        child: InkWell(
          onTap: () {
            if (pin.length == 4 && confirmPin.length == 4) {
              if (checkPattern(pin)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pin codes should not be repetitive pattern"),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                if (pin == confirmPin) {
                  data.putData("mpin", pin);
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(HomeScreen.routeName,
                          (Route<dynamic> route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pin codes do not match"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invalid pin code length"),
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
