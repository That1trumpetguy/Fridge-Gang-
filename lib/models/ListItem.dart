//Class to model each list item. Will be used by the ListItemHelper class to derive a list from the database.
/*
class ListItem {
  String itemName = '';
  String imageName = '';
  String expirationDate = '';

  ListItem({required this.itemName, required this.imageName, required this.expirationDate});

}*/

class ListItem {
  final String itemName;
  //final String foodType;
  final String imageName;
  String expirationDate;

  ListItem({
    required this.itemName,
    //required this.foodType,
    required this.imageName,
    required this.expirationDate,
  });

  // Convert the ListItem object to a Map
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      //'description': foodType,
      'imageName': imageName,
      'expirationDate': expirationDate,
    };
  }

  // Create a ListItem object from a Map
  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      itemName: map['itemName'],
      //foodType: map['Category '],
      imageName: map['imageName'],
      expirationDate: map['expirationDate'],
    );
  }
}
