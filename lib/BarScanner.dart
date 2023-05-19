import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/pages/ProdPage.dart';

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
      final searchMe = SearchMe(barcode: BarScanN);
      final product = await searchMe.getProduct(BarScanN);
      searchMe.navigateToProductDetails(context, product);
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
    final ButtonStyle style =
        ElevatedButton.styleFrom(backgroundColor: ColorConstant.teal300);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Barcode Scan Util'),
                backgroundColor: ColorConstant.teal300),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => ScanNormal(),
                            child: const Text('Start Barcode Scan'),
                            style: style),
                        Text('Scan Result: $CodeScan\n',
                            style: const TextStyle(fontSize: 20)),
                      ]));
            })));
  }
}

class SearchMe {
  final String barcode;

  SearchMe({required this.barcode});

  Future<Product?> getProduct(String barcode) async {
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.ENGLISH,
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result =
        await OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == ProductResultV3.statusSuccess &&
        result.product != null) {
      return result.product;
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }

  void navigateToProductDetails(BuildContext context, Product? product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdPage(
          product: product,
          onAddToList: (ListItem newItem) {
            // Call the method to add the item to the list
            ListItemHelper.addItem(
              'me',
              'Fridge List',
              newItem.itemName,
              '', //newItem.categories, somehow there is an error here, it does not want to accept foodType or categories
              newItem.imageName,
              newItem.expirationDate,
            );
            // You can show a confirmation message or take any other action
          },
        ),
      ),
    );
  }
}
