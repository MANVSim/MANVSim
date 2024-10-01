import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool _isBarcodeDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        onDetect: (barcode) {
          if (!_isBarcodeDetected && barcode.barcodes.isNotEmpty) {
            setState(() {
              _isBarcodeDetected = true;
            });
            final String? code = barcode.barcodes.first.rawValue;
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}
