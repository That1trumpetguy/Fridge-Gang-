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
    print("hi");

    for(var i = 0; i < data[0].length; i++) {
      ListItem temp = ListItem(itemName: data[0][i]["name"], imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023");
      foodList.add(temp);
    }

    return foodList;

    /* data[0]['name']
    return [
      ListItem(itemName: data[0]['name'], imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
    ]; */
  }

  static Future<List> getList(String username, String listName) async {

    CollectionReference ref = FirebaseFirestore.instance.collection("users").doc(username).collection(listName);

    List allData = [];
    
    await ref.get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final stuff = docSnapshot.data() as Map<String, dynamic>;
          allData.add(stuff);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return(allData);
  }
}