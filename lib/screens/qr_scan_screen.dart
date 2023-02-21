import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/shared_screen.dart';
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:provider/provider.dart';

import './data_transfer_permission_screen.dart';
import '../providers/connectivity_change_notifier.dart';

import 'dart:developer';
import 'dart:io';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  static const routeName = '/qr_scan_screen';
  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  late bool connectionStatus;

  @override
  void didChangeDependencies() {
    connectionStatus =
        Provider.of<ConnectivityChangeNotifier>(context).connectivity();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double customHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
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
                // center: const FractionalOffset(0.4, 0.95),
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
              child: Text(
                'Scan to share your  details',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: customHeight / 4,
              child: Text(
                "Please align the QR within the frame",
                style: Theme.of(context).textTheme.displaySmall,
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
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p));
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
        if (connectionStatus) {
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
            Navigator.of(context, rootNavigator: true).pushReplacementNamed(
                DataPermissionScreen.routeName,
                arguments: decodedData);
          } else if (decodedData.containsKey('permit_id')) {
            Navigator.of(context, rootNavigator: true).pushReplacementNamed(
                SharedScreen.routeName,
                arguments: decodedData['permit_id']);
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
