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
import '../api_services.dart';
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

  Map<String, dynamic> _allRecipes = {};

  @override

  void initState() {
    super.initState();
    _fetchAllRecipes().then((recipes) {
      setState(() {
        _allRecipes = recipes;
        //print(_allRecipes);
      });
    });

  }


  Future<Map<String, dynamic>> _fetchAllRecipes() async {
    final breakfast = await fetchBreakfastRecipe();
    final lunch = await fetchLunchRecipes();
    final dinner = await fetchDinnerRecipes();
    return{
      'breakfast':breakfast,
      'lunch':lunch,
      'dinner':dinner,
    };
  }

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
                        textAlign: TextAlign.center,
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
                        textAlign: TextAlign.center,
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
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008,),
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
            FutureBuilder(
            future:  _fetchAllRecipes(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasError) {
                  return Center(child: Text('Error: $snapshot.error}'));
                }
                else {
                  //Map<String, dynamic> breakfast = snapshot.data!;
                  Map<String, dynamic> recipes = snapshot.data!;
                  Map<String, dynamic> breakfast = recipes['breakfast'];
                  Map<String, dynamic> lunch = recipes['lunch'];
                  Map<String, dynamic> dinner = recipes['dinner'];
                  return Positioned(
                    top: screenHeight * 0.15,
                    left: screenWidth / 2.45,
                    right: 0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Recommended for You',
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _allRecipes = {};
                                });
                                _fetchAllRecipes().then((recipes) {
                                  setState(() {
                                    _allRecipes = recipes;
                                  });
                                });
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: screenWidth * 0.05,
                                  height: screenHeight * 0.05,
                                  child: Image.asset(
                                    'assets/page-1/images/circleleft.png',
                                    width: screenWidth * 0.05,
                                    height: screenHeight * 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Breakfast Code below:
                        Container(
                          height: screenHeight * (0.65 / 3),
                          color: const Color(0xffdbdfd1),
                          child: Column(
                            children: [
                              Text(
                                'Breakfast',
                                textAlign: TextAlign.left,
                                style: SafeGoogleFont(
                                  'Inter',
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff000000),
                                ),
                              ),
                              Container(
                                width: screenWidth,
                                height: screenHeight * 0.15,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          width: screenWidth * 0.2,
                                          height: screenHeight * 0.2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    breakfast['image']),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: screenWidth * 0.21,
                                        child: SizedBox(
                                          child: Expanded(
                                            child: Column(
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: SafeGoogleFont(
                                                      'Inter',
                                                      fontSize: screenWidth * 0.03,
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff000000),
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                          text: breakfast['title'] +
                                                              '\n\n'
                                                      ),
                                                      TextSpan(
                                                        text: 'Vegetarian: ' + breakfast['vegetarian'].toString() + '\nGluten free: ' + breakfast['glutenFree'].toString(),
                                                        style: SafeGoogleFont(
                                                          'Inter',
                                                          fontSize: screenWidth *
                                                              0.03,
                                                          fontWeight: FontWeight.w500,
                                                          color: const Color(
                                                              0xff000000),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Lunch Code below:
                        Container(
                          height: screenHeight * (0.65 / 3),
                          color: const Color(0xffdbdfd1),
                          child: Column(
                            children: [
                              Text(
                                'Lunch',
                                textAlign: TextAlign.left,
                                style: SafeGoogleFont(
                                  'Inter',
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff000000),
                                ),
                              ),
                              Container(
                                width: screenWidth,
                                height: screenHeight * 0.15,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          width: screenWidth * 0.2,
                                          height: screenHeight * 0.2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    lunch['image']),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: screenWidth * 0.21,
                                      child: SizedBox(
                                        child: Expanded(
                                          child: Column(
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: SafeGoogleFont(
                                                    'Inter',
                                                    fontSize: screenWidth * 0.03,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                        text: lunch['title'] +
                                                            '\n\n'
                                                    ),
                                                    TextSpan(
                                                      text:'Vegetarian: ' + lunch['vegetarian'].toString() + '\nGluten free: ' + lunch['glutenFree'].toString(),
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: screenWidth *
                                                            0.03,
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(
                                                            0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Dinner Code below:
                        Container(
                          height: screenHeight * (0.65 / 3),
                          color: const Color(0xffdbdfd1),
                          child: Column(
                            children: [
                              Text(
                                'Dinner',
                                textAlign: TextAlign.left,
                                style: SafeGoogleFont(
                                  'Inter',
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff000000),
                                ),
                              ),
                              Container(
                                width: screenWidth,
                                height: screenHeight * 0.15,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          width: screenWidth * 0.2,
                                          height: screenHeight * 0.2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    dinner['image']),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: screenWidth * 0.21,
                                      child: SizedBox(
                                        child: Expanded(
                                          child: Column(
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: SafeGoogleFont(
                                                    'Inter',
                                                    fontSize: screenWidth * 0.03,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                        text: dinner['title'] +
                                                            '\n\n'
                                                    ),
                                                    TextSpan(
                                                      text: 'Vegetarian: ' + dinner['vegetarian'].toString() + '\nGluten free: ' + dinner['glutenFree'].toString(),
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: screenWidth *
                                                            0.03,
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(
                                                            0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              ),
          ],
        ),
      ),
    );
  }
}