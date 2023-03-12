// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parichaya_frontend/providers/auth_provider.dart';
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
        Provider.of<AuthDataProvider>(context, listen: false).token!;

    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ListTile(
                  dense: true,
                  onTap: () async {
                    http.post(
                      Uri.parse('$accessRequestUrl/$requestId/approval/'),
                      headers: {
                        "Authorization": "Token $token",
                        "Content-Type": "application/json",
                      },
                      body: json.encode({
                        "request_id": requestId,
                        "is_approved": false,
                      }),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Request Denied.'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.grey,
                    ));
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  title: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  textColor: Colors.blue,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ListTile(
                  dense: true,
                  onTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Approving Request.'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.grey,
                    ));
                    http.post(
                      Uri.parse('$accessRequestUrl/$requestId/approval/'),
                      headers: {
                        "Authorization": "Token $token",
                        "Content-Type": "application/json",
                      },
                      body: json.encode({
                        "request_id": requestId,
                        "is_approved": true,
                      }),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Request Approved.'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.grey,
                    ));
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  title: const Text(
                    'Approve',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  tileColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.background,
                  trailing: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.onPrimary,
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
