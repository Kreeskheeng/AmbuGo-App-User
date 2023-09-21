import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyCustomWidget extends StatefulWidget {

  @override
  State<MyCustomWidget> createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  String getResult = 'QR Code Result';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                scanQRCode();
              },
              child: Text('Scan QR'),
            ),
            SizedBox(height: 20.0),
            Text(getResult),
          ],
        ),
      ),
    );
  }

  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (qrCode == '-1') {
        // User canceled the scan.
        setState(() {
          getResult = 'Scan canceled.';
        });
      } else if (qrCode.isNotEmpty) {
        // QR code was successfully scanned.
        setState(() {
          getResult = qrCode;
        });
        print("QRCode_Result: $qrCode");
      } else {
        // QR code scan failed.
        setState(() {
          getResult = 'Failed to scan QR Code.';
        });
      }
    } on PlatformException {
      setState(() {
        getResult = 'Failed to scan QR Code.';
      });
    }
  }
}
