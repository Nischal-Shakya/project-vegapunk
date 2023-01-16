import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/national_id.dart';

class NationalIdentityScreen extends StatelessWidget {
  const NationalIdentityScreen({super.key});

  static const routeName = '/National_Identity_Screen/';

  @override
  Widget build(BuildContext context) {
    final nIdData = Provider.of<NationalId>(context, listen: false).nIdData;
    final double customWidth = MediaQuery.of(context).size.width;

    var nationalIdData = {
      'Name': nIdData.name,
      'National Identity Number': nIdData.nationalID
    };

    return Scaffold(
      appBar: AppBar(title: const Text('National Identity Card')),
      body: Padding(
          padding: EdgeInsets.all(customWidth * 0.05),
          child: ListView.builder(
            itemBuilder: ((context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nationalIdData.keys.toList()[index],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(nationalIdData.values.toList()[index]),
                  const Divider(),
                ],
              );
            }),
            itemCount: nationalIdData.length,
          )),
    );
  }
}
