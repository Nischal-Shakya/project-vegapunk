import 'package:flutter/material.dart';

import '../widgets/documents_screen_list.dart';
import '../widgets/documents_profile_box.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DocumentsProfileBox(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: customWidth * 0.08),
          child: const Text(
            "DOCUMENTS",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const DocumentsScreenList(),
      ],
    );
  }
}
