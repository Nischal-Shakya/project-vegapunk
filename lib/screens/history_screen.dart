import 'package:flutter/material.dart';
import './test.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: ((context) => const Test()))),
          child: const Text("history")),
    );
  }
}
