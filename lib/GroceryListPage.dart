import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:  [
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
              child: Text('Grocery List',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 36
              ),),
            ),
            Expanded(child: ListView.builder(
                itemCount: 10, //Todo: add grocery list size here.
                itemBuilder: (BuildContext context, int index){

                  return Slidable(

                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(onPressed: (context){
                          //Do action here
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
                          //Do action here
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
                              ),),
                        ],
                      ),
                    ),
                  );
                },
            ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            child: new Icon(Icons.add),
            onPressed: () {  },),
        ),
      ),

    );
  }
}
