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
    return Column(
      children: const [
        DocumentsProfileBox(),
        DocumentsScreenList(),
      ],
    );
  }
}
