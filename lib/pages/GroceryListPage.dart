import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/widget/ListCard.dart';

import '../helpers/ListItemHelper.dart';
import '../models/ListItem.dart';


class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {

  //Fetches the list of grocery Items.
  List<ListItem> items = ListItemHelper.getGroceryListItems();

  @override
  Widget build(BuildContext context) {
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
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
              child: Text('Grocery List',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 36
              ),),
            ),
            Expanded(child: ListView.builder( //Iterates through each item in the grocery list.
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index){
                  return ListCard(item: items[index]); //Returns a card wi
                },
            ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            child: new Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute (
                  builder: (BuildContext context) => SearchBarPopUpPage(),
                ),
              );
            },),
        ),
      ),

    );
  }
}


