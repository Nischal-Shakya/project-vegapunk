import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/all_data.dart';

import '../screens/national_id_screen.dart';
import '../screens/error_screen.dart';

class DocumentsScreenList extends StatelessWidget {
  const DocumentsScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    final allDatalength =
        Provider.of<AllData>(context, listen: false).allDatalength;
    final double customWidth = MediaQuery.of(context).size.width;
    final List<String> chooseScreen = [
      NationalIdentityScreen.routeName,
    ];
    return Expanded(
        child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: allDatalength,
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
                      'https://i0.wp.com/www.tipsnepal.com/wp-content/uploads/2021/10/smart-driving-license_20200111094935.jpg?fit=960%2C589&quality=100&strip=all&ssl=1',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "National Identity",
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
