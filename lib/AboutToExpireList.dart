import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/widget/ExpiryListCard.dart';
import 'package:flutter_app/widget/ListCard.dart';
import '../models/ListItem.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'models/ListType.dart';

class AboutToExpireList extends StatefulWidget {
  const AboutToExpireList({Key? key}) : super(key: key);

  @override
  State<AboutToExpireList> createState() => _AboutToExpireListState();
}

class _AboutToExpireListState extends State<AboutToExpireList> {

  List<ListItem> expiryList = [];

  Future<int> something() async {
    expiryList = await ListItemHelper.addToExpirationList();
    print(expiryList);
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(),
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:  [
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * .015,
                  top: screenHeight * .015,
                  bottom: screenHeight * .010),
              child: Text('About to Expire!',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: screenHeight * 0.05
                ),),
            ),
            SizedBox(
              height: screenHeight * 0.65,
              width: screenWidth * 0.8,
              child: FutureBuilder(
                  future: something(),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasError) {
                      //return Center(child: Text('Error: $snapshot.error}'));
                      return Center(child: Text('PLEASE ENSURE ALL DATES ACROSS LISTS ARE FORMATTED CORRECTLY:\n YYYY-MM-DD\n',
                      style: TextStyle(fontSize: 24)));
                    }
                    else if (!snapshot.hasData) {
                      print("here");
                      return Center(child: CircularProgressIndicator());
                      //here
                    }
                    else {
                      print("there");
                      if(expiryList.isEmpty){
                        return Center(child: Text('No items found'));
                      }else {
                        print("there again");
                        return ListView.builder(
                          itemCount: expiryList.length,
                          //Todo: add grocery list size here.
                          itemBuilder: (BuildContext context, int index) {
                            return ExpiryListCard(item: expiryList[index]);
                          },
                        );
                      }
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
/*Future<List<String>> get_product_codes(String product_name) async {
  final base_url = 'https://world.openfoodfacts.org/cgi/search.pl';
  final params = {
    'search_terms': product_name,
    'search_simple': '1',
    'json': '1',
  };

  final uri = Uri.parse(base_url).replace(queryParameters: params);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    final product_codes = <String>[];
    if (data['products'] != null) {
      for (final product in data['products']) {
        if (product.containsKey('code')) {
          product_codes.add(product['code']);
        }
      }
    }
    //print(product_codes);
    return product_codes;
  } else {
    throw Exception('Request failed with status code ${response.statusCode}');
  }
}

Future<List<DateTime>> getExpiryDate(String username, String listName) async {
  final apiUrl = 'https://world.openfoodfacts.org/api/v0/product/';
  final expirationDates = <DateTime>[];
  final list = ['organic eggs', 'organic valley whole milk', 'swiss cheese', 'rotisserie chicken'];

  print(list);
  for (final item in list) {
    final productCodes = await get_product_codes(item);
    print(productCodes);
    if (productCodes.isNotEmpty) {
      final code = productCodes.first;
      final response = await http.get(Uri.parse('$apiUrl$code.json'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);

        final productData = jsonResponse['product'];
        if (productData != null && productData['expiration_date'] != null) {
          final expirationDateString = productData['expiration_date'];
          final expirationDate = DateTime.tryParse(expirationDateString);

          if (expirationDate != null) {
            expirationDates.add(expirationDate);
          }
        } else {
          print('Error: Invalid JSON structure or missing "expiration_date" property');
          // Handle the case when the JSON structure is invalid or missing required property
          // You can add error handling or provide a default expiration date
          expirationDates.add(DateTime.now().add(Duration(days: 7)));
        }
      } else {
        print('Error: Request failed with status code ${response.statusCode}');
        // Handle the case when the request fails
        // You can add error handling or provide a default expiration date
        expirationDates.add(DateTime.now().add(Duration(days: 7)));
      }
    } else {
      print('Error: Product code not found for $item');
      // Handle the case when the product code is not found
      // You can add error handling or provide a default expiration date
      expirationDates.add(DateTime.now().add(Duration(days: 7)));
    }
  }

  print(expirationDates);

  return expirationDates;
}*/



/*void main() async {
  final expiryDates = await getExpiryDate('me', 'Fridge List');
  print(expiryDates);
}*/