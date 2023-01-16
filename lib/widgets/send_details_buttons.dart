import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/homescreen.dart';

class SendDetailsButtons extends StatelessWidget {
  const SendDetailsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: const Text(
                'Cancel',
                textAlign: TextAlign.center,
              ),
              textColor: Colors.blue,
            ),
          ),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: const Text(
                'Send details',
                textAlign: TextAlign.center,
              ),
              tileColor: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              trailing: const Icon(Icons.send),
            ),
          ),
        ),
      ],
    );
  }
}
