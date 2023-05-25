import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  final Map<String, dynamic> recipe;
  RecipePage({Key? key, required this.recipe}) : super(key: key);
  String imageName = '';

  String formatInstructions(String instructions) {
    if (instructions == null || instructions.isEmpty) {
      return '';
    }

    // Remove <ol> and </ol> tags
    instructions = instructions.replaceAll('<ol>', '');
    instructions = instructions.replaceAll('</ol>', '');

    // Replace <li> tags with line breaks
    instructions = instructions.replaceAll('<li>', '\n');

    // Remove any remaining HTML tags
    instructions = instructions.replaceAll(RegExp(r'<[^>]+>'), '');

    // Add a space after each period not followed by a number or acronym
    final formattedText = instructions.replaceAllMapped(
      RegExp(r'\.(?![0-9]| [A-Z])'), // Matches periods not followed by a number or acronym
          (match) => '. ', // Adds a space after the period
    );

    // Add line breaks after each sentence
    final sentences = formattedText.split('. ');
    final formattedSentences = sentences.map((sentence) => '$sentence.\n').toList();

    return formattedSentences.join();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
              width: screenWidth * 0.1,
              height: screenHeight * 0.225,
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: NetworkImage(recipe['image']),
                  fit: BoxFit.fitHeight
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Ingredients', style: TextStyle(fontSize: screenWidth * 0.05),),
            ),
            SizedBox(
              height: screenHeight * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipe['extendedIngredients']?.length ?? 0,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: Container(
                    width: screenWidth * .20,
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
                                  recipe['extendedIngredients'][index]['name'],style: TextStyle(fontSize: screenWidth * 0.03),)
                  )
                      ]
                ),
              ),
                ),
                  ),

            ),
            Padding(
              padding: EdgeInsets.all(screenHeight * 0.005),
              child: Text('Instructions', style: TextStyle(fontSize: screenWidth * 0.05),),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.6, // Adjust the value as needed
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.005, 0, screenWidth * 0.005, 0),
                  child: Text(
                    formatInstructions(recipe['instructions'] ?? ''),
                    style: TextStyle(fontSize: screenWidth * 0.03),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
