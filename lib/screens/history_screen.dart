import 'dart:convert';
import 'dart:developer';

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
    setState(() {
      isLoading = false;
    });

    log(response.body.toString());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index]["title"]),
                    subtitle: Column(
                      children: [
                        Text(data[index]["description"]),
                        Text(data[index]["created_at"]),
                      ],
                    ),
                  );
                },
                itemCount: data.length,
              ));
  }
}
