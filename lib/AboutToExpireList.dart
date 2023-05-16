import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/widget/ExpiryListCard.dart';
import 'package:flutter_app/widget/ListCard.dart';
import '../models/ListItem.dart';

class AboutToExpireList extends StatefulWidget {
  const AboutToExpireList({Key? key}) : super(key: key);

  @override
  State<AboutToExpireList> createState() => _AboutToExpireListState();
}

class _AboutToExpireListState extends State<AboutToExpireList> {

  List<ListItem> expiryList = [];

  Future<int> something() async {
    expiryList = await ListItemHelper.getItems('me', 'Expiration');
    print(expiryList);
    return 1;
  }

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
              child: Text('About to Expire!',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 36
                ),),
            ),
            Expanded(
              child: FutureBuilder(
                  future: something(),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (!snapshot.hasData) {
                      print("here");
                      return Center(child: CircularProgressIndicator());
                    } else {
                      print("there");
                      return Container(
                          child: ListView.builder(
                            itemCount: expiryList.length, //Todo: add grocery list size here.
                            itemBuilder: (BuildContext context, int index){
                              return ExpiryListCard(item: expiryList[index]);
                            },
                          )
                      );
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
