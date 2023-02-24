import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/conversion.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

get purifiedFields => null;

String returnIcon(BuildContext context, String activity) {
  String iconPath;
  if (activity == "logged_in") {
    iconPath = 'assets/icons/login.svg';
  } else if (activity == "qr_generated") {
    iconPath = 'assets/icons/qr-code.svg';
  } else if (activity == "viewed_shared_details") {
    iconPath = 'assets/icons/eye.svg';
  } else {
    iconPath = 'assets/icons/verified-document.svg';
  }
  return iconPath;
}

void historyModalBottomSheet(
  BuildContext context,
  final Map<String, dynamic> data,
) {
  final double customWidth = MediaQuery.of(context).size.width;
  final List requestedFields = data["extra_info"]["fields"];
  requestedFields
      .removeWhere((element) => element == "card_back" || element == "docType");
  final List<String> purifiedFields = [
    ...requestedFields.map((element) {
      return convertedFieldName(element);
    }).toList()
  ];
  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isScrollControlled: true,
    elevation: 10,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.7,
      minChildSize: 0.32,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 90,
                height: 6,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 0,
                      visualDensity: VisualDensity.compact,
                      leading: SizedBox(
                        height: 24,
                        width: 24,
                        child: SvgPicture.asset(
                          returnIcon(context, data['activity']),
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      title: Text(data["title"],
                          style: Theme.of(context).textTheme.headlineMedium),
                      subtitle: Text(
                          DateFormat('MMM d yyyy, h:mm a')
                              .format(DateTime.parse(data["created_at"])),
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.shadow)),
                    ),
                    const Divider(),
                    Text(data["description"],
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onBackground)),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("You shared:",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                purifiedFields[index].toString(),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      }),
                      itemCount: purifiedFields.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
