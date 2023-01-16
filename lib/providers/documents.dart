import 'package:flutter/material.dart';

import '../models/document.dart';

class Documents with ChangeNotifier {
  final List<Document> _docs = [
    Document(
      'D1',
      'National Identity Card',
      'https://i0.wp.com/www.tipsnepal.com/wp-content/uploads/2021/10/smart-driving-license_20200111094935.jpg?fit=960%2C589&quality=100&strip=all&ssl=1',
    ),
    Document(
      'D2',
      'Driving License',
      'https://i0.wp.com/www.tipsnepal.com/wp-content/uploads/2021/10/smart-driving-license_20200111094935.jpg?fit=960%2C589&quality=100&strip=all&ssl=1',
    ),
    Document(
      'D3',
      'Citizenship',
      'https://i0.wp.com/www.tipsnepal.com/wp-content/uploads/2021/10/smart-driving-license_20200111094935.jpg?fit=960%2C589&quality=100&strip=all&ssl=1',
    ),
    Document(
      'D4',
      'Birth Certificate',
      'https://i0.wp.com/www.tipsnepal.com/wp-content/uploads/2021/10/smart-driving-license_20200111094935.jpg?fit=960%2C589&quality=100&strip=all&ssl=1',
    ),
  ];

  List<Document> get allDocuments {
    return [..._docs];
  }
}
