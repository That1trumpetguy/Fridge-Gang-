//Class to model each list item. Will be used by the ListItemHelper class to derive a list from the database.
class ListItem {
  String itemName = '';
  String imageName = '';
  String expirationDate = '';

  ListItem({required this.itemName, required this.imageName, required this.expirationDate});

}