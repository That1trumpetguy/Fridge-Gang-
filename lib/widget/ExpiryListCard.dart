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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
        height: screenHeight * 0.16,
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
                  borderRadius: BorderRadius.circular(screenWidth * 0.150),
                  child: CachedNetworkImage(
                    cacheManager: ListCard.customCacheManager,
                    height: screenHeight * .140,
                    width: screenWidth* .140,
                    key: UniqueKey(),
                    imageUrl: widget.item.imageName,
                    placeholder: (context,url) => Container(color: Colors.black12,),
                    errorWidget: (context,url,error) => Container(
                      child: Icon(Icons.error, color: Colors.red,size: screenHeight * 0.080),
                    ),
                  ),
                ),

                   Flexible(
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.item.itemName,
                            style: TextStyle(fontSize: screenWidth * 0.04),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.visible,
                        ),
                        Text("Expires On: " + widget.item.expirationDate,
                            style: TextStyle(fontSize: screenWidth * 0.04),
                            textAlign: TextAlign.left),
                      ],
                  ),
                   ),

              ],
            )
          ],
        ),
      ),
    );
  }
}