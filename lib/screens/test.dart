import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/all_data.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    final y = Provider.of<AllData>(context, listen: false).faceImage;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child: Text(y.split(',')[1].toString())),
    );
  }
}
