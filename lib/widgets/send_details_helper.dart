import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/conversion.dart';

class SendDetailsWidget extends StatelessWidget {
  const SendDetailsWidget({required this.result, super.key});

  final Map result;

  @override
  Widget build(BuildContext context) {
    final double customHeight = MediaQuery.of(context).size.height;
    final String requester = result["requester"];
    final String requesterUrl = result["requester_url"];
    final List requestedFields = result["requested_fields"];
    final String image = result["requester_image"];

    final List<Map<String, String>> purifiedFields = [
      ...requestedFields.map((element) {
        return convertedField(element);
      }).toList()
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.network(
              image,
              fit: BoxFit.contain,
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              requester,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              requesterUrl,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(('assets/icons/verified.svg'),
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn)),
                ),
                Text(
                  "Verified Requester",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Text("Details you are sharing",
            style: Theme.of(context).textTheme.headlineMedium),
        const Divider(),
        SizedBox(
          height: customHeight * 0.42,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: ((context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Text(
                          purifiedFields[index]["fieldName"].toString(),
                          style: Theme.of(context).textTheme.labelLarge,
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
      ],
    );
  }
}
