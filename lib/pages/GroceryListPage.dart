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

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
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

  Future<int> getMyLists() async {
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
            Expanded(
              child: FutureBuilder(
                  future: something(),
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
                        itemCount: groceryList.length,
                        //Todo: add grocery list size here.
                        itemBuilder: (BuildContext context, int index) {
                          //return ListCard(item: groceryList[index]);
                          //return ListCard(item: groceryList[index]);
                          return Slidable(
                            startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    //Do action here //todo: add action to add to list.
                                    openDialog(index);

                                    selection = '';
                                    //ListItemHelper.swapAndDeleteItem('me', groceryList[index].itemName);
                                  },
                                  //borderRadius: BorderRadius.circular(20),
                                  backgroundColor: Colors.blue,
                                  //padding: const EdgeInsets.all(20),
                                  icon: Icons.add,
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    //Do action here //todo: add action to remove from list.
                                    print(groceryList[index].itemName);
                                    ListItemHelper.deleteItem('Grocery List',
                                        groceryList[index].itemName);
                                    setState(() {
                                      groceryList.removeAt(index);
                                    });
                                  },
                                  //borderRadius: BorderRadius.circular(20),
                                  backgroundColor: Colors.red,
                                  //padding: const EdgeInsets.all(20),
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: Container(
                              //margin: EdgeInsets.all(20),
                              height: screenHeight * 0.16,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          //borderRadius: BorderRadius.circular(20),
                                          color: Color(0xffdbdfd1),
                                          border:
                                              Border.all(color: Colors.grey)),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Image.asset(item.imageName),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.150),
                                        child: CachedNetworkImage(
                                          cacheManager:
                                              ListCard.customCacheManager,
                                          height: screenHeight * .140,
                                          width: screenWidth * .140,
                                          key: UniqueKey(),
                                          imageUrl:
                                              groceryList[index].imageName,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.black12,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            child: Icon(Icons.error,
                                                color: Colors.red,
                                                size: screenHeight * 0.080),
                                          ),
                                        ),
                                      ),

                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              groceryList[index].itemName,
                                              style: TextStyle(
                                                  fontSize: screenWidth * 0.04),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.visible,
                                            ),
                                            SizedBox(height: 8),
                                            TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Expiration Date',
                                              ),
                                              /* controller: TextEditingController(
                                                  text: groceryList[index].expirationDate,
                                                ),*/
                                              onChanged: (value) async {
                                                setState(() {
                                                  groceryList[index]
                                                      .expirationDate = value;
                                                });
                                                await ListItemHelper
                                                    .updateExpiry(
                                                        'Grocery List',
                                                        groceryList[index]
                                                            .itemName,
                                                        value);
                                                print(groceryList[index]
                                                    .itemName);
                                                print(groceryList[index]
                                                    .expirationDate);
                                              },
                                              //
                                              /*onEditingComplete: () async {
                                                  String newExpirationDate = groceryList[index].expirationDate;
                                                  setState(() {
                                                    //String newExpirationDate = groceryList[index].expirationDate;
                                                    groceryList[index].expirationDate = newExpirationDate;
                                                  });
                                                  await ListItemHelper.updateExpiry('me', 'Grocery List', groceryList[index].itemName, /*groceryList[index].expirationDate*/newExpirationDate);
                                                  print(groceryList[index].itemName);
                                                  print(groceryList[index].expirationDate);
                                                  //print(newExpirationDate);
                                                },*/
                                            ),

                                            /*
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Quantity:",
                                                    style: TextStyle(fontSize: screenWidth * 0.04),
                                                    textAlign: TextAlign.left
                                                ),
                                                Row(
                                                  children: [
                                                    counter !=0 ? IconButton(
                                                      icon: Icon(
                                                        Icons.remove,
                                                        color: Theme.of(context).primaryColor,
                                                      ), onPressed: () {
                                                      setState(() {
                                                        counter--;
                                                      });
                                                    },
                                                    ): Padding(
                                                      padding: EdgeInsets.only(left: screenWidth * 0.15),
                                                      child: Container(),
                                                    ),
                                                    Text(
                                                      "$counter",
                                                      style: TextStyle(fontSize: screenWidth * 0.04),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Theme.of(context).primaryColor,
                                                      ), onPressed: () {
                                                      setState(() {
                                                        counter++;
                                                      });
                                                    },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                            */

                                            //), //onchanged
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
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
                //Navigator.of(context).push(MaterialPageRoute(             REMOVE THIS FOR THE SHOWCASE ON FRIDAY
                //builder: (BuildContext context) => BarScanner(),
                //));

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
                title: (Text(
                    "Select a list you would like to transfer the item to: ")),
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
                            future: getMyLists(),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (!snapshot.hasData) {
                                Center(child: CircularProgressIndicator());
                              } else {
                                return DropdownButton<String>(
                                  //Dropdown menu.
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
                                          this.value ?? defaultList);
                                    });
                                  },
                                );
                              }

                              return Container();
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
                              ColorConstant.red300),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.txtRobotoBold20,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorConstant.teal300),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ))),
                        onPressed: () {
                          selection = value!;

                          ListItemHelper.addItem(
                              selection!,
                              groceryList[index].itemName,
                              '',
                              groceryList[index].imageName,
                              groceryList[index].expirationDate);
                          ListItemHelper.deleteItem(
                              'Grocery List', groceryList[index].itemName);
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
                        )),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.center),
          ),
        ),
      );
}
