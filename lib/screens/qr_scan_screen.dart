import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/age_verification_screen.dart';
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import './data_transfer_permission_screen.dart';
import '../providers/internet_connectivity.dart';

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
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();

  // TabController? _tabController;

  // @override
  // void initState() {
  //   _tabController = TabController(vsync: this, length: 2);
  //   super.initState();
  // }

  @override
  void didChangeDependencies() async {
    await connectionStatus.checkConnection();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _tabController!.dispose();
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
        duration: const Duration(milliseconds: 600),
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
            Positioned(
              top: customHeight / 5,
              child: const Text(
                'Scan to share your  details',
                style: TextStyle(
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
    const snackBar = SnackBar(
      content: Text('Invalid Qr Code'),
      duration: Duration(seconds: 2),
    );

    controller.scannedDataStream.listen(
      (scanData) async {
        controller.pauseCamera();
        if (connectionStatus.hasConnection) {
          // try {
          String requestId = scanData.code.toString();
          // log(requestId);
          // if (requestId.isNotEmpty) {
          // var response =
          //     await http.get(Uri.parse('$getDataQrUrl/$requestId/'));
          // Map decodedData = json.decode(response.body);
          Map decodedData = json.decode(requestId);

          if (decodedData.containsKey('request_id') &&
              decodedData['request_id'].toString().isNotEmpty &&
              decodedData.containsKey('requested_fields') &&
              decodedData['requested_fields'].length > 0 &&
              decodedData.containsKey('requester') &&
              decodedData['requester'].toString().isNotEmpty) {
            Navigator.pushReplacementNamed(
                context, DataPermissionScreen.routeName,
                arguments: decodedData);
          } else if (decodedData.containsKey('permit_id')) {
            log(decodedData['permit_id'].toString());
            Navigator.pushReplacementNamed(
                context, AgeVerificationScreen.routeName);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Invalid data'),
              duration: Duration(seconds: 2),
            ));
            controller.resumeCamera();
          }
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //   controller.resumeCamera();
          // }
          // } catch (error) {
          //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //   controller.resumeCamera();
          // }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No Internet Access'),
            duration: Duration(seconds: 2),
          ));
          controller.resumeCamera();
        }
      },
    );
  }
}
