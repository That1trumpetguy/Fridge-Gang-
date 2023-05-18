import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchMe(barcode: BarScanN)));
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
    var screenSize = MediaQuery.of(context).size;
    var largeScreen = screenSize.width > 480 ? true : false;

    final ButtonStyle style =
        ElevatedButton.styleFrom(backgroundColor: ColorConstant.teal300);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text('Barcode Scan Util',
                  style: TextStyle(
                    fontSize: (largeScreen ? 30 : 30),
                  )),
              toolbarHeight: 100,
              backgroundColor: ColorConstant.teal300,
            ),
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
                          style: ElevatedButton.styleFrom(
                            textStyle:
                                TextStyle(fontSize: (largeScreen ? 30 : 20)),
                          ),
                        ),
                        Text('Scan Result: $CodeScan\n',
                            style:
                                TextStyle(fontSize: (largeScreen ? 40 : 30))),
                      ]));
            })));
  }
}

class SearchMe extends SearchBarPopUpPage {
  final String barcode;

  SearchMe({required this.barcode});

  Future<Product?> getProduct(String barcode) async {
    //var barcode = '0048151623426';
    print('THIS IS THE BARCODE:');
    print(barcode);
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

  //Alert dialog for adding an item to a grocery list.
  showAlertDialog(BuildContext context, Product prod) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Please confirm"),
      content:
          const Text("Would you like to add this item to your grocery list?"),
      actions: [
        // The "Yes" button
        TextButton(
            onPressed: () {
              //Todo: add item to list.
              //Create new List item object.
              ListItem newItem = ListItem(
                  itemName: prod?.productName ?? '',
                  imageName: prod?.imageFrontSmallUrl ?? '',
                  expirationDate: '5/13/2023');
              ListItemHelper.addItem(
                  'me',
                  'Grocery List',
                  prod?.productName ?? '',
                  prod?.genericName ?? '',
                  prod?.imageFrontSmallUrl ?? '',
                  '5/14/2023');
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Yes')),
        TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: const Text('No'))
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
