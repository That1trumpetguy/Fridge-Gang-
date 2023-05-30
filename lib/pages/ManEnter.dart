import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
//import 'package:flutter_app/models/ListItem.dart';
import 'package:flutter_app/pages/ProdPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/ListType.dart';
//import 'dart:io';
//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ManEnter extends StatefulWidget {
  @override
  _ManEnterState createState() => _ManEnterState();
}

class _ManEnterState extends State<ManEnter> {
  String? _selectedList;
  Future<List<ListType>> _lists = ListItemHelper.fetchListNames();

  String? _productName;
  DateTime? _expirationDate;
  File? _imageFile;

  void _takePicture() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Widget _buildDropdownMenu() {
    return FutureBuilder<List<ListType>>(
      future: ListItemHelper.fetchListNames(),
      builder: (BuildContext context, AsyncSnapshot<List<ListType>> snapshot) {
        if (snapshot.hasData) {
          List<String> listNames =
              snapshot.data!.map((list) => list.listName).toList();

          return Column(
            children: [
              DropdownButton<String>(
                value: _selectedList,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedList = newValue;
                  });
                },
                items: listNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildImagePreview() {
    return _imageFile != null
        ? Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(_imageFile!),
                fit: BoxFit.cover,
              ),
            ),
          )
        : SizedBox.shrink();
  }

  void addItem(
    context,
    String listName,
    String foodName,
    String foodType,
    String imgURL,
    File imageFile,
    String expDate,
  ) async {
    String imageName = '';

    if (imageFile != null) {
      // Upload the image to Firebase Storage
      String? imagePath = await ListItemHelper.uploadImage(imageFile);
      if (imagePath != null) {
        // Image was uploaded
        imageName = imagePath;
      }
    } else if (imgURL != null) {
      // Use provided image
      imageName = imgURL;
    }

    final foodItem = <String, dynamic>{
      "name": foodName,
      "food type": foodType,
      "expiration date": expDate,
      "image": imageName,
    };

    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(listName)
        .doc(foodName);
    ref.set(foodItem);

    // Display a success message or take any other action
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Item Added'),
          content: Text('The item has been added to the $listName.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manually Enter Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) {
                  _productName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _expirationDate = pickedDate;
                    });
                  }
                },
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Expiration Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: _expirationDate != null
                      ? '${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}'
                      : '',
                ),
              ),
              SizedBox(height: 20),
              _buildDropdownMenu(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _takePicture();
                },
                child: Text('Take Picture'),
              ),
              SizedBox(height: 20),
              _buildImagePreview(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_productName != null &&
                      _expirationDate != null &&
                      _selectedList != null &&
                      _imageFile != null) {
                    // Create a new ListItem object with the entered details
                    addItem(
                      context,
                      _selectedList!,
                      _productName!,
                      '',
                      '',
                      _imageFile!, //still does not show the image
                      _expirationDate
                          .toString(), //need to modify this so that it drops the miliseconds and such
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Missing Information'),
                          content: Text(
                              'Please fill in all the required information and select a list.'),
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ManEnter(),
  ));
}
