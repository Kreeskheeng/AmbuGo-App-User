import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratedQR extends StatefulWidget {
  final myQR;

  const GeneratedQR(this.myQR);

  @override
  _GeneratedQRState createState() => _GeneratedQRState();
}

class _GeneratedQRState extends State<GeneratedQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generated QR "),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: QrImageView(
          data: widget.myQR,
          version: QrVersions.auto,
        ),
      ),
    );
  }
}
