import 'package:flutter_app/models/ListItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

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

    var listFridge = await Future.wait([getList(username, "Fridge")]);
    var listPantry = await Future.wait([getList(username, "Pantry")]);

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
}