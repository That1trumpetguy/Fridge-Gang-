import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AboutToExpireList.dart';
import 'package:flutter_app/BarScanner.dart';
import 'package:flutter_app/pages/GroceryListPage.dart';
import 'package:flutter_app/pages/RecipePage.dart';
import 'package:flutter_app/pages/SearchBarPopUpPage.dart';
import 'package:flutter_app/pages/settings.dart';
import 'package:flutter_app/utils.dart';

import '../api_services.dart';
import '../helpers/CustomColors.dart';
import '../helpers/ListItemHelper.dart';
import '../models/ListItem.dart';
import '../models/ListType.dart';
import '../widget/ListCard.dart';
import 'CustomListPage.dart';
import 'ListPage.dart';

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
  String? value = "Fridge List";

  String group = '';

  Future<List> listNames = ListItemHelper.fetchListNames();

  void currentList(String listName) {
    ListItemHelper.currentList = listName;
  }

  Future<int> whatIHaveListItem(String listName) async {
    WhatIHaveList = await ListItemHelper.getItems(listName);

    if (kDebugMode) {
      print(WhatIHaveList);
    }
    return 1;
  }

  Future<int> getMyLists() async {
    _listNames = await ListItemHelper.fetchOwnedListNames();

    if (kDebugMode) {
      print(_listNames);
    }
    return 1;
  }

  //To set the state.
  callback(varWhatIHaveList) {
    setState(() {
      WhatIHaveList = varWhatIHaveList;
    });
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

  Future<Map<String, dynamic>> _fetchAllRecipes() async {
    final breakfastFuture = fetchBreakfastRecipe();
    final lunchFuture = fetchLunchRecipes();
    final dinnerFuture = fetchDinnerRecipes();
    final List<dynamic> results = await Future.wait([
      breakfastFuture,
      lunchFuture,
      dinnerFuture,
    ]);

    return {
      'breakfast': results[0],
      'lunch': results[1],
      'dinner': results[2],
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
                        builder: (BuildContext context) => SearchBarPopUpPage(),
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
                        color: CustomColors.primary,
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
                        color: CustomColors.primary,
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
                        color: CustomColors.primary,
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                                future: getMyLists(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
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
                                        currentList(value!);
                                        whatIHaveListItem(
                                            this.value ?? defaultList);
                                        // Open the popup menu here or perform any other desired action
                                        //_openPopupMenu(value!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListPage(value)),
                                        );
                                      });
                                    },
                                  );
                                }),
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
            Positioned(
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
                          _fetchAllRecipes() /*_fetchRecipes()*/
                              .then((recipes) {
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
                ],
              ),
            ),
            FutureBuilder(
                future: Future.value(_allRecipes),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError && snapshot.error.runtimeType == TypeError) {
                    // Specific error case: Show loading circle
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: $snapshot.error}'));
                  } else {
                    final Map<String, dynamic>? recipes = snapshot.data;
                    if (recipes == null) {
                      return Center(child: Text('Recipes data is null'));
                    }
                    final Map<String, dynamic>? breakfast = recipes['breakfast'];
                    final Map<String, dynamic>? lunch = recipes['lunch'];
                    final Map<String, dynamic>? dinner = recipes['dinner'];
                    if (breakfast == null || lunch == null || dinner == null) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.45),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                                'Please wait a few seconds...\n'
                                    '(If no recipes show up, either: \n'
                                    'no recipes to match the held ingredients or \n'
                                    'an error has occurred.)',
                              style: TextStyle(fontSize: screenWidth * 0.05),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      );
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
                      top: screenHeight * 0.5,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: screenHeight * 0.3,
                        child: PageView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecipePage(recipe: breakfast)));
                                },

                                // Container for Breakfast
                                child: Container(
                                  height: screenHeight * 0.3,
                                  decoration: BoxDecoration(
                                    color: CustomColors.primary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding( padding: EdgeInsets.all(8.0)),
                                      
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
                                                width: screenWidth * 0.6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize:
                                                                screenWidth *
                                                                    0.05,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                                      breakfast[
                                                                              'missedIngredientCount']
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecipePage(recipe: lunch)),
                                  );
                                },
                                child: Container(
                                  height: screenHeight * 0.3,
                                  decoration: BoxDecoration(
                                    color: CustomColors.primary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding( padding: EdgeInsets.all(8.0)),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize:
                                                                screenWidth *
                                                                    0.05,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xff000000),
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  lunch['title'] +
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
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecipePage(recipe: dinner)),
                                  );
                                },
                                child: Container(
                                  height: screenHeight * 0.3,
                                  decoration: BoxDecoration(
                                    color: CustomColors.primary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding( padding: EdgeInsets.all(8.0)),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize:
                                                                screenWidth *
                                                                    0.05,
                                                            fontWeight:
                                                                FontWeight.w500,
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
