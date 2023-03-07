import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:parichaya_frontend/providers/auth_provider.dart';
import 'package:parichaya_frontend/widgets/history_modal_bottom_sheet.dart';
import 'package:flutter_svg/svg.dart';
import '../url.dart';
import 'package:http/http.dart' as http;
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
  bool isInitialized = false;

  @override
  void didChangeDependencies() async {
    if (!isInitialized) {
      isLoading = true;
      String token =
          Provider.of<AuthDataProvider>(context, listen: false).token ?? "";
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
    }
    setState(() {
      isInitialized = true;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    bool connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();
    String token =
        Provider.of<AuthDataProvider>(context, listen: false).token ?? "";

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
            : RefreshIndicator(
                onRefresh: () async {
                  var response = await http.get(Uri.parse(getHistoryUrl),
                      headers: {"Authorization": "Token $token"});
                  data = json.decode(response.body);
                },
                color: Theme.of(context).colorScheme.onBackground,
                backgroundColor: Theme.of(context).colorScheme.background,
                child: connectionStatus
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(6),
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                // border: Border.all(
                                                //     color: Theme.of(context)
                                                //         .colorScheme
                                                //         .primary),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                returnIcon(context,
                                                    data[index]['activity']),
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.only(
                                              bottom: 10,
                                            ),
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        data[index]
                                                            ["description"],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall,
                                                      ),
                                                    ),
                                                    data[index]["extra_info"] !=
                                                            null
                                                        ? const Icon(Icons
                                                            .keyboard_arrow_down)
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    DateFormat(
                                                            'MMM d yyyy, h:mm a')
                                                        .format(DateTime.parse(
                                                            data[index][
                                                                "created_at"])),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .shadow)),
                                              ],
                                            ),
                                            onTap: data[index]["extra_info"] ==
                                                    null
                                                ? null
                                                : () {
                                                    log(data[index]
                                                            ["extra_info"]
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
      ),
    );
  }
}
