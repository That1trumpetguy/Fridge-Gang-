import 'package:flutter_app/models/ListItem.dart';

//Class to derive lists (grocery, fridge, custom) from the database.
class ListItemHelper {

  //Derives a list of grocery items from database. This is static for now....
  static List<ListItem> getGroceryListItems(){
    return [
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
      ListItem(itemName: "Tomatoes", imageName: 'assets/page-1/images/image-1.png', expirationDate: "05/06/2023"),
    ];
  }
}