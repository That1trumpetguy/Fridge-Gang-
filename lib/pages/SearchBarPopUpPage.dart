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
  
  String currentList = "Grocery List";
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

  Future<void> updateCurrentList() async {
    currentList = await ListItemHelper.getLastViewed();
  }

  //Search bar popup to search for food items by name using autocomplete.
  //Todo: add more error handling!!!

  @override
  Widget build(BuildContext context) {
    updateCurrentList();
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
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.008),
                      child: Center(
                        child: GestureDetector(
                          child: screenImage,
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            print(screenImage);
                            //showAlertDialog(context, result!);
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
                  DateTime expirationDate =
                      DateTime.now().add(Duration(days: 7));
                  String expirationDateString =
                      expirationDate.toString().split(' ')[0];

                  Map data = json.decode(foods.body);
                  
                  final foodItem = data["parsed"][0]["food"];
                  ListItemHelper.addItem(
                      currentList,
                      foodItem["label"],
                      foodItem["category"],
                      foodItem["image"],
                      File(''),
                      expirationDateString);
                }

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Item Added"),
                      content: Text("The item has been added to the specified list."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },

                          child: Text("OK"),

                        ),
                      ],
                    );
                  },
                );
                //Wait for database to return result.
                //Product? res = await getProduct(itemName);

                //Reset the current state with item name and picture.
                //sleep(Duration(seconds: 1));
                //setState(() {
                //  result = res;
                //});
              },
              color: Colors.blue,
              child: Text(
                "Add to List",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
