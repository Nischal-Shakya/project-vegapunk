import 'dart:developer';

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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  late String docType;

  @override
  void didChangeDependencies() {
    final String token = Provider.of<AllData>(context, listen: false).token;
    docType = ModalRoute.of(context)!.settings.arguments as String;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

    if (connectionStatus) {
      webSocketChannel = WebSocketChannel.connect(
        Uri.parse('$getPermitIdUrl/?token=$token'),
      );
      log("initializing web socket connection");
      webSocketChannel.sink.add(jsonEncode({
        "type": "permit.create",
        "data": {"permitted_document_code": docType}
      }));
      log("Sending Data Via Web Socket");

      webSocketChannel.stream.listen((message) {
        Map<String, dynamic> decodedMessage = jsonDecode(message);
        log("message$message");
        if (decodedMessage["type"] == "permit.create.success") {
          log("message:$message");
          setState(() {
            permitId = decodedMessage["data"]["permit_id"];
            log(permitId);
            log(token);
            isLoading = false;
          });
          log(permitId.toString());
        } else if (decodedMessage["type"] == "permit.accessed") {
          setState(() {
            viewers.add(decodedMessage["data"]["viewer"]);
            _listKey.currentState
                ?.insertItem(0, duration: const Duration(milliseconds: 700));
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
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Share Qr Code',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    QrImage(
                      // backgroundColor: Colors.white,
                      data: json
                          .encode({"permit_id": permitId, "doc_type": docType}),
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            "Scan this Qr Code to view User's Information."),
                      ),
                    ),
                    AnimatedList(
                      key: _listKey,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index, animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.vertical,
                          child: SlideTransition(
                            position: animation.drive(Tween(
                                    begin: const Offset(-1, 0),
                                    end: Offset.zero)
                                .chain(CurveTween(curve: Curves.easeOutCubic))),
                            child: FadeTransition(
                              opacity: animation,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.remove_red_eye,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  Text(
                                    "${viewers[index]} viewed your ${docType == "AGE" ? 'proof of age' : 'driving license details'}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
