import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/all_data.dart';

import '../screens/qr_scan_screen.dart';

class DocumentsProfileBox extends StatelessWidget {
  const DocumentsProfileBox({super.key});

  @override
  Widget build(BuildContext context) {
    final nIN = Provider.of<AllData>(context, listen: false).nIN;
    final fullName = Provider.of<AllData>(context, listen: false).fullName;

    final double customWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        const Positioned(
            child: SizedBox(
          height: 225,
        )),
        Positioned(
          child: Container(
            height: 140,
            width: customWidth * 0.9,
            margin: EdgeInsets.fromLTRB(
                customWidth * 0.05, 24, customWidth * 0.05, 0),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: Theme.of(context).textTheme.displayMedium,
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
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              Text(
                                'National Identity Number',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                          IconButton(
                            splashRadius: 25,
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
        Positioned(
          left: customWidth * 0.725,
          top: 130,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .push(PageRouteBuilder(pageBuilder: (context, animation, _) {
                return const QrScanScreen();
              }));
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 5,
                    strokeAlign: BorderSide.strokeAlignOutside),
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
