import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:parichaya_frontend/custom_icons/custom_id_card_icon.dart';
import './login_mobile_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static const routeName = '/login_screen';

  final TextEditingController ninNumbercontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;

    var maskFormatter = MaskTextInputFormatter(
        mask: '###-###-###-#',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    void submitData() {
      if (ninNumbercontroller.text.isEmpty ||
          ninNumbercontroller.text.length != 13) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid National Identity Number"),
          duration: Duration(seconds: 2),
        ));
        return;
      }
      // log(ninNumbercontroller.text);
      Navigator.pushNamed(context, LoginMobileScreen.routeName,
          arguments: ninNumbercontroller.text);
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: customWidth * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PARICHAYA',
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Enter your National Identity Number\nto get started.',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: customHeight * 0.2,
            ),
            SizedBox(
              width: customWidth,
              child: const Text(
                "National Identity Number",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: ninNumbercontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.blue)),
                constraints: const BoxConstraints(maxHeight: 50),
                hintText: "123-456-789-0",
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(
                  CustomIdCardIcon.idCard,
                  size: 20,
                ),
                iconColor: Colors.black,
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.bottom,
              inputFormatters: [maskFormatter],
            ),
            SizedBox(
              height: customHeight * 0.025,
            ),
            InkWell(
              onTap: submitData,
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
          ],
        ),
      ),
    );
  }
}
