import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/widget/ListCard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/BarScanner.dart';
import '../models/ListItem.dart';
import '../models/ListType.dart';
import '../style.dart';
import 'dart:io';

class ListPage extends StatefulWidget {
  const ListPage(this.listName, {Key? key}) : super(key: key);

  final String listName;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<ListItem> groceryList = [];
  List<ListType> _listNames = [];
  List<ListItem> WhatIHaveList = [];
  final String defaultList = 'Grocery List';

  String? value;
  String? selection;

  Future<int> something() async {
    groceryList = await ListItemHelper.getItems('Grocery List');
    print(groceryList);
    return 1;
  }

  Future<int> getMyLists(String userName) async {
    _listNames = await ListItemHelper.fetchListNames();

    if (kDebugMode) {
      print(_listNames);
    }
    return 1;
  }

  Future<int> whatIHaveListItem(String listName) async {
    WhatIHaveList = await ListItemHelper.getItems(listName);

    if (kDebugMode) {
      print(WhatIHaveList);
    }
    return 1;
  }

  //To set the state.
  callback(varWhatIHaveList) {
    setState(() {
      WhatIHaveList = varWhatIHaveList;
    });
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
                widget.listName,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: screenHeight * 0.05),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: whatIHaveListItem(widget.listName),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: $snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      print("here");
                      return Center(child: CircularProgressIndicator());
                      //here
                    } else {
                      print("there");
                      return ListView.builder(
                        itemCount: WhatIHaveList.length,
                        //Todo: add grocery list size here.
                        itemBuilder: (BuildContext context, int index) {
                          if (WhatIHaveList[index].itemName != ' ') {
                            return ListCard(
                                item: WhatIHaveList[index],
                                listName: widget.listName,
                                index: index,
                                foodList: WhatIHaveList,
                                callback: callback);
                          }
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
                ListItemHelper.setLastViewed(widget.listName);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SearchBarPopUpPage(),
                ));
              }),
        ),
      ),
    );
  }

  Future openDialog(int index) => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter setThisState) => ButtonBarTheme(
            data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
            child: AlertDialog(
              insetPadding: EdgeInsets.all(10),
              title: Text(
                  "Select a list you would like to transfer the item to: "),
              content: SizedBox(
                height: MediaQuery.of(context).size.width * 0.20,
                width: MediaQuery.of(context).size.width * 0.01,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: FutureBuilder(
                          future: getMyLists('me'),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return DropdownButton<String>(
                                // Dropdown menu.
                                value: value,
                                hint: Text(
                                  "Please select a List",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                items: _listNames.map((ListType value) {
                                  return DropdownMenuItem<String>(
                                    value: value.listName,
                                    child: Text(
                                      value.listName,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setThisState(() {
                                    this.value = value;
                                    whatIHaveListItem(
                                        //'me',
                                        this.value ?? defaultList);
                                  });
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      ColorConstant.red300,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.txtRobotoBold20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        ColorConstant.teal300,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      selection = value!;

                      ListItemHelper.addItem(
                        selection!,
                        groceryList[index].itemName,
                        '',
                        '',
                        File(''),
                        '',
                      );
                      ListItemHelper.deleteItem(
                        widget.listName,
                        groceryList[index].itemName,
                      );
                      setState(() {
                        groceryList.removeAt(index);
                      });
                      selection = null;
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Confirm",
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.txtRobotoBold20,
                    ),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      );
}
