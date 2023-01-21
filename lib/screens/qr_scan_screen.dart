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

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: _buildQrView(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      // ignore: prefer_typing_uninitialized_variables
      const snackBar = SnackBar(
        content: Text('Invalid Qr Code'),
        duration: Duration(seconds: 2),
      );
      try {
        String requestId = scanData.code.toString();

        if (requestId.isNotEmpty) {
          var response =
              await http.get(Uri.parse('$url/api/v1/scan-request/$requestId/'));
          Map decodedData = json.decode(response.body);
          if (decodedData.containsKey('request_id') &&
              decodedData['request_id'].toString().isNotEmpty &&
              decodedData.containsKey('requested_fields') &&
              // decodedData['reuested_fields'] is List &&
              decodedData['requested_fields'].length > 0 &&
              decodedData.containsKey('requester') &&
              decodedData['requester'].toString().isNotEmpty) {
            Navigator.pushNamed(context, DataPermissionScreen.routeName,
                arguments: decodedData);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Invalid'),
              duration: Duration(seconds: 2),
            ));
            controller.resumeCamera();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          controller.resumeCamera();
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        controller.resumeCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
