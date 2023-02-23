import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/conversion.dart';

class SendDetailsWidget extends StatelessWidget {
  const SendDetailsWidget({required this.result, super.key});

  final Map result;

  @override
  Widget build(BuildContext context) {
    final double customHeight = MediaQuery.of(context).size.height;
    final double customWidth = MediaQuery.of(context).size.width;
    final String requester = result["requester"];
    final String requesterUrl = result["requester_url"];
    final List requestedFields = result["requested_fields"];
    final image = result["requester_image"];

    final List<Map<String, String>> purifiedFields = [
      ...requestedFields.map((element) {
        return convertedField(element);
      }).toList()
    ];

    debugPrint(result.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
                width: 100,
                height: 100,
                child: Image.network(
                  image,
                  fit: BoxFit.contain,
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
              requester,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Text(
              requesterUrl,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset(('assets/icons/verified.svg'),
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onBackground,
                          BlendMode.srcIn)),
                ),
                Text(
                  "Verified Requester",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
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
            physics: const ScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
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
                          purifiedFields[index]["category"].toString() !=
                                  "National Identity"
                              ? purifiedFields[index]["category"].toString()
                              : "",
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
