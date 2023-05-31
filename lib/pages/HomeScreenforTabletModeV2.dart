import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_app/BarScanner.dart';
import 'package:flutter_app/models/ListType.dart';
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
import '../widget/ListCard.dart';
import 'CustomListPage.dart';

//import 'package:myapp/utils.dart';

class Scene2 extends StatefulWidget {
  const Scene2({Key? key}) : super(key: key);

  @override
  State<Scene2> createState() => _SceneState();

}

class _SceneState extends State<Scene2> {
  late Future future;
  List<ListItem> WhatIHaveList = [];
  List<ListType> _listNames = [];
  final String defaultList = 'Grocery List';
  late String _selectedList;
  List<DropdownMenuItem<String>> dropdownItems = [];
  String value = "Fridge List";

  //For radio buttons.
  String group = '';

  //Map<String, dynamic>? listNames;

  Future<List> listNames = ListItemHelper.fetchListNames();


  Future<int> whatIHaveListItem(String listName) async {
    WhatIHaveList = await ListItemHelper.getItems(listName);

    if (kDebugMode) {
      print(WhatIHaveList);
    }
    return 1;
  }

  void currentList(String listName){
    ListItemHelper.currentList = listName;
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
    _fetchAllRecipes().then((recipes) {
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
                        )).then((value) => callback(WhatIHaveList));},
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
            // Left to Middle
            Positioned(
              top: screenHeight * 0.15,
              left: 0,
              right: screenWidth / 1.69,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                        'What I have in',
                        style: SafeGoogleFont(
                          'Inter',
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000),
                        ),
                      ),
                        IconButton(
                            onPressed: () {

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomListPage(),
                                  )
                              );

                              //openDialog(); //////////////////
                        },
                            icon: Icon(Icons.add)),
                ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        alignment: Alignment.center,
                        color: Color(0xffdbdfd1),
                        height: screenHeight * 0.035,
                        width: screenWidth * 0.8,

                        child: FutureBuilder(
                        future: getMyLists(),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          if (!snapshot.hasData){
                            Center(child: CircularProgressIndicator());
                          } else {
                            return DropdownButton<String>( //Dropdown menu.
                              value: value,
                              items: _listNames.map((ListType value) {
                                return DropdownMenuItem<String>(
                                  value: value.listName,
                                  child: Text(value.listName, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                );

                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  currentList(value!);
                                  this.value = value;
                                  whatIHaveListItem(this.value ?? defaultList);
                                });

                              },
                            );
                          }

                          return Container();

                        },

                      ),),
                    ),
                    SizedBox(
                      height: screenHeight * 0.65,
                      width: screenWidth * 0.8,
                      child: FutureBuilder(
                          future: whatIHaveListItem(value.toString()),
                          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                            if (!snapshot.hasData) {
                              print("here");
                              return Center(child: CircularProgressIndicator());
                            } else {
                              print("there");
                              return ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: double.infinity,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: WhatIHaveList.length,
                                  itemBuilder: (BuildContext context, int index){

                                    if (WhatIHaveList[index].itemName != ' ') {
                                     return ListCard(
                                         item: WhatIHaveList[index],
                                         listName: value ?? '',
                                         index: index,
                                         foodList: WhatIHaveList,
                                         callback: callback
                                     );
                                   }
                                  },
                                ),
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
            // Recommended for You and Refresh Button
            Positioned(
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
                ],
              ),
            ),
            // FutureBuilder
            FutureBuilder<Map<String, dynamic>>(
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
                        margin: EdgeInsets.only(left: screenWidth / 2.45), // Adjust the left margin as needed
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
                    List<String> fridgeList = WhatIHaveList.map((item) => item.itemName).toList();
                    for (String condiments in recipeIngredients) {
                      if (fridgeList.contains(condiments)) {
                        ownedIngredients++;
                      } else {
                        missingIngredients++;
                      }
                    }
                    String ok =
                        'You have ' + ownedIngredients.toString() + '\n' + 'You are missing ' + missingIngredients.toString();
                    return ok;
                  }
                  return Positioned(
                      top: screenHeight * 0.20,
                      left: screenWidth / 2.45,
                      right: 0,
                    child: Column(
                      children: [
                        // Breakfast Code below:
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecipePage(recipe: breakfast)),
                            );
                          },

                          child: Container(
                            height: screenHeight * (0.65 / 3),
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
                                          height: screenHeight * 0.4,
                                          width: screenWidth * 0.4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: RichText(
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
                                                              '\n'
                                                      ),
                                                      TextSpan(
                                                        text: /*'Vegetarian: ' + breakfast['vegetarian'].toString() + '\nGluten free: ' + breakfast['glutenFree'].toString()
                                                                + *//*'\n'+getMissingIngredients(breakfast)*/
                                                        '\nYou are missing: \n' + breakfast['missedIngredientCount'].toString() + ' Ingredients',
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
                        ),
                        // Divider
                        SizedBox(height: screenHeight * 0.02,),
                        // Lunch Code below:
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecipePage(recipe: lunch)),
                            );
                          },

                          child: Container(
                            height: screenHeight * (0.65 / 3),
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
                                          height: screenHeight * 0.4,
                                          width: screenWidth * 0.4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: RichText(
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
                                                              '\n'
                                                      ),
                                                      TextSpan(
                                                        text:/*'Vegetarian: ' + lunch['vegetarian'].toString() + '\nGluten free: ' + lunch['glutenFree'].toString()*/
                                                        '\nYou are missing: \n' + breakfast['missedIngredientCount'].toString() + ' Ingredients',
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
                        ),
                        SizedBox(height: screenHeight * 0.02,),
                        // Dinner Code below:
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecipePage(recipe: dinner)),

                            );
                          },

                          child: Container(
                            height: screenHeight * (0.65 / 3),
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
                                          height: screenHeight * 0.4,
                                          width: screenWidth * 0.4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: RichText(
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
                                                              '\n'
                                                      ),
                                                      TextSpan(
                                                        text: /*'Vegetarian: ' + dinner['vegetarian'].toString() + '\nGluten free: ' + dinner['glutenFree'].toString()*/
                                                        '\nYou are missing: \n' + breakfast['missedIngredientCount'].toString() + ' Ingredients',
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
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
