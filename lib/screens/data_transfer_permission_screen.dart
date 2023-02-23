// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/widgets/send_details_buttons.dart';
import '../widgets/send_details_helper.dart';
import 'package:provider/provider.dart';
import 'package:parichaya_frontend/providers/all_data.dart';

import 'package:http/http.dart' as http;
import '../url.dart';

class DataPermissionScreen extends StatelessWidget {
  const DataPermissionScreen({super.key});

  static const routeName = '/data_transfer_permission_screen';

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final result = ModalRoute.of(context)!.settings.arguments as Map;
    final String requestId = result["request_id"];
    final String token = Provider.of<AllData>(context, listen: false).token;

    return WillPopScope(
      onWillPop: () async {
        await http.post(
          Uri.parse('$scanRequestApprovalUrl/$requestId/approval/'),
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
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          titleSpacing: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Send details to:",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SendDetailsWidget(result: result),
            ],
          ),
        ),
        floatingActionButton: SendDetailsButtons(requestId: requestId),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
