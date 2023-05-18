import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/widget/ExpiryListCard.dart';
import 'package:flutter_app/widget/ListCard.dart';
import '../models/ListItem.dart';

class AboutToExpireList extends StatefulWidget {
  const AboutToExpireList({Key? key}) : super(key: key);

  @override
  State<AboutToExpireList> createState() => _AboutToExpireListState();
}

class _AboutToExpireListState extends State<AboutToExpireList> {

  List<ListItem> expiryList = [];

  Future<int> something() async {
    expiryList = await ListItemHelper.getItems('me', 'Expiration');
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
                    if (!snapshot.hasData) {
                      print("here");
                      return Center(child: CircularProgressIndicator());
                    } else {
                      print("there");
                      return ListView.builder(
                        itemCount: expiryList.length, //Todo: add grocery list size here.
                        itemBuilder: (BuildContext context, int index){
                          return ExpiryListCard(item: expiryList[index]);
                        },
                      );
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
Future<List<DateTime>> getExpiryDate(String username, String listName) async {
  final list = await ListItemHelper.getList(username, listName);
  final expirationDates = <DateTime>[];
  print(list);
  for (final item in list) {
    final expirationDate = await fetchExpirationDate(item.name);
    expirationDates.add(expirationDate);
  }

  print(expirationDates);

  return expirationDates;
}

Future<DateTime> fetchExpirationDate(String itemName) async {
  final apiUrl = 'https://world.openfoodfacts.org/api/v0/product/$itemName.json';
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final expirationDateString = jsonData['product']['expiration_date'];
    final expirationDate = DateTime.tryParse(expirationDateString);

    if (expirationDate != null) {
      return expirationDate;
    }
  }

  // Return a default value if the expiration date cannot be fetched
  return DateTime.now().add(Duration(days: 7));
}
void main() {
   getExpiryDate('me', 'Fridge');

}