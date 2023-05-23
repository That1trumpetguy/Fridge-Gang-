import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  final Map<String, dynamic> recipe;
  RecipePage({Key? key, required this.recipe}) : super(key: key);
  String imageName = '';

  @override
  Widget build(BuildContext context) {
    print(jsonEncode(recipe));
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 100,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: NetworkImage(recipe['image']),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Ingredients', style: TextStyle(fontSize: 32),),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipe['extendedIngredients']?.length ?? 0,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: Container(
                    width: 150,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Center(child: Image.network('https://spoonacular.com/cdn/ingredients_100x100/' + recipe['extendedIngredients'][index]['image']
                              ),
                              ),
                            ),
                            Center(child: Text(
                              recipe['extendedIngredients'][index]['measures']['us']['amount'].toString() + ' ' +
                                  recipe['extendedIngredients'][index]['measures']['us']['unitShort']  + ' ' +
                                  recipe['extendedIngredients'][index]['name'],style: TextStyle(fontSize: 15),)
                  )
                      ]
                ),
              ),
                ),
                  ),

            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Instructions', style: TextStyle(fontSize: 32),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(recipe['instructions'] ?? '', style: TextStyle(fontSize: 16)),
            ),


          ],
        ),
      ),
    );
  }
}
