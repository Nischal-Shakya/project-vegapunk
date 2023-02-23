import 'package:flutter/material.dart';
import '../widgets/send_details_buttons.dart';
import '../widgets/send_details_helper.dart';

class DataPermissionScreen extends StatelessWidget {
  const DataPermissionScreen({super.key});

  static const routeName = '/data_transfer_permission_screen';

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final result = ModalRoute.of(context)!.settings.arguments as Map;
    final String requestId = result["request_id"];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                customWidth * 0.05,
                AppBar().preferredSize.height * 1.5,
                customWidth * 0.05,
                0,
              ),
              child: const Text(
                "Send details to:",
              ),
            ),
            SendDetailsWidget(result: result),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
              child: SendDetailsButtons(
                requestId: requestId,
              ),
            )
          ],
        ),
      ),
    );
  }
}
