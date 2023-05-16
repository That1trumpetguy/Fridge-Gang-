import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';

import '../models/ListItem.dart';
import 'ListCard.dart';

class ExpiryListCard extends StatefulWidget {

  static final customCacheManager = CacheManager(
      Config(
        'customCacheKey',
        stalePeriod: const Duration(days: 15),
        maxNrOfCacheObjects: 100,
      )
  );
  ExpiryListCard({
    Key? key, required this.item,
  }) : super(key: key);

  //Reference for the current list item.
  final ListItem item;

  @override
  State<ExpiryListCard> createState() => _ExpiryListCardState();
}

class _ExpiryListCardState extends State<ExpiryListCard> {
  int counter = 1;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.asset(item.imageName),
                ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: CachedNetworkImage(
                    cacheManager: ListCard.customCacheManager,
                    height: 140,
                    width: 140,
                    key: UniqueKey(),
                    imageUrl: widget.item.imageName,
                    placeholder: (context,url) => Container(color: Colors.black12,),
                    errorWidget: (context,url,error) => Container(
                      child: const Icon(Icons.error, color: Colors.red,size: 80),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.item.itemName, style: const TextStyle(fontSize: 25), textAlign: TextAlign.left),
                      Text("Expires On: " + widget.item.expirationDate, style: const TextStyle(fontSize: 25), textAlign: TextAlign.left),
                    ],
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