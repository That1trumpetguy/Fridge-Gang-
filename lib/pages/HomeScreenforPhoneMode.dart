import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_app/BarScanner.dart';
import 'package:flutter_app/models/ListType.dart';
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

class PhoneScene extends StatefulWidget {
  const PhoneScene({Key? key}) : super(key: key);

  @override
  State<PhoneScene> createState() => _SceneState();
}

class _SceneState extends State<PhoneScene> {
  late Future future;
  List<ListItem> WhatIHaveList = [];
  //List<String> _listNames = ['Grocery List', 'Pantry List', 'Fridge List', 'Expiration'];
  List<ListType> _listNames = [];
  final String defaultList = 'Grocery List';
  late String _selectedList;
  List<DropdownMenuItem<String>> dropdownItems = [];
  String? value;

  //Map<String, dynamic>? listNames;

  Future<List> listNames = ListItemHelper.fetchListNames('me');


  Future<int> whatIHaveListItem(String userName, String listName) async {
    WhatIHaveList = await ListItemHelper.getItems(userName, listName);

    if (kDebugMode) {
      print(WhatIHaveList);
    }
    return 1;
  }

  Future<int> getMyLists(String userName) async {

    _listNames = await ListItemHelper.fetchListNames(userName);

    if (kDebugMode) {
      print(_listNames);
    }
    return 1;
  }




  Map<String, dynamic> _allRecipes = {};

  @override

  void initState() {
    super.initState();
    _fetchAllRecipes()/*_fetchRecipes()*/.then((recipes) {
      setState(() {
        _allRecipes = recipes;
        //print(_allRecipes);
      });
    });

  }


  Future<Map<String, dynamic>> _fetchAllRecipes() async {
    final breakfast = await fetchBreakfastRecipe();
    //final lunch = await fetchLunchRecipes();
    //final dinner = await fetchDinnerRecipes();
    print('Breakfast Recipes: $breakfast');
    return{
      'breakfast':breakfast,
      //'lunch':lunch,
      //'dinner':dinner,
    };
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Top Left
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                width: screenWidth * 0.125,
                height: screenHeight * 0.1,
                child: IconButton(
                  icon: Image.asset(
                    'assets/page-1/images/searchicon.png',
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
            // Top Right
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
              left: screenWidth/2 - (screenWidth * 0.2 / 2),
              child: SizedBox(
                width: screenWidth * 0.2,
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
                      height: screenHeight * 0.15,
                    ),
                  ),
                ),
              ),
            ),
            // Center Widgets
            Positioned(
              top: screenHeight * 0.1,
              left: 0,
              right: 0,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 3,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.black,
                    thickness: screenHeight * 0.01,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.1,
                      decoration: BoxDecoration(
                        color: const Color(0xffdbdfd1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => const GroceryListPage(),
                            ),
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.3,
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
                    );
                  } else if (index == 1) {
                    return Container(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.1,
                      decoration: BoxDecoration(
                        color: const Color(0xffdbdfd1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => const AboutToExpireList(),
                            ),
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.3,
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
                    );
                  } else {
                    return Container(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.1,
                      color: Colors.purple,
                    );
                  }
                },
              ),
            ),
            // Widget Between Center and Bottom Center Widgets
              FutureBuilder(
              future:  _fetchAllRecipes() /*_fetchRecipes()*/,
              builder: (BuildContext context, AsyncSnapshot <Map<String, dynamic>> snapshot) {
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
                  //Map<String, dynamic> lunch = recipes['lunch'];
                  //Map<String, dynamic> dinner = recipes['dinner'];

                  String getMissingIngredients(Map<String, dynamic> recipes) {
                    int missingIngredients = 0;
                    int ownedIngredients = 0;
                    //compare fridge list to recipe ingredients
                    List<String> recipeIngredients = [];
                    List<String> fridgeList = WhatIHaveList.map((item) =>
                    item.itemName)
                        .toList();
                    for (String condiments in recipeIngredients) {
                      if (fridgeList.contains(condiments)) {
                        ownedIngredients++;
                      } else {
                        missingIngredients++;
                      }
                    }
                    String ok = 'You have ' + ownedIngredients.toString() +
                        '\n' +
                        'You are missing ' + missingIngredients.toString();
                    return ok;
                  }

                  return Positioned(
                    top: screenHeight * 0.5,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Row(
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
                            SizedBox(width: screenWidth*0.35),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _allRecipes = {};
                                });
                                _fetchAllRecipes() /*_fetchRecipes()*/.then((
                                    recipes) {
                                  setState(() {
                                    _allRecipes = recipes;
                                  });
                                });
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: screenWidth * 0.07,
                                  height: screenHeight * 0.07,
                                  child: Image.asset(
                                    'assets/page-1/images/circleleft.png',
                                    width: screenWidth * 0.7,
                                    height: screenHeight * 0.07,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Breakfast Code below:
                        Container(
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                            color: const Color(0xffdbdfd1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Breakfast',
                                textAlign: TextAlign.left,
                                style: SafeGoogleFont(
                                  'Inter',
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff000000),
                                ),
                              ),
                              Container(
                                width: screenWidth,
                                height: screenHeight * 0.25,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: screenWidth * 0.05,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          width: screenWidth * 0.25,
                                          height: screenHeight * 0.25,
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
                                      left: screenWidth * 0.4,
                                      child: SizedBox(
                                        height: screenHeight * 0.5,
                                        width: screenWidth * 0.4,
                                        child: Column(
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: SafeGoogleFont(
                                                    'Inter',
                                                    fontSize: screenWidth *
                                                        0.05,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(
                                                        0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                        text: breakfast['title'] +
                                                            '\n\n'
                                                    ),
                                                    TextSpan(
                                                      text: /*'Vegetarian: ' + breakfast['vegetarian'].toString() + '\nGluten free: ' + breakfast['glutenFree'].toString()
                                                              + */ /*'\n'+getMissingIngredients(breakfast)*/
                                                      '\nYou are missing: \n' +
                                                          breakfast['missedIngredientCount']
                                                              .toString() +
                                                          ' Ingredients',
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: screenWidth *
                                                            0.05,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        color: const Color(
                                                            0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
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