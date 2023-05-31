import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firebase_options.dart';
import '../models/ListType.dart';

//Class to derive lists (grocery, fridge, custom) from the database.
class ListItemHelper {
  static String? currentList;

  static Future<String> getLastViewed() async {
    var ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    String last = "";

    await ref.get().then(
      (querySnapshot) {
        var data = querySnapshot.data();
        last = data!["lastViewed"].toString();
      }
    );

    return last;
  }

  static void setLastViewed(String list) async {
    var ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    ref.update({"lastViewed": list});
  }

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

  static void addItem(String listName, String foodName, String foodType,
      String imgURL, File image, String expDate) async {
    String imageName = '';

    if (imgURL != null) {
      //Use provided image
      imageName = imgURL;
    } else if (image != null) {
      //Upload the image to the Firebase
      String? imagePath = await uploadImage(image);
      if (imagePath != null) {
        //Image was uploaded
        imageName = imagePath;
      }
    }

    final foodItem = <String, dynamic> {
      "name": foodName,
      "food type": foodType,
      "expiration date": expDate,
      "image": imgURL
    };

    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(listName)
        .doc(foodName);
    ref.set(foodItem);
  }

  static Future<String?> uploadImage(File image) async {
    try {
      // Replace 'your-image-folder' with the desired folder name in Firebase Storage
      String folderName = 'Test-Folder';

      // Generate a unique image name
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload the image file to Firebase Storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child(folderName)
          .child('$imageName.jpg');
      await storageRef.putFile(image);

      // Get the download URL of the uploaded image
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // deletes item from database based on name/doc title
  static void deleteItem(String listName, String foodName) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(listName)
        .doc(foodName);
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

      if (temp.listName != 'Expiration List') {
        listNames.add(temp);
      }
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
    final ref = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Lists')
        .doc(listName)
        .set(newList);
  }

  //updating expiration dates
  static Future<void> updateExpiry(
      String listName, String foodName, String expirationDate) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(listName)
        .doc(foodName);

    await ref.update({
      'expiration date': expirationDate,
    });

    print('Updated expiration date: $expirationDate');
  }

  // deletes a list from available lists
  static void deleteList(String listName) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("Lists")
        .doc(listName);
    ref.delete();
  }

  //populating the about to expire list page
  static Future<List<ListItem>> addToExpirationList(/*String listName*/) async {
    final myLists = await fetchOwnedListNames();
    //final listItems = await getItems(listName);
    final currentDate = DateTime.now();
    final expirationLimit = currentDate.add(Duration(days: 4));
    final itemsToExpire = <ListItem>[];
    for (final listType in myLists) {
      final listItems = await getItems(listType.listName);
      for (final item in listItems) {
        final expirationDate = DateTime.parse(item.expirationDate);
        if (expirationDate.isBefore(expirationLimit) ||
            expirationDate.isAtSameMomentAs(expirationLimit)) {
          itemsToExpire.add(item);
        }
      }
    }

    /*for(final item in listItems){
      final expirationDate = DateTime.parse(item.expirationDate);
      if(expirationDate.isBefore(expirationLimit)){
        itemsToExpire.add(item);
      }
    }*/
    return itemsToExpire;
  }

  //Check if a given list name already exists for a particular user.
  static Future<bool> listAlreadyExists(String listName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(listName)
        .get();

    if (snapshot.size == 0) {
      //List does not exist.
      return false;
    }

    return true;
  }

  static Future<bool> maxNumListsReached(int maxNumLists) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Lists')
        .count()
        .get();

    if (snapshot.count == maxNumLists) {
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

    var ref2 = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    ref2.set({"lastViewed": "Grocery List"});
  }
}
/*
  static Future<void> swapAndDeleteItem(String userName, String itemName){

}

   */

void main() {}
