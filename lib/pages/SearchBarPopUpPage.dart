import 'dart:async';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';

class SearchBarPopUpPage extends StatefulWidget {
  const SearchBarPopUpPage({Key? key}) : super(key: key);

  @override
  State<SearchBarPopUpPage> createState() => _SearchBarPopUpPageState();
}

class _SearchBarPopUpPageState extends State<SearchBarPopUpPage> {
  //Keeps track of what's happening in the text field.
  final _textController = TextEditingController();
  Product? result;
  //UserInput
  String itemName = '';

  //Search bar popup to search for food items by name using autocomplete.
  //Todo: add more error handling!!!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Center(
                      child: GestureDetector(
                        child: Image.network(
                          result?.imageFrontSmallUrl ??
                              'assets/page-1/images/image-1.png',
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          showAlertDialog(context, result!);
                          _textController.clear();
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                        result?.productName ??
                            '', //View will be updated based on query result.
                        style: const TextStyle(
                          fontSize: 25,
                        )),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search for an Item',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _textController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  )),
            ),
            MaterialButton(
              onPressed: () async {
                //Asynchronous button press to query database with given code
                //Grab current text controller state.
                itemName = _textController.text;

                //Wait for database to return result.
                Product? res = await getProduct(itemName);

                //Reset the current state with item name and picture.
                setState(() {
                  result = res;
                });
              },
              color: Colors.blue,
              child: const Text(
                'search',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Product?> getProduct(String barcode) async {
    //var barcode = '0048151623426';

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
              DateTime expirationDate = DateTime.now().add(Duration(days: 7));
              String expirationDateString = expirationDate.toString();
              ListItem newItem = ListItem(
                  itemName: prod?.productName ?? '',
                  imageName: prod?.imageFrontSmallUrl ?? '',
                  expirationDate: expirationDateString
              );
              ListItemHelper.addItem(
                  'me',
                  'Freezer List',
                  prod?.productName ?? '',
                  prod?.categories ?? '',
                  prod?.imageFrontSmallUrl ?? '',
                  expirationDateString);
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
