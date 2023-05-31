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
//import 'package:openfoodfacts/openfoodfacts.dart';

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
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * .015,
                  top: screenHeight * .015,
                  bottom: screenHeight * .010),
              child: Text(
                'About to Expire!',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: screenHeight * 0.05),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.65,
              width: screenWidth * 0.8,
              child: FutureBuilder(
                  future: something(),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasError) {
                      //return Center(child: Text('Error: $snapshot.error}'));
                      return Center(
                          child: Text(
                              'PLEASE ENSURE ALL DATES ACROSS LISTS ARE FORMATTED CORRECTLY:\n YYYY-MM-DD\n',
                              style: TextStyle(fontSize: 24)));
                    } else if (!snapshot.hasData) {
                      print("here");
                      return Center(child: CircularProgressIndicator());
                      //here
                    } else {
                      print("there");
                      if (expiryList.isEmpty) {
                        return Center(child: Text('No items found'));
                      } else {
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
                  }),
            )
          ],
        ),
      ),
    );
  }
}
