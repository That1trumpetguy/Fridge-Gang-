

import 'package:flutter/material.dart';

class Alert {

  static void showAlertDialog({required BuildContext context, required String msg, required String title}){
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        TextButton(
            onPressed: (){},
            child: const Text("ok")),
      ],

    );

    showDialog(
        context: context,
        builder: (BuildContext context){
          return alert;
        }
    );
  }

}