import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/documents.dart';

import '../screens/driving_license_screen.dart';
import '../screens/national_identity_screen.dart';
import '../screens/error_screen.dart';

class DocumentsScreenList extends StatelessWidget {
  const DocumentsScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    final docData = Provider.of<Documents>(context, listen: false).allDocuments;
    final double customWidth = MediaQuery.of(context).size.width;
    final List<String> chooseScreen = [
      NationalIdentityScreen.routeName,
      DrivingLicenseScreen.routeName,
    ];
    return Expanded(
        child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: docData.length,
      padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
      itemBuilder: (BuildContext ctx, index) {
        return Card(
          elevation: 2,
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context,
                  index > (chooseScreen.length - 1)
                      ? ErrorScreen.routeName
                      : chooseScreen[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 50,
                    height: 50,
                    child: Image.network(
                      docData[index].docUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      docData[index].docName,
                      style: Theme.of(context).textTheme.subtitle1,
                      softWrap: false,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
