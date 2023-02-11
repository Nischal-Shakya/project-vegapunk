import 'package:flutter/material.dart';
import './test.dart';
// import 'dart:html';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Center(
          //     child: TextButton(
          //   onPressed: () {
          //     webSocketChannel.sink.close();
          //     debugPrint("Web Socket Closing");
          //   },
          //   child: const Text("end"),
          // )),
          // Center(
          //   child: TextButton(
          //     onPressed: () {
          //       http.get(Uri.parse("$getPidDataUrl/$permitId/"), headers: {
          //         "Authorization": "Token $token"
          //       }).then((value) => debugPrint(
          //             value.body.toString(),
          //           ));
          //     },
          //     child: const Text("hit"),
          //   ),
          // ),
          Center(
            child: TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const Test()))),
                child: const Text("Data")),
          ),
          // StreamBuilder(
          //   stream: webSocketChannel.stream,
          //   builder: (context, snapshot) {
          //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
          //   },
          // ),
        ],
      ),
    );
  }
}
