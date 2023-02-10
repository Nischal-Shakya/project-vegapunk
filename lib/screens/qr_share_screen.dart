import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrShareScreen extends StatelessWidget {
  const QrShareScreen({super.key});

  static const routeName = '/qr_share_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Center(
            child: QrImage(
              data: 'Dikshya is a dumbass',
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                return Container(
                  height: 500,
                  child: const Center(
                    child: Text("123"),
                  ),
                );
              }),
              itemCount: 2,
              physics: const ScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
