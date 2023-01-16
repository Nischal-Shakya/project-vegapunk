import 'package:flutter/material.dart';
import '../custom_icons/custom_icons.dart';
import '../models/conversion.dart';

class SendDetailsWidget extends StatelessWidget {
  const SendDetailsWidget({required this.result, super.key});

  final Map result;

  @override
  Widget build(BuildContext context) {
    final double customHeight = MediaQuery.of(context).size.height;
    final double customWidth = MediaQuery.of(context).size.width;
    final String id = result["id"];
    final String requester = result["requester"];
    final List requestedFields = result["requested_fields"];
    final List<Map<String, String>> purifiedFields = [
      ...requestedFields.map((element) {
        return convertedField(element);
      }).toList()
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: customWidth * 0.05,
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            leading: CircleAvatar(
              radius: 30,
              child: Text(
                requester[0].toUpperCase(),
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              requester,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
            ),
            subtitle: Row(
              children: [
                Icon(
                  CustomIcons.shieldCheck,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Recognized by Parichaya',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.shadow),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              customWidth * 0.05, 10, customWidth * 0.05, 0),
          child: const Text("Details you will send",
              style: TextStyle(color: Colors.black)),
        ),
        const Divider(),
        SizedBox(
          height: customHeight * 0.6,
          child: ListView.builder(
            itemBuilder: ((context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: customWidth * 0.05),
                    child: Row(
                      children: [
                        Text(
                          purifiedFields[index]["fieldName"].toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.shadow),
                        ),
                        const Spacer(),
                        Text(
                          purifiedFields[index]["category"].toString(),
                          style: TextStyle(
                              color: Colors.blueAccent.shade200, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
            }),
            itemCount: requestedFields.length,
            padding: const EdgeInsets.all(0),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
