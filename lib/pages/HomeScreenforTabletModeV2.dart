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


//import 'package:myapp/utils.dart';

class Scene2 extends StatefulWidget {
  @override
  State<Scene2> createState() => _SceneState();
}

class _SceneState extends State<Scene2> {
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
              left: 0,
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
              top: screenHeight * 0.2,
              left: 0,
              right: screenWidth / 3,
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * 0.6,
                  color: Colors.yellow,
                ),
              ),
            ),
            // Middle to Right
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth / 3,
              right: 0,
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.2,
                    color: Colors.pink,
                  ),
                  Container(
                    height: screenHeight * 0.2,
                    color: Colors.purple,
                  ),
                  Container(
                    height: screenHeight * 0.2,
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