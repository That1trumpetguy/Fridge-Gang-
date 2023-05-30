import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/BarScanner.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:http/http.dart' as http;
import 'package:openfoodfacts/openfoodfacts.dart';

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
  var screenImage = Image.network(
      'https://icons.veryicon.com/png/o/miscellaneous/project-management-tools/select-not-selected.png',
      fit: BoxFit.cover);

  var redrawObject = Object();

  FutureOr<List<String>> getSuggestions(String input) async {
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/auto-complete?app_id=07ca8641&app_key=f239759c5a8f2b695c852f20ea31f966&q=$input&limit=10'));

    if (response.statusCode == 200) {
      List<dynamic> foods = json.decode(response.body);
      final List<String> finalFoods = foods.map((e) => e.toString()).toList();
      return finalFoods;
    } else {
      return [];
    }
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController fieldTextEditingController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return Container(
            width: double.infinity,
            height: 40,
            color: Colors.white,
            child: TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              decoration: InputDecoration(
                  hintText: 'Insert name of food',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: fieldTextEditingController.clear,
                  ) //(Icons.clear)
                  ),
            ));
      },

      onSelected: (String selection) {
        String selectedFood = selection;
        debugPrint('You just selected $selection');
      },

      optionsBuilder: (TextEditingValue textEditingValue) {
        String input = textEditingValue.text;
        if (input == '') {
          return const Iterable<String>.empty();
        }
        return getSuggestions(input);
      }
    );
  }
*/

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
      floatingActionButton: Container(
        height: 75.0,
        width: 75.0,
        child: FittedBox(
          child: FloatingActionButton(
              child: new Icon(Icons.camera_alt),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BarScanner(),
                ));
              }),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Autocomplete<String>(fieldViewBuilder: (
              BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(),
                    child: TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Insert name of food',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: fieldTextEditingController.clear,
                          ) //(Icons.clear)
                          ),
                    ),
                  ));
            }, onSelected: (String selection) async {
              itemName = selection;
              final foods = await http.get(Uri.parse(
                  "https://api.edamam.com/api/food-database/v2/parser?app_id=07ca8641&app_key=f239759c5a8f2b695c852f20ea31f966&ingr=$itemName&nutrition-type=cooking"));
              if (foods.statusCode == 200) {
                Map data = json.decode(foods.body);
                final foodItem = data["parsed"][0]["food"];
                screenImage = Image.network(foodItem["image"]);
                setState(() {});
              }
              debugPrint('You just selected $selection');
            }, optionsBuilder: (TextEditingValue textEditingValue) {
              String input = textEditingValue.text;
              itemName = textEditingValue.text;
              if (input == '') {
                return const Iterable<String>.empty();
              }
              return getSuggestions(input);
            }),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.008),
                      child: Center(
                        child: GestureDetector(
                          child: screenImage,
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            print(screenImage);
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
            ),
            MaterialButton(
              onPressed: () async {
                //Asynchronous button press to query database with given code
                //Grab current text controller state.

                final foods = await http.get(Uri.parse(
                    "https://api.edamam.com/api/food-database/v2/parser?app_id=07ca8641&app_key=f239759c5a8f2b695c852f20ea31f966&ingr=$itemName&nutrition-type=cooking"));

                if (foods.statusCode == 200) {
                  Map data = json.decode(foods.body);
                  final foodItem = data["parsed"][0]["food"];
                  ListItemHelper.addItem("Grocery List", foodItem["label"],
                      foodItem["category"], foodItem["image"], File(''), "NA");
                }

                //Wait for database to return result.
                Product? res = await getProduct(itemName);

                //Reset the current state with item name and picture.
                sleep(Duration(seconds: 1));
                setState(() {
                  result = res;
                });
              },
              color: Colors.blue,
              child: const Text(
                'Add to Grocery List',
                style: TextStyle(fontSize: 20),
              ),
            )

            /*

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

            */
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
              String expirationDateString =
                  expirationDate.toString().split(' ')[0];
              //formatting to get rid of 24hour clock

              ListItem newItem = ListItem(
                  itemName: prod?.productName ?? '',
                  imageName: prod?.imageFrontSmallUrl ?? '',
                  expirationDate: expirationDateString);
              ListItemHelper.addItem(
                  'Grocery List',
                  prod?.productName ?? '',
                  prod?.categories ?? '',
                  prod?.imageFrontSmallUrl ?? '',
                  File(''),
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
