import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/pages/ProdPage.dart';
import 'package:flutter_app/pages/ManEnter.dart';

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

class SearchMe {
  final String barcode;

  String currentList = "Fridge List";

  SearchMe({required this.barcode});

  Future<void> updateCurrentList() async {
    currentList = await ListItemHelper.getLastViewed();
  }

  Future<Product?> getProduct(String barcode) async {
    updateCurrentList();
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
      //throw Exception('product not found, please insert data for $barcode');
      return null;
    }
  }

  void navigateToProductDetails(BuildContext context, Product? product) {
    
    if (product != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProdPage(
            product: product,
            onAddToList: (ListItem newItem) {
              // Call the method to add the item to the list
              ListItemHelper.addItem(
                currentList,
                newItem.itemName,
                '', //newItem.categories, somehow there is an error here, it does not want to accept foodType or categories
                newItem.imageName,
                File(''),
                newItem.expirationDate,
              );
              // You can show a confirmation message or take any other action
            },
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManEnter(),
        ),
      );
    }
  }
}
