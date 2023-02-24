// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
        setState(() {
          tapped = true;
        });
        var response =
            await http.get(Uri.parse("$checkNin/${ninNumbercontroller.text}"));
        log(response.body.toString());
        if (response.statusCode != 200) {
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
              style: Theme.of(context).textTheme.displayLarge,
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
              child: Text(
                "National Identity Number",
                style: Theme.of(context).textTheme.labelLarge,
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
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset(('assets/icons/id-card.svg'),
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn)),
                ),
              ),
              style: Theme.of(context).textTheme.labelLarge,
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.bottom,
              inputFormatters: [maskFormatter],
              autofocus: true,
            ),
            SizedBox(
              height: customHeight * 0.025,
            ),
            Container(
              height: 50,
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
                  : InkWell(
                      onTap: submitData,
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
