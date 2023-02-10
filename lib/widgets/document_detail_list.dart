import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/conversion.dart';

class DocumentDetailList extends StatelessWidget {
  const DocumentDetailList({
    Key? key,
    required this.fieldNames,
    required this.fieldValues,
  }) : super(key: key);

  final List fieldNames;
  final List fieldValues;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: ((context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                convertedFieldName(fieldNames[index]),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                fieldNames[index].toString().contains("devanagari")
                    ? utf8.decode(fieldValues[index].toString().codeUnits)
                    : fieldValues[index].toString(),
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              const Divider(height: 20),
            ],
          );
        }),
        itemCount: fieldNames.length,
      ),
    );
  }
}
