import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../url.dart';
import 'package:http/http.dart' as http;
import '../providers/all_data.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List data;
  bool isLoading = true;
  @override
  void didChangeDependencies() async {
    String token = Provider.of<AllData>(context).token;

    var response = await http.get(Uri.parse(getHistoryUrl),
        headers: {"Authorization": "Token $token"});
    data = json.decode(response.body);
    debugPrint(data.toString());
    setState(() {
      isLoading = false;
    });

    log(response.body.toString());
    super.didChangeDependencies();
  }

  Widget returnIcon(String activity) {
    debugPrint(activity);
    if (activity == "logged_in") {
      return const Icon(Icons.abc_outlined);
    } else if (activity == "qr_generated") {
      return const Icon(Icons.access_alarms);
    } else if (activity == "viewed_shared_details") {
      return const Icon(Icons.access_alarms_rounded);
    } else {
      return const Icon(Icons.access_alarms_sharp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
<<<<<<< HEAD
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
=======
            ? const CircularProgressIndicator()
            : ListView.builder(
>>>>>>> main
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              const VerticalDivider(
                                endIndent: 0,
                                indent: 0,
                                thickness: 1,
                                color: Colors.blue,
                              ),
                              returnIcon(data[index]["activity"]),
                            ]),
                      ),
                      SizedBox(
                        width: 300,
                        child: ListTile(
                          title: Text(
                            data[index]["title"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index]["description"],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                DateFormat('MMM d yyyy, h:mm a').format(
                                    DateTime.parse(data[index]["created_at"])),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: data.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  indent: 80,
                  height: 12,
                ),
              ));
  }
}
