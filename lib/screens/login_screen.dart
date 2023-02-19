// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:parichaya_frontend/custom_icons/custom_id_card_icon.dart';
import './login_mobile_screen.dart';
import 'package:http/http.dart' as http;
import '../providers/connectivity_change_notifier.dart';
import 'package:provider/provider.dart';
import '../url.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController ninNumbercontroller = TextEditingController();
  final FocusScopeNode currentFocus = FocusScopeNode();

  @override
  void dispose() {
    ninNumbercontroller.dispose();
    super.dispose();
  }

  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;
    Provider.of<ConnectivityChangeNotifier>(context).initialLoad();

    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

    var maskFormatter = MaskTextInputFormatter(
        mask: '###-###-###-#',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    void submitData() async {
      if (ninNumbercontroller.text.isEmpty ||
          ninNumbercontroller.text.length != 13) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid National Identity Number"),
          duration: Duration(seconds: 2),
        ));
      } else if (!connectionStatus) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No Internet Access"),
          duration: Duration(seconds: 2),
        ));
      } else {
        log("checking if nin exists");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Checking National Identity Number"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.grey,
        ));
        setState(() {
          tapped = true;
        });
        var response =
            await http.get(Uri.parse("$checkNin/${ninNumbercontroller.text}"));
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              ("Invalid National Identity Number"),
            ),
            duration: Duration(seconds: 2),
          ));
        } else {
          Navigator.of(context, rootNavigator: true).pushNamed(
              LoginMobileScreen.routeName,
              arguments: ninNumbercontroller.text);
        }
        setState(() {
          tapped = false;
        });
      }
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
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Enter your National Identity Number\nto get started.',
              style: Theme.of(context).textTheme.labelLarge,
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
              focusNode: currentFocus,
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
              autofocus: true,
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
                child: Center(
                  child: tapped
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
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
