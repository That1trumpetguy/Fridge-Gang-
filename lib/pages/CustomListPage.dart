import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';

import '../style.dart';

class CustomListPage extends StatefulWidget {

  const CustomListPage({Key? key}) : super(key: key);

  @override
  State<CustomListPage> createState() => _CustomListPageState();
}

class _CustomListPageState extends State<CustomListPage> {
  //For radio buttons.
  String group = '';

  //Keeps track of what's happening in the text field.
  final _textController = TextEditingController();

  //User text input for custom list name;
  String listName = '';

  //input for list type.
  String listType = '';

  void checkRadio(String value) {
    setState(() {
      group = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0, left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Create a New Custom List", style: TextStyle(
                  fontSize: 32,
                ),
                ),
              ),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  hintText: "Enter the list name",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0, left: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                  child: Text("List Type: ", style: TextStyle(fontSize: 24),)),
            ),
            RadioListTile(
              title: Text('Grocery List'),
              value: "Grocery List",
              groupValue: group,
              onChanged: (value) {
                checkRadio(value as String);
              },
            ),
            RadioListTile(
              title: Text('Pantry List'),
              value: "Pantry List",
              groupValue: group,
              onChanged: (value) {
                checkRadio(value as String);
              },
            ),
            RadioListTile(
              title: Text('Fridge List'),
              value: "Fridge List",
              groupValue: group,
              onChanged: (value) {
                checkRadio(value as String);
              },
            ),
            RadioListTile(
              title: Text('Freezer List'),
              value: "Freezer List",
              groupValue: group,
              onChanged: (value) {
                checkRadio(value as String);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: OutlinedButton(

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
                        textAlign: TextAlign.left,
                        style: AppStyle.txtRobotoBold20,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Center(
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
                          listName = _textController.text;
                          print(listName);
                          listType = group;

                          ListItemHelper.addNewList('me', listName, listType);

                          Navigator.of(context).pop();



                        },
                        child: Text(
                          "Submit",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtRobotoBold20,
                        )),
                  ),
                )
              ],
            )
          ]
      ),
    );
  }
}
