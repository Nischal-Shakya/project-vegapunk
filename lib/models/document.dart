import 'package:flutter/material.dart';

class Document {
  @required
  final String docId;
  @required
  final String docName;
  @required
  final String docUrl;

  Document(this.docId, this.docName, this.docUrl);
}
