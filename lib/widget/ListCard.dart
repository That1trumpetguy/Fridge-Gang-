import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../helpers/ListItemHelper.dart';
import '../models/ListItem.dart';
import '../models/ListType.dart';
import '../style.dart';

class ListCard extends StatefulWidget {
  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 15),
    maxNrOfCacheObjects: 100,
  ));

  //Constructor
  ListCard({
    Key? key,
    required this.item,
    required this.index,
    required this.foodList,
    required this.callback,
    required this.listName,
  }) : super(key: key);

  //Reference for the current list item.
  final ListItem item;
  final Function callback;
  final String listName;
  final int index;
  final List<ListItem> foodList;

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  String? errorMessage;
  int counter = 1;

  List<ListType> _listNames = [];
  List<ListItem> WhatIHaveList = [];
  String? value;
  String? selection;
  final String defaultList = 'Grocery List';

  Future<String> downloadImage(String imageUrl) async {
    var cacheManager = DefaultCacheManager();
    //Uri URL = Uri.parse(imageUrl);
    FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);
    File file = await cacheManager.getSingleFile(imageUrl);
    if (fileInfo != null && fileInfo.file != null) {
      return fileInfo.file.path;
    } else {
      return '';
    }
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
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              //Do action here //todo: add action to add to list.
              openDialog(widget.index, widget.listName);
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
              ListItemHelper.deleteItem(
                  widget.listName, widget.foodList[widget.index].itemName);

              widget.foodList.removeAt(widget.index);

              widget.callback(widget.foodList);

              //Do action here //todo: add action to remove from list.
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
                    border: Border.all(color: Colors.grey)),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.asset(item.imageName),
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.150),
                  child: CachedNetworkImage(
                    cacheManager: ListCard.customCacheManager,
                    height: screenHeight * .130,
                    width: screenWidth * .130,
                    key: UniqueKey(),
                    imageUrl: widget.item.imageName,
                    placeholder: (context, url) => Container(
                      color: Colors.black12,
                    ),
                    errorWidget: (context, url, error) => Container(
                      child: Icon(Icons.error,
                          color: Colors.red, size: screenHeight * 0.080),
                    ),
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: BorderRadius.circular(screenWidth * 0.150),
                      child: Image(image: imageProvider),
                    ),
                  ),
                ),

                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.item.itemName,
                        style: TextStyle(fontSize: screenWidth * 0.03),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Expiration Date: ${widget.item.expirationDate}',
                        style: TextStyle(fontSize: screenWidth * 0.03),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter new expiration date',
                          errorText: errorMessage,
                        ),
                        onChanged: (value) async {
                          setState(() {
                            widget.item.expirationDate = value;
                            errorMessage = !dateRegex.hasMatch(value)
                                ? 'Please Enter yyyy-mm-dd.'
                                : null;
                          });
                          await ListItemHelper.updateExpiry(
                              /*'Grocery List'*/ ListItemHelper.currentList
                                  .toString(),
                              widget.item.itemName,
                              value);
                          print(ListItemHelper.currentList.toString());
                          print(widget.item.itemName);
                        },
                      )
                      /*
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                                "Quantity:",
                                style: TextStyle(fontSize: screenWidth * 0.03),
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
                                  style: TextStyle(fontSize: screenWidth * 0.03),
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
                        ),
                        */
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> openDialog(int index, String listName) async {
    String imagePath = await downloadImage(widget.foodList[index].imageName);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, StateSetter setThisState) => ButtonBarTheme(
          data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
          child: AlertDialog(
              insetPadding: EdgeInsets.all(10),
              title: (const Text(
                  "Select a list you would like to transfer the item to: ")),
              content: SizedBox(
                height: MediaQuery.of(context).size.width * 0.20,
                width: MediaQuery.of(context).size.width * 0.01,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ))),
                      onPressed: () {
                        selection = value!;

                        ListItemHelper.addItem(
                          selection!,
                          widget.foodList[index].itemName,
                          '',
                          imagePath,
                          //argument here for file
                          File(''),
                          //argument for expiration date
                          widget.foodList[index].expirationDate,
                        );
                        ListItemHelper.deleteItem(
                            widget.listName, widget.foodList[index].itemName);
                        widget.foodList.removeAt(index);
                        widget.callback(widget.foodList);

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
}
