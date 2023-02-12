import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:parichaya_frontend/providers/all_data.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({Key? key}) : super(key: key);
  static const routeName = '/change_pin_screen';

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  String oldPin = "";
  String newPin = "";
  String confirmPin = "";
  bool oldPinObscure = true;
  bool newPinObscure = true;
  bool confirmPinObscure = true;
  final formKey = const Key("1");
  final formKey2 = const Key("2");
  final formKey3 = const Key("3");

  final confirmPinFocusNode = FocusNode();
  final oldPinFocusNode = FocusNode();
  final newPinFocusNode = FocusNode();

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingController2.dispose();
    confirmPinFocusNode.dispose();
    newPinFocusNode.dispose();
    oldPinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AllData>(context, listen: false);
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change MPIN',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Set up your account with a new 4 digit MPIN',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(
              height: customHeight * 0.05,
            ),
            const Text(
              "Old PIN",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(right: customWidth * 0.12),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: oldPinObscure,
                    obscuringCharacter: '*',
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
                      debugPrint("old pin : $v");
                      FocusScope.of(context).requestFocus(newPinFocusNode);
                    },
                    onChanged: (value) {
                      setState(() {
                        oldPin = value;
                      });
                    },
                    focusNode: oldPinFocusNode,
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
                      oldPinObscure = !oldPinObscure;
                    });
                  },
                  icon: Icon(
                    Icons.visibility,
                    color: oldPinObscure
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: customHeight * 0.025,
            ),
            const Text(
              "New PIN",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(children: [
              Form(
                key: formKey2,
                child: Padding(
                  padding: EdgeInsets.only(right: customWidth * 0.12),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: newPinObscure,
                    obscuringCharacter: '*',
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
                      debugPrint("new pin : $v");
                      FocusScope.of(context).requestFocus(confirmPinFocusNode);
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(oldPinFocusNode);
                      }
                      setState(() {
                        newPin = value;
                      });
                    },
                    focusNode: newPinFocusNode,
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
                      newPinObscure = !newPinObscure;
                    });
                  },
                  icon: Icon(
                    Icons.visibility,
                    color: newPinObscure
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: customHeight * 0.025,
            ),
            const Text(
              "Confirm New PIN",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Form(
                  key: formKey3,
                  child: Padding(
                    padding: EdgeInsets.only(right: customWidth * 0.12),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: confirmPinObscure,
                      obscuringCharacter: '*',
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
                      controller: textEditingController3,
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        debugPrint("confirm pin : $v");
                      },
                      onChanged: (value) {
                        setState(() {
                          confirmPin = value;
                        });
                        if (value.isEmpty) {
                          FocusScope.of(context).requestFocus(newPinFocusNode);
                        }
                      },
                      focusNode: confirmPinFocusNode,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
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
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.1),
        child: InkWell(
          onTap: () {
            final String getOldPin = data.mpin;
            if (newPin.length == 4 &&
                confirmPin.length == 4 &&
                oldPin.length == 4) {
              if (oldPin == getOldPin) {
                if (newPin != oldPin) {
                  if (newPin == confirmPin) {
                    data.putData("mpin", newPin);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('MPIN has been changed'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.grey,
                    ));
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pin codes do not match"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("New pin can not be the same as old pin"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid old pin"),
                    duration: Duration(seconds: 2),
                  ),
                );
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
