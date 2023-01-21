import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parichaya_frontend/providers/preferences.dart';
import 'package:parichaya_frontend/screens/homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../url.dart';

class SendDetailsButtons extends StatelessWidget {
  const SendDetailsButtons({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final String token =
        Provider.of<Preferences>(context, listen: false).jwtToken;

    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () async {
                await http
                    .post(
                      Uri.parse(
                          '$url/api/v1/scan-request/$requestId/approval/'),
                      headers: {
                        "Authorization": "Token $token",
                        "Content-Type": "application/json",
                      },
                      body: json.encode({
                        "request_id": requestId,
                        "is_approved": false,
                      }),
                    )
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false));
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
              onTap: () async {
                await http
                    .post(
                      Uri.parse(
                          '$url/api/v1/scan-request/$requestId/approval/'),
                      headers: {
                        "Authorization": "Token $token",
                        "Content-Type": "application/json",
                      },
                      body: json.encode({
                        "request_id": requestId,
                        "is_approved": true,
                      }),
                    )
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false));
              },
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
