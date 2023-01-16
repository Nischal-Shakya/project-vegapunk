import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './login_otp_screen.dart';

class LoginMobileScreen extends StatelessWidget {
  LoginMobileScreen({super.key});

  static const routeName = '/login_mobile_screen';

  final mobileNumbercontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;
    final String ninNumber =
        ModalRoute.of(context)!.settings.arguments as String;

    void submitMobileNumber() {
      if (mobileNumbercontroller.text.isEmpty ||
          mobileNumbercontroller.text.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid Mobile Number"),
          duration: Duration(seconds: 2),
        ));
        return;
      }
      Navigator.pushReplacementNamed(context, LoginOtpScreen.routeName,
          arguments: [ninNumber, mobileNumbercontroller.text]);
    }

    return Scaffold(
      body: SizedBox(
        width: customWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Moblie Number',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Type in your Mobile Number\nassociated with your \nNational Identity Card',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: customHeight * 0.2,
            ),
            TextField(
              controller: mobileNumbercontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blue)),
                  constraints: BoxConstraints(
                      maxHeight: 50, maxWidth: customWidth * 0.68),
                  hintText: "Mobile Number",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade300,
                  )),
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.number,
              autofocus: true,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
            ),
            SizedBox(
              height: customHeight * 0.025,
            ),
            SizedBox(
              width: customWidth * 0.7,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  onTap: submitMobileNumber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  title: const Text(
                    'NEXT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  tileColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
