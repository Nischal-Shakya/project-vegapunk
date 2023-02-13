import 'package:flutter/material.dart';

import 'homescreen.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  static const routeName = '/error_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Page not found.",
              style: TextStyle(
                fontSize: 32,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
                },
                child: const Text("Go back to homescreen."))
          ],
        ),
      ),
    );
  }
}
