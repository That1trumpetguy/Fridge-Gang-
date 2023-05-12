  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
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

  //Search bar popup to search for food items by name using autocomplete.
    //Todo: add more error handling!!!
    //Todo: add photo.
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container(
                child: Center(
                  child: Text(
                      result?.productName ?? '', //View will be updated based on query result.
                      style: const TextStyle(
                    fontSize: 25,
                  )),
                ),
              ),),
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
              MaterialButton(onPressed: () async { //Asynchronous button press to query database with given code
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
                child: const Text('search', style: TextStyle(fontSize: 20),),
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

      if (result.status == ProductResultV3.statusSuccess && result.product !=null) {
        return result.product;
      } else {
        throw Exception('product not found, please insert data for $barcode');
      }
    }
  }


