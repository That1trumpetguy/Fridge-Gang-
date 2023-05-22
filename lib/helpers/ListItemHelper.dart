import 'package:flutter_app/models/ListItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../models/ListType.dart';

//Class to derive lists (grocery, fridge, custom) from the database.
class ListItemHelper {
  
  //Derives a list of grocery items from database. This is static for now....
  static Future<List<ListItem>> getGroceryListItems() async {

    var data = await Future.wait([getList("me", "Grocery List")]);
    List<ListItem> foodList = [];

    for(var i = 0; i < data[0].length; i++) {
      print(data[0][i]["image"]);
      ListItem temp = ListItem(itemName: data[0][i]["name"], imageName: data[0][i]["image"], expirationDate: "05/06/2023");
      foodList.add(temp);
    }

    return foodList;
  }

  //Derives a list of grocery items from database. This is static for now....
  static Future<List<ListItem>> getItems(String username, String listName) async {

    var data = await Future.wait([getList(username, listName)]);
    List<ListItem> foodList = [];

    for(var i = 0; i < data[0].length; i++) {
      print(data[0][i]["image"]);
      ListItem temp = ListItem(itemName: data[0][i]["name"], imageName: data[0][i]["image"], expirationDate: "05/06/2023");
      foodList.add(temp);
    }

    return foodList;
  }


  // gets the data from a specific list (grocery, fridge, etc.)
  static Future<List> getList(String username, String listName) async {

    CollectionReference ref = FirebaseFirestore.instance.collection("users").doc(username).collection(listName);

    List allData = [];
    
    await ref.get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final stuff = docSnapshot.data();
          allData.add(stuff);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return(allData);
  }

  static void addItem(String username, String listName, String foodName, String foodType, String imgURL, String expDate) {
    
    final foodItem = <String, dynamic> {
      "name": foodName,
      "food type": foodType,
      "expiration date": expDate,
      "image": imgURL
    };

    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db.collection("users").doc(username).collection(listName).doc(foodName);
    ref.set(foodItem);

  }


  // deletes item from database based on name/doc title
  static void deleteItem(String username, String listName, String foodName) {

    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db.collection("users").doc(username).collection(listName).doc(foodName);
    ref.delete().then(
      (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e")
    );

  }

  static Future<String> getAllItems(String username) async {
    String full = "";

    var listFridge = await Future.wait([getList(username, "Fridge List")]);
    var listPantry = await Future.wait([getList(username, "Pantry List")]);

    for (int i = 0; i < listFridge[0].length; i++) {
      full += listFridge[0][i]['name'];
      full += ", ";
    }

    for (int i = 0; i < listPantry[0].length; i++) {
      full += listPantry[0][i]['name'];
      full += ", ";
    }

    full = full.substring(0, full.length - 2);

    return full;
  }


    //Retrieves the list names based on username.
    static Future<List<ListType>> fetchListNames(String userName) async {

      var data = await Future.wait([getList("me", "Lists")]);

      List<ListType> listNames = [];

      for(var i = 0; i < data[0].length; i++) {

        ListType temp = ListType(
          listName: data[0][i]["name"],
          isGroceryList: data[0][i]["isGroceryList"],
          isPantryList:data[0][i]["isPantryList"],
            isFridgeList: data[0][i]["isFridgeList"],
            isFreezerList: data[0][i]["isFreezerList"]);
        listNames.add(temp);
      }

      return listNames;
    }

  //Method to add a new custom list to the database.
  static void addNewList(String userName, String listName, String listType){

    //New list info.
    var newList = <String, dynamic> {
      "isFreezerList": false,
      "isFridgeList": false,
      "isGroceryList": false,
      "isPantryList": false,
      "name": listType
    };

    //Firebase does not allow for the creation of empty collections, so this is just a default food item for now.
    //Will require the user to scan an item upon new list creation later....
    final foodItem = <String, dynamic> {
      "name": "",
      "food type": " ",
      "expiration date": " ",
      "image": " "
    };

    //Sets the flag based on list type.
    switch (listType){
      case "Grocery List": {
        newList.update("isGroceryList", (value) => true);
      }
      break;
      case "Fridge List": {
        newList.update("isFridgeList", (value) => true);
      }
      break;
      case "Pantry List": {
        newList.update("isPantryList", (value) => true);
      }
      break;
      case "Freezer List": {
        newList.update("isFreezerList", (value) => true);
      }
      break;
    }

    FirebaseFirestore db = FirebaseFirestore.instance;

    //Creates a new collection given the list name.
    final ref = db.collection("users").doc(userName).collection('Lists').doc(listName);
    db.collection("users").doc(userName).collection(listName).doc("American Cheese").set(foodItem);

    final ref2 = db.collection("users").doc(userName).collection(listName).doc("American Cheese");
    ref2.delete().then(
            (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e")
    );

    ref.set(newList);

  }

}