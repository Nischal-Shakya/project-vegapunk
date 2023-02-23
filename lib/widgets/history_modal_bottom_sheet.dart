import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/conversion.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

get purifiedFields => null;

Widget returnIcon(BuildContext context, String activity) {
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
  return SvgPicture.asset(
    iconPath,
    colorFilter: ColorFilter.mode(
      Theme.of(context).colorScheme.primary,
      BlendMode.srcIn,
    ),
  );
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
      maxChildSize: 0.8,
      minChildSize: 0.32,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 20,
                    height: 2,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: SizedBox(
                  height: 30,
                  width: 30,
                  child: returnIcon(context, data['activity']),
                ),
                title: Text(data["title"],
                    style: Theme.of(context).textTheme.headlineMedium),
                subtitle: Text(
                    DateFormat('MMM d yyyy, h:mm a')
                        .format(DateTime.parse(data["created_at"])),
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              const Divider(),
              Text(data["description"],
                  style: Theme.of(context).textTheme.headlineSmall),
              Text("You shared:",
                  style: Theme.of(context).textTheme.headlineSmall),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
                itemBuilder: ((context, index) {
                  return Text("\u2022  ${purifiedFields[index]}",
                      style: Theme.of(context).textTheme.headlineSmall);
                }),
                itemCount: purifiedFields.length,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
