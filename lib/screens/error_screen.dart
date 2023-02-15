import 'package:flutter/material.dart';

import 'homescreen.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  static const routeName = '/error_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Internet Not Available",
              style: TextStyle(
                fontSize: 32,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Check your internet connection",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
                  },
                  child: const Text(
                    "Go back to homescreen",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
