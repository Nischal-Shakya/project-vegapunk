import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

import '../url.dart';

import './data_transfer_permission_screen.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  static const routeName = '/qr_scan_screen';
  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  bool isShareScanScreen = true;

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double customHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      extendBodyBehindAppBar: true,
      body: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 600),
        builder: (context, value, child) {
          return ShaderMask(
            shaderCallback: ((bounds) {
              return RadialGradient(
                radius: value * 5,
                colors: const [
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                  Colors.transparent
                ],
                stops: const [0, 0.55, 0.6, 1],
                center: const FractionalOffset(0.4, 0.95),
              ).createShader(bounds);
            }),
            child: child,
          );
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            _buildQrView(context),
            Padding(
              padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height * 1.5,
                  left: 20.0,
                  right: 20.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Share'),
                    Tab(text: 'View'),
                  ],
                  onTap: (value) {
                    if (_tabController!.index == 0) {
                      setState(() {
                        isShareScanScreen = true;
                      });
                    } else {
                      setState(() {
                        isShareScanScreen = false;
                      });
                    }
                  },
                ),
              ),
            ),
            Positioned(
              top: customHeight / 5,
              child: Text(
                'Scan to ${isShareScanScreen ? 'share your ID details' : 'view shared ID details'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: customHeight / 4,
              child: const Text(
                "Please align the QR within the frame",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 240.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).colorScheme.primary,
        borderRadius: 5,
        borderLength: 20,
        borderWidth: 5,
        cutOutSize: scanArea,
        overlayColor: Colors.black.withOpacity(0.8),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    this.controller = controller;
    // controller.scannedDataStream.listen(
    //   (scanData) async {
    //     controller.pauseCamera();
    //     const snackBar = SnackBar(
    //       content: Text('Invalid Qr Code'),
    //       duration: Duration(seconds: 2),
    //     );
    // try {
    //   String requestId = scanData.code.toString();

    //   if (requestId.isNotEmpty) {
    //     var response = await http.get(Uri.parse('$getDataQrUrl/$requestId/'));
    //     Map decodedData = json.decode(response.body);
    //     if (decodedData.containsKey('request_id') &&
    //         decodedData['request_id'].toString().isNotEmpty &&
    //         decodedData.containsKey('requested_fields') &&
    //         // decodedData['reuested_fields'] is List &&
    //         decodedData['requested_fields'].length > 0 &&
    //         decodedData.containsKey('requester') &&
    //         decodedData['requester'].toString().isNotEmpty) {
    //       // ignore: use_build_context_synchronously
    //       Navigator.pushNamed(context, DataPermissionScreen.routeName,
    //           arguments: decodedData);
    //     } else {
    //       // ignore: use_build_context_synchronously
    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //         content: Text('Invalid'),
    //         duration: Duration(seconds: 2),
    //       ));
    //       controller.resumeCamera();
    //     }
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //     controller.resumeCamera();
    //   }
    // } catch (error) {
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   controller.resumeCamera();
    // }
    // },
    // );
  }
}
