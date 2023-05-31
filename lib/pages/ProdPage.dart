import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProdPage extends StatelessWidget {
  final Product? product;
  final Function(ListItem) onAddToList;

  const ProdPage(
      {Key? key,
      this.product,
      required this.onAddToList}) //there might also be an error here
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Name: ${product?.productName ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Categories: ${product?.categories ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Image.network(product?.imageFrontSmallUrl ?? ''),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //added autodate for items scanned into the system
                DateTime currentDate = DateTime.now();
                DateTime expDate = currentDate.add(Duration(days: 7));
                String formedDate =
                    "${expDate.year}-${expDate.month.toString().padLeft(2, '0')}-${expDate.day.toString().padLeft(2, '0')}";

                ListItem newItem = ListItem(
                  itemName: product?.productName ?? '',
                  imageName: product?.imageFrontSmallUrl ?? '',
                  expirationDate: formedDate,
                );
                onAddToList(newItem);

                // Display pop-up after adding the item to a list
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Item Added'),
                      content: Text('The item has been added to the list.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add to List'),
            ),
          ],
        ),
      ),
    );
  }
}
