import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_app/BarScanner.dart';
import 'package:flutter_app/pages/GroceryListPage.dart';
import 'package:flutter_app/AboutToExpireList.dart';
import 'package:flutter_app/pages/settings.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_app/utils.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/ListItemHelper.dart';
import '../models/ListItem.dart';
import '../widget/ListCard.dart';

//import 'package:myapp/utils.dart';

class Scene2 extends StatefulWidget {
  @override
  State<Scene2> createState() => _SceneState();
}

class _SceneState extends State<Scene2> {
  List<ListItem> WhatIHaveList = [];

  Future<int> whatIHaveListItem() async {
    WhatIHaveList = await ListItemHelper.getItems('me', 'Grocery List');
    if (kDebugMode) {
      print(WhatIHaveList);
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Top Row
            Positioned(
              top: screenHeight * 0.01,
              left: screenWidth * 0.05,
              child: Container(
                width: screenWidth *0.25,
                height: screenHeight * 0.1,
                decoration: BoxDecoration(
                  color: const Color(0xffdbdfd1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute (
                            builder: (BuildContext context) => const AboutToExpireList()
                        ));},
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth*0.3,
                    ),
                    child: Center(
                      child: Text(
                        'About to Expire!',
                        style: SafeGoogleFont(
                          'Inter',
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.01,
              left: screenWidth / 3,
              child: Container(
                width: screenWidth / 3,
                height: screenHeight * 0.1,
                decoration: BoxDecoration(
                  color: const Color(0xffdbdfd1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute (
                            builder: (BuildContext context) => const GroceryListPage()
                        ));},
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth*0.3,
                    ),
                    child: Center(
                      child: Text(
                        'My grocery list',
                        style: SafeGoogleFont(
                          'Inter',
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                width: screenWidth * 0.125,
                height: screenHeight * 0.1,
                child: IconButton(
                  icon: Image.asset(
                    'assets/page-1/images/settingfill.png',
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.2,
                  ),
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute (
                        builder: (BuildContext context) =>  SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bottom Center
            Positioned(
              bottom: 0,
              left: screenWidth/2 - (screenWidth * 0.3 / 2),
              child: SizedBox(
                width: screenWidth * 0.3,
                height: screenHeight * 0.1,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BarScanner()));
                      },
                    padding: const EdgeInsets.all(0.0),
                    icon: Image.asset(
                      'assets/page-1/images/camera.png',
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.2,
                    ),
                  ),
                ),
              ),
            ),
            // Left to Middle
            Positioned(
              top: screenHeight * 0.15,
              left: 0,
              right: screenWidth / 1.69,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'What I have',
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.65,
                      width: screenWidth * 0.8,
                      child: FutureBuilder(
                          future: whatIHaveListItem(),
                          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                            if (!snapshot.hasData) {
                              print("here");
                              return Center(child: CircularProgressIndicator());
                            } else {
                              print("there");
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: WhatIHaveList.length, //Todo: add grocery list size here.
                                itemBuilder: (BuildContext context, int index){
                                  return ListCard(item: WhatIHaveList[index]);
                                },
                              );
                            }
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Middle to Right
            Positioned(
              top: screenHeight * 0.15,
              left: screenWidth / 2.45,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Recommended for You',
                    style: SafeGoogleFont(
                      'Inter',
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff000000),
                    ),
                  ),
                  Container(
                    height: screenHeight * (0.65/3),
                    color: Colors.pink,
                  ),
                  Container(
                    height: screenHeight * (0.65/3),
                    color: Colors.purple,
                  ),
                  Container(
                    height: screenHeight * (0.65/3),
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}