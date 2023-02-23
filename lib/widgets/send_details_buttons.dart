import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parichaya_frontend/providers/all_data.dart';
import 'package:parichaya_frontend/screens/homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../url.dart';

class SendDetailsButtons extends StatelessWidget {
  const SendDetailsButtons({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final String token = Provider.of<AllData>(context, listen: false).token;

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
                      Uri.parse('$scanRequestApprovalUrl/$requestId/approval/'),
                      headers: {
                        "Authorization": "Token $token",
                        "Content-Type": "application/json",
                      },
                      body: json.encode({
                        "request_id": requestId,
                        "is_approved": false,
                      }),
                    )
                    .then((value) => Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
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
                      Uri.parse('$scanRequestApprovalUrl/$requestId/approval/'),
                      headers: {
                        "Authorization": "Token $token",
                        "Content-Type": "application/json",
                      },
                      body: json.encode({
                        "request_id": requestId,
                        "is_approved": true,
                      }),
                    )
                    .then((value) => Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Text(
                'Approve',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              tileColor: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              trailing: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
