import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../models/ListType.dart';

//Class to derive lists (grocery, fridge, custom) from the database.
class ListItemHelper {

  //Derives a list of grocery items from database. This is static for now....
  static Future<List<ListItem>> getGroceryListItems() async {
    var data = await Future.wait([getList("Grocery List")]);
    List<ListItem> foodList = [];

    for (var i = 0; i < data[0].length; i++) {
      print(data[0][i]["image"]);
      ListItem temp = ListItem(
          itemName: data[0][i]["name"],
          imageName: data[0][i]["image"],
          expirationDate: "05/06/2023");
      foodList.add(temp);
    }

    return foodList;
  }

  //Derives a list of grocery items from database. This is static for now....
  static Future<List<ListItem>> getItems(String listName) async {
    var data = await Future.wait([getList(listName)]);
    List<ListItem> foodList = [];

    for (var i = 0; i < data[0].length; i++) {
      print(data[0][i]["expiration date"]);
      print(data[0][i]["image"]);
      ListItem temp = ListItem(
          itemName: data[0][i]["name"] ?? '',
          imageName: data[0][i]["image"] ?? '',
          expirationDate: data[0][i]["expiration date"] ?? '');

          //expirationDate: "05/06/2023");
      foodList.add(temp);
    }

    return foodList;
  }

  // gets the data from a specific list (grocery, fridge, etc.)
  static Future<List> getList(String listName) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(listName);

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
    return (allData);
  }

  static void addItem(String listName, String foodName,
      String foodType, String imgURL, String expDate) {
    final foodItem = <String, dynamic>{
      "name": foodName,
      "food type": foodType,
      "expiration date": expDate,
      "image": imgURL
    };

    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref =
        db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection(listName).doc(foodName);
    ref.set(foodItem);
  }

  // deletes item from database based on name/doc title
  static void deleteItem(String listName, String foodName) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref =
        db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection(listName).doc(foodName);
    ref.delete().then((doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"));
  }

  static Future<String> getAllItems() async {
    String full = "";

    var listFridge = await Future.wait([getList("Fridge List")]);
    var listPantry = await Future.wait([getList("Pantry List")]);

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
  static Future<List<ListType>> fetchListNames() async {
    var data = await Future.wait([getList("Lists")]);

    List<ListType> listNames = [];

    for (var i = 0; i < data[0].length; i++) {
      ListType temp = ListType(
          listName: data[0][i]["name"],
          isGroceryList: data[0][i]["isGroceryList"],
          isPantryList: data[0][i]["isPantryList"],
          isFridgeList: data[0][i]["isFridgeList"],
          isFreezerList: data[0][i]["isFreezerList"]);
          listNames.add(temp);
    }

    return listNames;
  }

  // Retrieves only lists of owned items
  static Future<List<ListType>> fetchOwnedListNames() async {
    var data = await Future.wait([getList("Lists")]);

    List<ListType> listNames = [];

    for (var i = 0; i < data[0].length; i++) {
      ListType temp = ListType(
          listName: data[0][i]["name"],
          isGroceryList: data[0][i]["isGroceryList"],
          isPantryList: data[0][i]["isPantryList"],
          isFridgeList: data[0][i]["isFridgeList"],
          isFreezerList: data[0][i]["isFreezerList"]);
          if (!temp.isGroceryList) {
            listNames.add(temp);
          }
    }

    return listNames;
  }

  //Method to add a new custom list to the database.
  static void addNewList(String listName, String listType) {
    //New list info.
    var newList = <String, dynamic>{
      "isFreezerList": false,
      "isFridgeList": false,
      "isGroceryList": false,
      "isPantryList": false,
      "name": listName
    };

    //Dummy food item.
    final foodItem = <String, dynamic>{
      "name": " ",
      "food type": " ",
      "expiration date": " ",
      "image": " "
    };

    //Sets the flag based on list type.
    switch (listType) {
      case "Grocery List":
        {
          newList.update("isGroceryList", (value) => true);
        }
        break;
      case "Fridge List":
        {
          newList.update("isFridgeList", (value) => true);
        }
        break;
      case "Pantry List":
        {
          newList.update("isPantryList", (value) => true);
        }
        break;
      case "Freezer List":
        {
          newList.update("isFreezerList", (value) => true);
        }
        break;
    }

    FirebaseFirestore db = FirebaseFirestore.instance;

    //Creates a new collection given the list name.
    final ref =
        db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection('Lists').doc(listName).set(newList);
    db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(listName)
        .doc(" ")
        .set(foodItem);

    final ref2 = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(listName)
        .doc("");
    ref2.delete().then((doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"));
  }

  static Future<void> updateExpiry(String listName,
      String foodName, String expirationDate) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection(listName).doc(foodName);

    await ref.update({
      'expiration date': expirationDate,
    });

    print('Updated expiration date: $expirationDate');
  }

  static Future<List<ListItem>> addToExpirationList(String listName) async{
    final listItems = await getItems(listName);
    final currentDate = DateTime.now();
    final expirationLimit = currentDate.add(Duration(days:4));
    final itemsToExpire = <ListItem>[];

    for(final item in listItems){
      final expirationDate = DateTime.parse(item.expirationDate);
      if(expirationDate.isBefore(expirationLimit)){
        itemsToExpire.add(item);
      }
    }
    return itemsToExpire;
  }

  //Check if a given list name already exists for a particular user.
  static Future<bool> listAlreadyExists(String listName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final snapshot = await db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection(listName).get();

    if(snapshot.size == 0){
      //List does not exist.
      return false;
    }

    return true;
  }

  static Future<bool> maxNumListsReached(int maxNumLists) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    

    final snapshot = await db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection('Lists').count().get();

    if (snapshot.count == maxNumLists){
      return true;
    }

    return false;
  }

  static void newUserLists(String? userName) async {

    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db.collection("users").doc(userName).collection("Lists");

    var fList = <String, dynamic>{
      "isFreezerList": false,
      "isFridgeList": true,
      "isGroceryList": false,
      "isPantryList": false,
      "name": "Fridge List"
    };

    var pList = <String, dynamic>{
      "isFreezerList": false,
      "isFridgeList": false,
      "isGroceryList": false,
      "isPantryList": true,
      "name": "Pantry List"
    };

    var gList = <String, dynamic>{
      "isFreezerList": false,
      "isFridgeList": false,
      "isGroceryList": true,
      "isPantryList": false,
      "name": "Grocery List"
    };

    var eList = <String, dynamic>{
      "isFreezerList": false,
      "isFridgeList": false,
      "isGroceryList": true,
      "isPantryList": false,
      "name": "Expiration List"
    };


    ref.doc("Fridge List").set(fList);
    ref.doc("Pantry List").set(pList);
    ref.doc("Grocery List").set(gList);
    ref.doc("Expiration List").set(eList);
  }


}
  /*
  static Future<void> swapAndDeleteItem(String userName, String itemName){

}

   */


void main(){

}
