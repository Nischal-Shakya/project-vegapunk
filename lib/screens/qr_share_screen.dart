// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:provider/provider.dart';
import '../providers/all_data.dart';
import '../url.dart';
import 'dart:convert';

import '../providers/connectivity_change_notifier.dart';

class QrShareScreen extends StatefulWidget {
  const QrShareScreen({
    super.key,
  });

  static const routeName = '/qr_share_screen';

  @override
  State<QrShareScreen> createState() => _QrShareScreenState();
}

class _QrShareScreenState extends State<QrShareScreen> {
  bool isLoading = true;
  late String permitId;
  late WebSocketChannel webSocketChannel;
  List<String> viewers = [];

  @override
  void didChangeDependencies() {
    final String token = Provider.of<AllData>(context, listen: false).token;
    final String docType = ModalRoute.of(context)!.settings.arguments as String;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

    if (connectionStatus) {
      webSocketChannel = WebSocketChannel.connect(
        Uri.parse('$getPermitIdUrl/?token=$token'),
      );
      debugPrint("initializing web socket connection");
      webSocketChannel.sink.add(jsonEncode({
        "type": "permit.create",
        "data": {"permitted_document_code": docType}
      }));
      debugPrint("Sending Data Via Web Socket");

      webSocketChannel.stream.listen((message) {
        Map<String, dynamic> decodedMessage = jsonDecode(message);
        debugPrint("message$message");
        if (decodedMessage["type"] == "permit.create.success") {
          debugPrint("message:$message");
          setState(() {
            permitId = decodedMessage["data"]["permit_id"];
            isLoading = false;
          });
          debugPrint(permitId.toString());
        } else if (decodedMessage["type"] == "permit.accessed") {
          setState(() {
            viewers.add(decodedMessage["data"]["viewer"]);
          });
        }
      });
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No Internet Connection"),
        duration: Duration(seconds: 2),
      ));
    }

    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    webSocketChannel.sink.close();
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          // iconTheme: IconThemeData(color: Colors.black),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  QrImage(
                    // backgroundColor: Colors.white,
                    data: json.encode({"permit_id": permitId}),
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: ((context, index) {
                        return Center(
                            child: Text(
                                "${viewers[index]} is viewing your proof of age"));
                      }),
                      itemCount: viewers.length,
                      physics: const ScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
