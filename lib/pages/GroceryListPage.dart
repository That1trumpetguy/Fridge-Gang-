import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/widget/ListCard.dart';
import '../models/ListItem.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  List<ListItem> groceryList = [];

  Future<int> something() async {
    groceryList = await ListItemHelper.getItems('me', 'Grocery List');
    print(groceryList);
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
                'Grocery List',
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
                    if (!snapshot.hasData) {
                      print("here");
                      return Center(child: CircularProgressIndicator());
                    } else {
                      print("there");
                      return ListView.builder(
                        itemCount: groceryList
                            .length, //Todo: add grocery list size here.
                        itemBuilder: (BuildContext context, int index) {
                          return ListCard(item: groceryList[index]);
                        },
                      );
                    }
                  }),
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SearchBarPopUpPage(),
                ));
              }),
        ),
      ),
    );
  }
}
