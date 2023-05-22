import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/pages/ProdPage.dart';

class ManEnter extends StatefulWidget {
  final String barcode;

  const ManEnter({Key? key, required this.barcode}) : super(key: key);

  @override
  _ManEnterState createState() => _ManEnterState();
}

class _ManEnterState extends State<ManEnter> {
  String? _productName;
  String? _imagePath;
  String? _expirationDate;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

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
              'Barcode: ${widget.barcode}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
              onChanged: (value) {
                setState(() {
                  _productName = value;
                });
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  child: Text('Take Picture'),
                ),
                SizedBox(width: 8),
                _imagePath != null
                    ? Text('Image Selected')
                    : Text('No Image Selected'),
              ],
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Expiration Date',
              ),
              onChanged: (value) {
                setState(() {
                  _expirationDate = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_productName != null && _expirationDate != null) {
                  // Create a new ListItem object with the entered details
                  ListItem newItem = ListItem(
                    itemName: _productName!,
                    imageName: _imagePath ?? '',
                    expirationDate: _expirationDate!,
                  );
                  // Call the method to add the item to the list
                  ListItemHelper.addItem(
                    'me',
                    'Fridge List',
                    newItem.itemName,
                    '',
                    newItem.imageName,
                    newItem.expirationDate,
                  );
                  // You can show a confirmation message or take any other action
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Missing Information'),
                        content: Text(
                            'Please fill in all the required information.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Add to List'),
            ),
          ],
        ),
      ),
    );
  }
}
