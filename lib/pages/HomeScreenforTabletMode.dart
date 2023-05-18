import 'package:flutter/material.dart';
import 'package:flutter_app/BarScanner.dart';
import 'package:flutter_app/pages/GroceryListPage.dart';
import 'package:flutter_app/AboutToExpireList.dart';
import 'package:flutter_app/pages/settings.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_app/utils.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter_app/api_services.dart';

import 'RecipePage.dart';

class Scene extends StatefulWidget {
  @override
  State<Scene> createState() => _SceneState();
}
class _SceneState extends State<Scene> {

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


  Widget build  (BuildContext context)      {
    double baseWidth = 834;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(

      body: FutureBuilder(
          future:  _fetchAllRecipes(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError){
              return Center(child:Text('Error: $snapshot.error}'));
            }
            else {
              //Map<String, dynamic> breakfast = snapshot.data!;
              Map<String, dynamic> recipes = snapshot.data!;
              Map<String, dynamic> breakfast = recipes['breakfast'];
              Map<String, dynamic> lunch = recipes['lunch'];
              Map<String, dynamic> dinner = recipes['dinner'];

              return Container(
                padding: EdgeInsets.only(top: 20),
                width: double.infinity,
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: Container(
                    // ipadpro111Eks (1:2)
                    width: double.infinity,
                    height: 1194 * fem,
                    decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          // autogroupiiawBrT (NYL8n3ytkRmYShsPWRiiAw)
                          left: 372 * fem,
                          top: 1091 * fem,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                20 * fem, 24.88 * fem, 19 * fem, 26.75 * fem),
                            width: 86 * fem,
                            height: 89 * fem,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/page-1/images/ellipse-1.png',
                                ),
                              ),
                            ),
                            child: Center(
                              // camera7Nj (3:2)
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
                                  width: 71 * fem,
                                  height: 64 * fem,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // autogrouph5toxu9 (NYL132P5vb8Qq2s1g7H5to)
                          left: 30 * fem,
                          top: 207 * fem,
                          child: Container(
                            width: 791 * fem,
                            height: 859 * fem,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroupnwwf2PD (NYL1yAVYNs28VPJ5jnNWWF)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 19 * fem, 0 * fem),
                                  width: 290 * fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // autogroupd8xdUW7 (NYL2FzLqhZJ2LnEzDhD8Xd)
                                        margin: EdgeInsets.fromLTRB(
                                            13 * fem, 0 * fem, 14 * fem, 39 * fem),
                                        padding: EdgeInsets.fromLTRB(
                                            27 * fem, 23 * fem, 17 * fem, 0 * fem),
                                        width: double.infinity,
                                        height: 84 * fem,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffffffff),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              // autogroupf2n7q7h (NYL2Rz4Bkd7wYKg8zzF2N7)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem, 0 * fem, 5 * fem, 0 * fem),
                                              width: 107 * fem,
                                              height: double.infinity,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                    'assets/page-1/images/ellipse-2.png',
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Fridge',
                                                  style: SafeGoogleFont(
                                                    'Inter',
                                                    fontSize: 20 * ffem,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.2125 * ffem / fem,
                                                    color: const Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // autogroupq9sjiKu (NYL2ZKBJj1G1kerrEsQ9Sj)
                                              padding: EdgeInsets.fromLTRB(
                                                  10 * fem, 17 * fem, 10 * fem, 19 * fem),
                                              width: 107 * fem,
                                              height: double.infinity,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                    'assets/page-1/images/ellipse-3.png',
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                '  Pantry',
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 20 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color: const Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // frame1qoq (3:5)
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              // autogroupvzrfkA7 (NYL383jmFM3HvuMa3hvzrf)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem, 0 * fem, 3 * fem, 63 * fem),
                                              width: 287 * fem,
                                              height: 93 * fem,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    // rectangle1DZV (3:6)
                                                    left: 11 * fem,
                                                    top: 0 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 276 * fem,
                                                        height: 93 * fem,
                                                        child: Image.asset(
                                                          'assets/page-1/images/rectangle-1.png',
                                                          width: 276 * fem,
                                                          height: 93 * fem,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // image1G1y (5:15)
                                                    left: 0 * fem,
                                                    top: 0 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 110 * fem,
                                                        height: 93 * fem,
                                                        child: Image.asset(
                                                          'assets/page-1/images/image-1.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // tomatoestJF (6:2)
                                                    left: 127 * fem,
                                                    top: 35 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 115 * fem,
                                                        height: 30 * fem,
                                                        child: Text(
                                                          'Tomatoes',
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize: 24 * ffem,
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.2125 * ffem / fem,
                                                            color: const Color(0xff000000),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // autogrouprptosAB (NYL3T82KERvcoSpnTJrPto)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem, 0 * fem, 3 * fem, 43 * fem),
                                              width: 276 * fem,
                                              height: 95 * fem,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    // rectangle2XkX (3:9)
                                                    left: 0 * fem,
                                                    top: 1 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 276 * fem,
                                                        height: 93 * fem,
                                                        child: Image.asset(
                                                          'assets/page-1/images/rectangle-2.png',
                                                          width: 276 * fem,
                                                          height: 93 * fem,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // image2Nm9 (5:17)
                                                    left: 0 * fem,
                                                    top: 0 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 99 * fem,
                                                        height: 95 * fem,
                                                        child: Image.asset(
                                                          'assets/page-1/images/image-2.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // milk4dy (6:4)
                                                    left: 116 * fem,
                                                    top: 28 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 48 * fem,
                                                        height: 30 * fem,
                                                        child: Text(
                                                          'Milk\n',
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize: 24 * ffem,
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.2125 * ffem / fem,
                                                            color: const Color(0xff000000),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // autogroupwbzs6qZ (NYL3m7WLXYp4xd1FrqWbzs)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem, 0 * fem, 3 * fem, 42 * fem),
                                              width: 276 * fem,
                                              height: 96 * fem,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    // rectangle3mwh (3:10)
                                                    left: 0 * fem,
                                                    top: 3 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 276 * fem,
                                                        height: 93 * fem,
                                                        child: Image.asset(
                                                          'assets/page-1/images/rectangle-3.png',
                                                          width: 276 * fem,
                                                          height: 93 * fem,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // image3cSX (5:19)
                                                    left: 0 * fem,
                                                    top: 0 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 113 * fem,
                                                        height: 96 * fem,
                                                        child: Image.asset(
                                                          'assets/page-1/images/image-3.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // chickenbreasthTy (6:5)
                                                    left: 116 * fem,
                                                    top: 30 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 95 * fem,
                                                        height: 59 * fem,
                                                        child: Text(
                                                          'Chicken breast\n',
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize: 24 * ffem,
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.2125 * ffem / fem,
                                                            color: const Color(0xff000000),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // autogroup6u35uyM (NYL3z2JVWgAsvcXKxB6U35)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem, 0 * fem, 3 * fem, 42 * fem),
                                              width: 276 * fem,
                                              height: 103 * fem,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    // rectangle48bD (3:15)
                                                    left: 0 * fem,
                                                    top: 5 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 276 * fem,
                                                        height: 93 * fem,
                                                        child: Image.asset(
                                                          'assets/page-1/images/rectangle-4.png',
                                                          width: 276 * fem,
                                                          height: 93 * fem,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // image4LBV (5:21)
                                                    left: 0 * fem,
                                                    top: 0 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 89 * fem,
                                                        height: 103 * fem,
                                                        child: Image.asset(
                                                          'assets/page-1/images/image-4.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // slicedcheese7Lf (6:6)
                                                    left: 116 * fem,
                                                    top: 30 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 85 * fem,
                                                        height: 59 * fem,
                                                        child: Text(
                                                          'Sliced cheese\n',
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize: 24 * ffem,
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.2125 * ffem / fem,
                                                            color: const Color(0xff000000),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // autogroupgkwpqR5 (NYL4Aw9ygnmJehMZtTGkWP)
                                              margin: EdgeInsets.fromLTRB(
                                                  14 * fem, 0 * fem, 0 * fem, 0 * fem),
                                              padding: EdgeInsets.fromLTRB(
                                                  1 * fem, 0 * fem, 74 * fem, 0 * fem),
                                              width: double.infinity,
                                              height: 93 * fem,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                    'assets/page-1/images/rectangle-5.png',
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    // image594P (5:23)
                                                    margin: EdgeInsets.fromLTRB(
                                                        0 * fem, 0 * fem, 3 * fem, 5 * fem),
                                                    width: 109 * fem,
                                                    height: 88 * fem,
                                                    child: Image.asset(
                                                      'assets/page-1/images/image-5.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    // iceberglettuceAkB (6:7)
                                                    margin: EdgeInsets.fromLTRB(0 * fem,
                                                        14 * fem, 0 * fem, 0 * fem),
                                                    constraints: BoxConstraints(
                                                      maxWidth: 89 * fem,
                                                    ),
                                                    child: Text(
                                                      'Iceberg lettuce\n',
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: 24 * ffem,
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.2125 * ffem / fem,
                                                        color: const Color(0xff000000),
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
                                ),
                                Container(
                                  // autogroupmtbqiv7 (NYL4ypyWT98dh8YkdnmTBq)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 16 * fem, 0 * fem, 0 * fem),
                                  width: 482 * fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // breakfastWjV (4:9)
                                        margin: EdgeInsets.fromLTRB(
                                            9 * fem, 0 * fem, 0 * fem, 3 * fem),
                                        child: Text(
                                          'Breakfast',
                                          style: SafeGoogleFont(
                                            'Inter',
                                            fontSize: 32 * ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2125 * ffem / fem,
                                            color: const Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // autogroupfrnpjcF (NYL5dUZSiZDBsjpDujFrNP)
                                        margin: EdgeInsets.fromLTRB(
                                            0 * fem, 0 * fem, 0 * fem, 1 * fem),
                                        width: double.infinity,
                                        height: 221 * fem,
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              child: Positioned(
                                                // rectangle12QCb (6:31)
                                                left: 9 * fem,
                                                top: 0 * fem,
                                                child: Align(
                                                  child: SizedBox(
                                                    width: 473 * fem,
                                                    height: 221 * fem,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(25 * fem),
                                                        color: const Color(0xffdbdfd1),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute (
                                                      builder: (BuildContext context) => RecipePage(recipe: breakfast),
                                                    ));
                                              },
                                            ),
                                            Positioned(
                                              // rectangle9dr3 (6:32)
                                              left: 0 * fem,
                                              top: 5 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 264 * fem,
                                                  height: 216 * fem,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(25 * fem),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(breakfast['image']),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              // frenchtoastpreptime15minsFMd (6:33)
                                              left: 305 * fem,
                                              top: 25 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 150 * fem,
                                                  height: 194 * fem,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: 24 * ffem,
                                                        fontWeight: FontWeight.w500,
                                                        height: 1.2125 * ffem / fem,
                                                        color: const Color(0xff000000),
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                            text:   breakfast['title'] +'\n\n'
                                                        ),
                                                        TextSpan(
                                                          text:  'Vegetarian: ' + breakfast['vegetarian'].toString() + '\n gluten free: ' + breakfast['glutenFree'].toString(),
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize: 20 * ffem,
                                                            fontWeight: FontWeight.w500,
                                                            height: 1.2125 * ffem / fem,
                                                            color: const Color(0xff000000),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //LUNCH STARTS HERE
                                      Container(
                                        // lunchGbV (4:10)
                                        margin: EdgeInsets.fromLTRB(
                                            9 * fem, 0 * fem, 0 * fem, 0 * fem),
                                        child: Text(
                                          'Lunch',
                                          style: SafeGoogleFont(
                                            'Inter',
                                            fontSize: 32 * ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2125 * ffem / fem,
                                            color: const Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // autogroup3lkv7s1 (NYL6UCfFj17XyFoay33LKV)
                                        padding: EdgeInsets.fromLTRB(
                                            0 * fem, 15 * fem, 0 * fem, 0 * fem),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // autogroupa61qQ5R (NYL5ty7dVueAEXducwA61q)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem, 0 * fem, 9 * fem, 25 * fem),
                                              padding: EdgeInsets.fromLTRB(
                                                  0 * fem, 0 * fem, 29 * fem, 0 * fem),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: const Color(0xffdbdfd1),
                                                borderRadius:
                                                BorderRadius.circular(25 * fem),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    /*child: GestureDetector (
                                                    *   onTap: () {
                                                    * Navigator.of(context).push(
                                                          MaterialPageRoute (
                                                              builder: (BuildContext context) => placeholder(),
                                                    *   }
                                                    * )*/
                                                    // rectangle10S27 (6:35)
                                                    margin: EdgeInsets.fromLTRB(0 * fem,
                                                        0 * fem, 36 * fem, 0 * fem),
                                                    width: 264 * fem,
                                                    height: 221 * fem,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(25 * fem),
                                                      image: /*const*/DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(lunch['image']),/*AssetImage(
                                                          'assets/page-1/images/rectangle-10-bg.png',*/
                                                        //),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    // turkeyclubsandwichpreptime10mi (6:36)
                                                    margin: EdgeInsets.fromLTRB(0 * fem,
                                                        11 * fem, 0 * fem, 0 * fem),
                                                    constraints: BoxConstraints(
                                                      maxWidth: 144 * fem,
                                                    ),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style: SafeGoogleFont(
                                                          'Inter',
                                                          fontSize: 24 * ffem,
                                                          fontWeight: FontWeight.w500,
                                                          height: 1.2125 * ffem / fem,
                                                          color: const Color(0xff000000),
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                            /*'Turkey Club Sandwich\n\n\n'*/lunch['title']+'\n\n',
                                                          ),
                                                          TextSpan(
                                                            text: 'Vegetarian: ' + lunch['vegetarian'].toString() + '\n gluten free: ' + lunch['glutenFree'].toString(),
                                                            style: SafeGoogleFont(
                                                              'Inter',
                                                              fontSize: 20 * ffem,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.2125 * ffem / fem,
                                                              color:
                                                              const Color(0xff000000),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //DINNER STARTS HERE
                                            Container(
                                              // dinnerSiF (4:11)
                                              margin: EdgeInsets.fromLTRB(
                                                  17 * fem, 0 * fem, 0 * fem, 17 * fem),
                                              child: Text(
                                                'Dinner',
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 32 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color: const Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // autogroupbyurKGF (NYL67o5bCaPHc7D9njBYuR)
                                              margin: EdgeInsets.fromLTRB(
                                                  9 * fem, 0 * fem, 0 * fem, 0 * fem),
                                              width: 473 * fem,
                                              height: 223 * fem,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    // rectangle14PG7 (6:38)
                                                    left: 0 * fem,
                                                    top: 0 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 473 * fem,
                                                        height: 221 * fem,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                25 * fem),
                                                            color: const Color(0xffdbdfd1),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    /*child: GestureDetector (
                                                    *   onTap: () {
                                                    * Navigator.of(context).push(
                                                          MaterialPageRoute (
                                                              builder: (BuildContext context) => placeholder(),
                                                    *   }
                                                    * )*/
                                                    // rectangle111YP (6:39)
                                                    left: 1 * fem,
                                                    top: 1 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 254 * fem,
                                                        height: 222 * fem,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                25 * fem),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: /*AssetImage(
                                                                'assets/page-1/images/rectangle-11-bg.png',
                                                              ),*/ NetworkImage(dinner['image']),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // spaghettiandmeatballspreptime2 (6:40)
                                                    left: 277 * fem,
                                                    top: 18 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 176 * fem,
                                                        height: 170 * fem,
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style: SafeGoogleFont(
                                                              'Inter',
                                                              fontSize: 24 * ffem,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.2125 * ffem / fem,
                                                              color:
                                                              const Color(0xff000000),
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                /*'Spaghetti and meatballs\n\n\n\n'*/
                                                                dinner['title']+'\n\n',
                                                              ),
                                                              TextSpan(
                                                                text: 'Vegetarian: ' + dinner['vegetarian'].toString() + '\n gluten free: ' + dinner['glutenFree'].toString(),
                                                                style: SafeGoogleFont(
                                                                  'Inter',
                                                                  fontSize: 20 * ffem,
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  height:
                                                                  1.2125 * ffem / fem,
                                                                  color: const Color(
                                                                      0xff000000),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          // autogroupumzvs6j (NYKzbcwkNdVCs7Z179uMZV)
                          left: 61 * fem,
                          top: 133 * fem,
                          child: Container(
                            width: 627 * fem,
                            height: 44 * fem,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // whatihaveinXwy (3:18)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 33 * fem, 0 * fem),
                                  child: Text(
                                    'What I have in',
                                    style: SafeGoogleFont(
                                      'Inter',
                                      fontSize: 36 * ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2125 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Text(
                                  // recommendedforyoubgw (4:3)
                                  'Recommended for you',
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 32 * ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2125 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          // circleleftHpf (4:6)
                          left: 703 * fem,
                          top: 125 * fem,
                          //to refresh recipes
                          child: GestureDetector(
                           onTap: () {
                             setState(() {
                               _allRecipes = {};
                               });
                             _fetchAllRecipes().then((recipes) {
                               setState((){
                                 _allRecipes = recipes;
                               });
                             });
                           },
                          child: Align(
                            child: SizedBox(
                              width: 53 * fem,
                              height: 65 * fem,
                              child: Image.asset(
                                'assets/page-1/images/circleleft.png',
                                width: 53 * fem,
                                height: 65 * fem,
                              ),
                            ),
                          ),
                          ),
                        ),
                        Positioned(
                          // autogrouptawovcj (NYKyuokkjHQuFmi3q4taWo)
                          left: 45 * fem,
                          top: 25 * fem,
                          child: Container(
                            width: 462 * fem,
                            height: 92 * fem,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // autogroupf9ydQXu (NYKzGo9nEvSvmovGUBf9yD)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 50 * fem, 0 * fem),
                                  padding: EdgeInsets.fromLTRB(
                                      16 * fem, 23 * fem, 16 * fem, 10 * fem),
                                  width: 206 * fem,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffdbdfd1),
                                    borderRadius: BorderRadius.circular(25 * fem),
                                  ),
                                  child: Align(
                                    // abouttoexpiredvT (6:12)
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              const AboutToExpireList()));
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 132 * fem,
                                          ),
                                          child: Text(
                                            'About to expire!',
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 24 * ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.2125 * ffem / fem,
                                              color: const Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // autogroupxfgfTPh (NYKzR3R3LMMWWgW4s3xfgf)
                                  padding: EdgeInsets.fromLTRB(
                                      26 * fem, 18 * fem, 48 * fem, 15 * fem),
                                  width: 206 * fem,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffdbdfd1),
                                    borderRadius: BorderRadius.circular(25 * fem),
                                  ),
                                  child: Center(
                                    // mygrocerylistfkf (6:13)
                                    child: SizedBox(
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(
                                              MaterialPageRoute (
                                                  builder: (BuildContext context) => const GroceryListPage()
                                              ));},
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 132 * fem,
                                          ),
                                          child: Text(
                                            'My grocery list',
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 24 * ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.2125 * ffem / fem,
                                              color: const Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          // settingfillVjh (6:18)
                          left: 756 * fem,
                          top: 11 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 71 * fem,
                              height: 64 * fem,
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/page-1/images/settingfill.png',
                                  width: 71 * fem,
                                  height: 64 * fem,
                                ),
                                padding: const EdgeInsets.all(0.0),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute (
                                      builder: (BuildContext context) => SettingsPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
      ),
    );
  }
}