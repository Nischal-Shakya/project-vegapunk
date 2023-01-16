import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/homescreen.dart';
import '../widgets/send_details_buttons.dart';
import '../widgets/send_details_helper.dart';

class DataPermissionScreen extends StatefulWidget {
  const DataPermissionScreen({super.key});

  static const routeName = '/data_transfer_permission_screen';

  @override
  State<DataPermissionScreen> createState() => _DataPermissionScreenState();
}

class _DataPermissionScreenState extends State<DataPermissionScreen> {
  Future<bool> _onWillPop() async {
    return (await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false)) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final result = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
        ),
        body: Column(
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
                style: TextStyle(fontSize: 28, color: Colors.black),
              ),
            ),
            SendDetailsWidget(result: result),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
              child: const SendDetailsButtons(),
            )
          ],
        ),
      ),
    );
  }
}
