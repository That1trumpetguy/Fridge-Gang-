import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_app/BarScanner.dart';
import 'package:flutter_app/pages/GroceryListPage.dart';
import 'package:flutter_app/AboutToExpireList.dart';
import 'package:flutter_app/pages/RecipePage.dart';
import 'package:flutter_app/pages/settings.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_app/utils.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../api_services.dart';
import '../helpers/ListItemHelper.dart';
import '../models/ListItem.dart';
import '../models/ListType.dart';
import '../widget/ListCard.dart';
import 'CustomListPage.dart';

//import 'package:myapp/utils.dart';

class PhoneScene extends StatefulWidget {
  const PhoneScene({Key? key}) : super(key: key);

  @override
  State<PhoneScene> createState() => _SceneState();
}

class _SceneState extends State<PhoneScene> {
  late Future future;
  List<ListItem> WhatIHaveList = [];
  List<ListType> _listNames = [];
  final String defaultList = 'Grocery List';
  late String _selectedList;
  List<DropdownMenuItem<String>> dropdownItems = [];
  String? value;

  String group = '';

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
    _fetchAllRecipes() /*_fetchRecipes()*/ .then((recipes) {
      setState(() {
        _allRecipes = recipes;
        //print(_allRecipes);
      });
    });
  }

  void _openPopupMenu(String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(value), // Show the selected value as the title
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: FutureBuilder(
                future: whatIHaveListItem('me', value.toString()),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasError){
                    return Center(child:Text('Error: $snapshot.error}'));
                  }
                  else if (!snapshot.hasData) {
                    print("here");
                    return Center(child: CircularProgressIndicator());
                  } else {
                    print("there");
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: WhatIHaveList.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListCard(
                            item: WhatIHaveList[index],
                            index: index,
                            foodList: WhatIHaveList
                        );
                      },
                    );
                  }
      }
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup menu
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );
  }



  Future<Map<String, dynamic>> _fetchAllRecipes() async {
    final breakfast = await fetchBreakfastRecipe();
    final lunch = await fetchLunchRecipes();
    final dinner = await fetchDinnerRecipes();
    print('Breakfast Recipes: $breakfast');
    return {
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
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
                      MaterialPageRoute(
                        builder: (BuildContext context) => SettingsPage(),
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
                      MaterialPageRoute(
                        builder: (BuildContext context) => SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bottom Center
            Positioned(
              bottom: 0,
              left: screenWidth / 2 - (screenWidth * 0.2 / 2),
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
                              builder: (BuildContext context) =>
                                  const GroceryListPage(),
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
                              builder: (BuildContext context) =>
                                  const AboutToExpireList(),
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
                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                      child: Container(
                        alignment: Alignment.center,
                        color: Color(0xffdbdfd1),
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                                future: getMyLists('me'),
                                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                  return DropdownButton<String>(
                                    value: value,
                                    items: _listNames.map((ListType value) {
                                      return DropdownMenuItem<String>(
                                        value: value.listName,
                                        child: Text(
                                          value.listName,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        this.value = value;
                                        whatIHaveListItem('me', this.value ?? defaultList);
                                        // Open the popup menu here or perform any other desired action
                                        _openPopupMenu(value!);
                                      });
                                    },
                                  );
                              }
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomListPage(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            // Widget Between Center and Bottom Center Widgets
            FutureBuilder(
                future:  Future.value(_allRecipes) /*_fetchRecipes()*/,
                builder: (BuildContext context, AsyncSnapshot <Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError && snapshot.error.runtimeType == TypeError) {
                    // Specific error case: Show loading circle
                    return Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError) {
                    return Center(child: Text('Error: $snapshot.error}'));
                  }
                  else {
                    //Map<String, dynamic> breakfast = snapshot.data!;
                    final Map<String, dynamic>? recipes = snapshot.data;
                    if (recipes == null) {
                      return Center(child: Text('Recipes data is null'));
                    }

                    final Map<String, dynamic>? breakfast = recipes['breakfast'];
                    final Map<String, dynamic>? lunch = recipes['lunch'];
                    final Map<String, dynamic>? dinner = recipes['dinner'];

                    if (breakfast == null || lunch == null || dinner == null) {
                      return Center(child: CircularProgressIndicator());
                    }

                    String getMissingIngredients(Map<String, dynamic> recipes) {
                      int missingIngredients = 0;
                      int ownedIngredients = 0;
                      //compare fridge list to recipe ingredients
                      List<String> recipeIngredients = [];
                      List<String> fridgeList =
                          WhatIHaveList.map((item) => item.itemName).toList();
                      for (String condiments in recipeIngredients) {
                        if (fridgeList.contains(condiments)) {
                          ownedIngredients++;
                        } else {
                          missingIngredients++;
                        }
                      }
                      String ok = 'You have ' +
                          ownedIngredients.toString() +
                          '\n' +
                          'You are missing ' +
                          missingIngredients.toString();
                      return ok;
                    }

                    return Positioned(
                      top: screenHeight * 0.45,
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
                              SizedBox(width: screenWidth * 0.35),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _allRecipes = {};
                                  });
                                  _fetchAllRecipes()/*_fetchRecipes()*/.then((recipes) {
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
                          SizedBox(
                            height: screenHeight * 0.3,
                            child: PageView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipe: breakfast)));
                                    },

                                  // Container for Breakfast
                                  child: Container(
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
                                                              breakfast[
                                                                  'image']),
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
                                                  width: screenWidth * 0.6,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style:
                                                                SafeGoogleFont(
                                                              'Inter',
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.05,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color(
                                                                  0xff000000),
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: breakfast[
                                                                        'title'] +
                                                                    '\n\n',
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    /*'Vegetarian: ' + breakfast['vegetarian'].toString() + '\nGluten free: ' + breakfast['glutenFree'].toString()*/
                                                                    '\nYou are missing: \n' +
                                                                        breakfast['missedIngredientCount']
                                                                            .toString() +
                                                                        ' Ingredients',
                                                                style:
                                                                    SafeGoogleFont(
                                                                  'Inter',
                                                                  fontSize:
                                                                      screenWidth *
                                                                          0.05,
                                                                  fontWeight:
                                                                      FontWeight
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
                                  );
                                } else if (index == 1) {
                                  // Container for Lunch
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RecipePage(recipe: lunch)),
                                      );
                                    },

                                  child:  Container(
                                    height: screenHeight * 0.3,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffdbdfd1),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Lunch',
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
                                                              lunch['image']),
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
                                                  width: screenWidth * 0.6,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style:
                                                                SafeGoogleFont(
                                                              'Inter',
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.05,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color(
                                                                  0xff000000),
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: lunch[
                                                                        'title'] +
                                                                    '\n\n',
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    /*'Vegetarian: ' + lunch['vegetarian'].toString() + '\nGluten free: ' + lunch['glutenFree'].toString()*/
                                                                    '\nYou are missing: \n' +
                                                                        lunch['missedIngredientCount']
                                                                            .toString() +
                                                                        ' Ingredients',
                                                                style:
                                                                    SafeGoogleFont(
                                                                  'Inter',
                                                                  fontSize:
                                                                      screenWidth *
                                                                          0.05,
                                                                  fontWeight:
                                                                      FontWeight
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
                                  );
                                } else if (index == 2) {
                                  // Container for Dinner
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RecipePage(recipe: dinner)),
                                      );
                                    },

                                  child: Container(
                                    height: screenHeight * 0.3,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffdbdfd1),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Dinner',
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
                                                              dinner['image']),
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
                                                  width: screenWidth * 0.6,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style:
                                                                SafeGoogleFont(
                                                              'Inter',
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.05,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color(
                                                                  0xff000000),
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: dinner[
                                                                        'title'] +
                                                                    '\n\n',
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    /*'Vegetarian: ' + dinner['vegetarian'].toString() + '\nGluten free: ' + dinner['glutenFree'].toString()*/
                                                                    '\nYou are missing: \n' +
                                                                        dinner['missedIngredientCount']
                                                                            .toString() +
                                                                        ' Ingredients',
                                                                style:
                                                                    SafeGoogleFont(
                                                                  'Inter',
                                                                  fontSize:
                                                                      screenWidth *
                                                                          0.05,
                                                                  fontWeight:
                                                                      FontWeight
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
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
