import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../providers/national_id.dart';
import '../screens/qr_scan_screen.dart';

class DocumentsProfileBox extends StatelessWidget {
  const DocumentsProfileBox({super.key});

  @override
  Widget build(BuildContext context) {
    final nIddata = Provider.of<NationalId>(context, listen: false).nIdData;
    final double customWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        const Positioned(
            child: SizedBox(
          height: 240,
        )),
        Positioned(
          child: Container(
              margin: EdgeInsets.fromLTRB(
                  customWidth * 0.05, 24, customWidth * 0.05, 0),
              height: 160,
              width: customWidth * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nIddata.name,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Container(
                      height: 80,
                      width: customWidth * 0.5,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(customWidth * 0.04),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  nIddata.nationalID.length > 10
                                      ? '${nIddata.nationalID.substring(0, 7)}...'
                                      : nIddata.nationalID,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                Text(
                                  'Parichaya Number',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: nIddata.nationalID));
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Copied to clipboard.'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.black54,
                                  ));
                                },
                                icon: Icon(
                                  Icons.copy,
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
        Positioned(
          // scan8cY (160:620)
          left: customWidth * 0.725,
          top: 150,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, QrScanScreen.routeName);
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 5,
                    strokeAlign: StrokeAlign.outside),
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Icon(Icons.qr_code_scanner,
                    size: 40, color: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
