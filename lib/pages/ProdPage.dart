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
              'Product Category: ${product?.categories ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Image.network(product?.imageFrontSmallUrl ?? ''),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ListItem newItem = ListItem(
                  itemName: product?.productName ?? '',
                  imageName: product?.imageFrontSmallUrl ?? '',
                  expirationDate: '5/13/2023',
                );
                onAddToList(newItem);
                Navigator.of(context).pop();
              },
              child: Text('Add to List'),
            ),
          ],
        ),
      ),
    );
  }
}
