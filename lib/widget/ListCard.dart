import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';

import '../models/ListItem.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    Key? key, required this.item,
  }) : super(key: key);

  //Reference for the current list item.
 final ListItem item;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(onPressed: (context){
            //Do action here //todo: add action to add to list.
          },
            //borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.blue,
            //padding: const EdgeInsets.all(20),
            icon: Icons.add,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(onPressed: (context){
            //Do action here //todo: add action to remove from list.
          },
            //borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.red,
            //padding: const EdgeInsets.all(20),
            icon: Icons.delete,
          ),
        ],
      ),
      child: Container(
        //margin: EdgeInsets.all(20),
        height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(20),
                    color: Color(0xffdbdfd1),
                    border: Border.all(color: Colors.grey)
                ),
              ),
            ),
            Row(
              children: [
                Image.asset(item.imageName),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Text(item.itemName, style: TextStyle(fontSize: 25),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}