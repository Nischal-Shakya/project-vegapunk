import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/url.dart';
import './test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../providers/all_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
// import 'dart:html';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history_screen';

  @override
  Widget build(BuildContext context) {
    final String token = Provider.of<AllData>(context, listen: false).token;
    late WebSocketChannel webSocketChannel;
    late String permitId;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
              child: TextButton(
            onPressed: () {
              webSocketChannel = WebSocketChannel.connect(
                Uri.parse('$getPermitIdUrl$token'),
              );

              debugPrint(token);
              debugPrint("initializing web socket connection");
            },
            child: const Text("start connection"),
          )),
          Center(
              child: TextButton(
            onPressed: () {
              webSocketChannel.sink.add(jsonEncode({
                "type": "permit.create",
                "data": {"permitted_document_code": "AGE"}
              }));

              debugPrint(token);
              debugPrint("Sending Data Via Web Socket");
              webSocketChannel.stream.listen((message) {
                debugPrint(message);
                permitId = jsonDecode(message)["data"]["permit_id"];
                debugPrint(permitId);
              });
            },
            child: const Text("send data"),
          )),
          Center(
              child: TextButton(
            onPressed: () {
              webSocketChannel.sink.close();
              debugPrint("Web Socket Closing");
            },
            child: const Text("end"),
          )),
          Center(
            child: TextButton(
              onPressed: () {
                http.get(Uri.parse("$getPidDataUrl/$permitId/"), headers: {
                  "Authorization": "Token $token"
                }).then((value) => debugPrint(
                      value.body.toString(),
                    ));
              },
              child: const Text("hit"),
            ),
          ),
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
