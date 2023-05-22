import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/pages/ProdPage.dart';
import 'package:flutter_app/pages/ManEnter.dart';

class ManEnter extends StatelessWidget {
  final String barcode;

  const ManEnter({Key? key, required this.barcode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Barcode: $barcode',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
              // Handle the entered product name
              onChanged: (value) {
                // Store the entered product name
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Image URL',
              ),
              // Handle the entered image URL
              onChanged: (value) {
                // Store the entered image URL
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Expiration Date',
              ),
              // Handle the entered expiration date
              onChanged: (value) {
                // Store the entered expiration date
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Create a new ListItem object with the entered details
                ListItem newItem = ListItem(
                  itemName: '', // Retrieve the stored product name
                  imageName: '', // Retrieve the stored image URL
                  expirationDate: '', // Retrieve the stored expiration date
                );
                // Call the method to add the item to the list
                ListItemHelper.addItem(
                  'me',
                  'Fridge List',
                  newItem.itemName,
                  '', //newItem.categories, somehow there is an error here, it does not want to accept foodType or categories
                  newItem.imageName,
                  newItem.expirationDate,
                );
                // You can show a confirmation message or take any other action
              },
              child: Text('Add to List'),
            ),
          ],
        ),
      ),
    );
  }
}
