import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/all_data.dart';

import '../screens/qr_scan_screen.dart';

class DocumentsProfileBox extends StatelessWidget {
  const DocumentsProfileBox({super.key});

  @override
  Widget build(BuildContext context) {
    // final nIN = Provider.of<AllData>(context, listen: false).nIN;
    // final fullName = Provider.of<AllData>(context, listen: false).fullName;
    const nIN = "118-461-296-5";
    const fullName = "Nischal Shakya";

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
              height: 140,
              width: customWidth * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nIN.length > 13
                                  ? "${nIN.substring(0, 10)}..."
                                  : nIN,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Text(
                              'National Identity Number',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: nIN));
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Copied to clipboard.'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.grey,
                              ));
                            },
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              )),
        ),
        Positioned(
          left: customWidth * 0.725,
          top: 130,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              Navigator.pushNamed(context, QrScanScreen.routeName);
            },
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
