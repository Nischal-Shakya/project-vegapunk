import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:parichaya_frontend/widgets/history_modal_bottom_sheet.dart';
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
    log(token);
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();

    if (connectionStatus) {
      var response = await http.get(Uri.parse(getHistoryUrl),
          headers: {"Authorization": "Token $token"});
      data = json.decode(response.body);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    super.didChangeDependencies();
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Activity History',
                      style: Theme.of(context).textTheme.headlineLarge)),
            ),
          ),
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      "Fetching History",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              )
            : connectionStatus
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
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
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            color: Colors.white),
                                        child: returnIcon(
                                            context, data[index]["activity"])),
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
                                        title: Text(data[index]["title"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(data[index]["description"],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                DateFormat('MMM d yyyy, h:mm a')
                                                    .format(DateTime.parse(
                                                        data[index]
                                                            ["created_at"])),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall),
                                          ],
                                        ),
                                        trailing:
                                            data[index]["extra_info"] != null
                                                ? const Icon(
                                                    Icons.keyboard_arrow_down)
                                                : null,
                                        onTap: data[index]["extra_info"] == null
                                            ? null
                                            : () {
                                                log(data[index]["extra_info"]
                                                    .toString());
                                                historyModalBottomSheet(
                                                    context, data[index]);
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
