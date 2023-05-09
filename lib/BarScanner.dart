import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarScanner extends StatefulWidget {
  const BarScanner({Key? key}) : super(key: key);

  @override
  State<BarScanner> createState() => _BarScannerState();
}

class _BarScannerState extends State<BarScanner> {
  String CodeScan = 'None';
  @override
  void initState() {
    super.initState();
  }

  Future<void> startStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'failed to get platform version';
    }
    if (!mounted) return;

    setState(() {
      CodeScan = barcodeScanRes;
    });
  }

  Future<void> ScanNormal() async {
    String BarScanN;
    try {
      BarScanN = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(BarScanN);
    } on PlatformException {
      BarScanN = 'Failed to get platform version';
    }

    if (!mounted) return;

    setState(() {
      CodeScan = BarScanN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode Scan Util')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => ScanNormal(),
                            child: Text('Start Barcode Scan')),
                        ElevatedButton(
                            onPressed: () => startStream(),
                            child: Text('Start Barcode Stream')),
                        Text('Scan Result: $CodeScan\n',
                            style: TextStyle(fontSize: 20))
                      ]));
            })));
  }
}
