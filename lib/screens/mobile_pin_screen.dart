import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'package:parichaya_frontend/providers/all_data.dart';
import 'package:parichaya_frontend/screens/login_otp_screen.dart';
import 'package:parichaya_frontend/screens/homescreen.dart';

import '../widgets/biometrics_widget.dart';

class MobilePinScreen extends StatefulWidget {
  const MobilePinScreen({Key? key}) : super(key: key);
  static const routeName = '/mobile_pin_screen';

  @override
  State<MobilePinScreen> createState() => _MobilePinScreenState();
}

class _MobilePinScreenState extends State<MobilePinScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool firstTime = true;
  String pin = "";
  bool pinObscure = true;
  final formKey = const Key("1");

  final pinFocusNode = FocusNode();

  @override
  void didChangeDependencies() async {
    if (firstTime) {
      final isAuthenticated = await LocalAuthApi.authenticate();
      if (isAuthenticated) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
      }
      firstTime = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    pinFocusNode.dispose();
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
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(
              height: customHeight * 0.025,
            ),
            const Text(
              "Enter MPIN to unlock app",
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
                  padding: EdgeInsets.only(right: customWidth * 0.15),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: pinObscure,
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
                      debugPrint("pin : $v");
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
                if (pin == data.mpin) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName, (Route<dynamic> route) => false);
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
                  style: Theme.of(context).textTheme.caption,
                ),
                GestureDetector(
                  child: const Text("Reset"),
                  onTap: () {
                    Navigator.pushNamed(context, LoginOtpScreen.routeName,
                        arguments: [
                          data.getData("ninNumber"),
                          data.getData("mobileNumber")
                        ]);
                  },
                ),
              ],
            ),
            SizedBox(
              height: customHeight * 0.025,
            ),
            Row(
              children: [
                const Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "OR",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                const Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            SizedBox(
              height: customHeight * 0.025,
            ),
            Center(
              child: InkWell(
                child: Column(
                  children: [
                    Icon(
                      Icons.fingerprint,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("USE BIOMETRICS"),
                  ],
                ),
                onTap: () async {
                  final isAuthenticated = await LocalAuthApi.authenticate();
                  if (isAuthenticated) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName, (Route<dynamic> route) => false);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
