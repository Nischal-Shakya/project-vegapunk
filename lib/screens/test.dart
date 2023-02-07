import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/all_data.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    final y = Provider.of<AllData>(context, listen: false);

    // log(y.getDataFromBox().toString());
    log(y.getDvlData().toString());

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Text(y.getCtzData().toString()),
        ));
  }
}
