import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
      Navigator.pushReplacementNamed(context, LoginMobileScreen.routeName,
          arguments: ninNumbercontroller.text);
    }

    return Scaffold(
      body: SizedBox(
        width: customWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PARICHAYA',
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
              'A DECENTRALIZED IDENTITY STORAGE\nAND SHARING APP',
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
              controller: ninNumbercontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blue)),
                  constraints: BoxConstraints(
                      maxHeight: 50, maxWidth: customWidth * 0.68),
                  hintText: "National Identity Number",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade300,
                  )),
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.number,
              // autofocus: true,
              textAlign: TextAlign.center,
              inputFormatters: [maskFormatter],
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
                  onTap: submitData,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  title: const Text(
                    'LOG IN',
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
