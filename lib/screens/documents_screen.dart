import 'package:flutter/material.dart';

import '../widgets/documents_screen_list.dart';
import '../widgets/documents_profile_box.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

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
