import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        physics: const BouncingScrollPhysics(),
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
              Row(
                children: [
                  Text(
                    fieldNames[index].toString().contains("devanagari")
                        ? utf8.decode(fieldValues[index].toString().codeUnits)
                        : fieldValues[index].toString(),
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                          text: fieldNames[index]
                                  .toString()
                                  .contains("devanagari")
                              ? utf8.decode(
                                  fieldValues[index].toString().codeUnits)
                              : fieldValues[index].toString(),
                        ));
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Copied to clipboard.'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.grey,
                        ));
                      },
                      icon: const Icon(Icons.copy)),
                ],
              ),
              const Divider(height: 10),
            ],
          );
        }),
        itemCount: fieldNames.length,
      ),
    );
  }
}
