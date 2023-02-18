import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../url.dart';
import 'package:http/http.dart' as http;
import '../providers/all_data.dart';
import 'package:provider/provider.dart';
import '../providers/connectivity_change_notifier.dart';
import '../providers/homescreen_index_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

bool isLoading = true;

class _HistoryScreenState extends State<HistoryScreen> {
  late List data;

  @override
  void didChangeDependencies() async {
    isLoading = true;
    String token = Provider.of<AllData>(context).token;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

    if (connectionStatus) {
      var response = await http.get(Uri.parse(getHistoryUrl),
          headers: {"Authorization": "Token $token"});
      data = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  Widget returnIcon(String activity) {
    Color iconColor = Theme.of(context).colorScheme.primary;
    if (activity == "logged_in") {
      return Icon(Icons.login_outlined, color: iconColor);
    } else if (activity == "qr_generated") {
      return Icon(Icons.qr_code_2, color: iconColor);
    } else if (activity == "viewed_shared_details") {
      return Icon(Icons.remove_red_eye_outlined, color: iconColor);
    } else {
      return Icon(Icons.file_download_done_outlined, color: iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();
    final indexProvider = Provider.of<HomeScreenIndexProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        indexProvider.indexBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title:
              Text('History', style: Theme.of(context).textTheme.headlineSmall),
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Fetching History"),
                  ],
                ),
              )
            : connectionStatus
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return IntrinsicHeight(
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: customWidth * 0.05),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    VerticalDivider(
                                      thickness: 3,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            color: Colors.white),
                                        child: returnIcon(
                                            data[index]["activity"])),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.only(
                                            bottom: 10,
                                            right: customWidth * 0.05),
                                        splashColor: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.3),
                                        title: Text(
                                          data[index]["title"],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index]["description"],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              DateFormat('MMM d yyyy, h:mm a')
                                                  .format(DateTime.parse(
                                                      data[index]
                                                          ["created_at"])),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing:
                                            data[index]["extra_info"] != null
                                                ? const Icon(
                                                    Icons.keyboard_arrow_down)
                                                : null,
                                        onTap: () {
                                          log(data[index]["extra_info"]
                                              .toString());
                                        },
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: data.length,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.wifi_off,
                          color: Colors.blue,
                          size: 60,
                        ),
                        SizedBox(height: 10),
                        Text("No Internet Access"),
                      ],
                    ),
                  ),
      ),
    );
  }
}
