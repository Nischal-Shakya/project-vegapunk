import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

        if (decodedMessage["type"] == "permit.create.success") {
          setState(() {
            permitId = decodedMessage["data"]["permit_id"];
            log(permitId);
            log(token);
            isLoading = false;
          });
        } else if (decodedMessage["type"] == "permit.accessed") {
          setState(() {
            viewers.add(decodedMessage["data"]["viewer"]);
            _listKey.currentState
                ?.insertItem(0, duration: const Duration(milliseconds: 700));
          });
        }
      });
    } else {
      Navigator.of(context).pop();
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("No Internet Connection"),
                duration: Duration(seconds: 2),
              )));
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
    final double customWidth = MediaQuery.of(context).size.width;
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
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 50, horizontal: customWidth * 0.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Scan with\nParichaya App',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: QrImage(
                          data: json.encode(
                              {"permit_id": permitId, "doc_type": docType}),
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Sharing:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.portrait_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Photo",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          FaIcon(
                            docType == "AGE"
                                ? Icons.calendar_month
                                : FontAwesomeIcons.idCard,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            docType == "AGE"
                                ? "Verified Age"
                                : "Driving License Details",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          viewers.isNotEmpty ? "Viewers:" : "",
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      AnimatedList(
                        key: _listKey,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index, animation) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: SizeTransition(
                              sizeFactor: animation,
                              axis: Axis.vertical,
                              child: FadeTransition(
                                opacity: animation,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      viewers[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
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
      ),
    );
  }
}
