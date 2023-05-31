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
class CustomColors {
  static final primary = Color.fromARGB(255, 92, 193, 233);

  // in case we want the old one
  //static final primary = const Color(0xffdbdfd1);
}