import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/helpers/ListItemHelper.dart';
import 'dart:math';
Future<Map<String, dynamic>> fetchRecipeData( int recipeId) async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=ad3b706596fe4906afa0e9c75935188b'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load recipe data');
  }
}

Future<Map<String, dynamic>> fetchBreakfastRecipe() async {
  //get the list of everything in fridge and pantry
  final list = await ListItemHelper.getAllItems('me');


  //final response = await http.get(Uri.parse(

  //'https://api.spoonacular.com/recipes/random?apiKey=70e019e65fcf400a8155759bf6396c82&tags=breakfast'));

  final ingredients = list.split(',');
  // checks for recipies with ingredients in list,
  // if none exist then less ingridients are given from list
  for (int i = ingredients.length; i > 0; i--) {
    final subList = ingredients.sublist(0, i);

    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?apiKey=70e019e65fcf400a8155759bf6396c82&ingredients=${subList.join(',')}&number=100&tags=breakfast&ranking=2'
    ));
    Random random = Random();
    if (response.statusCode == 200) {
      final recipes = json.decode(response.body) as List<dynamic>;
      if (recipes.isNotEmpty) {
        final recipe = recipes[random.nextInt(100)];
        print(recipe);
        return recipe;
      }
    } else {
      throw Exception('Failed to load recipe');
    }
  }
  throw Exception('No recipe found using the specified ingredients');
}

Future<Map<String, dynamic>> fetchLunchRecipes() async {
//get the list of everything in fridge and pantry
  final list = await ListItemHelper.getAllItems('me');
  print(list);

  final ingredients = list.split(',');
  // checks for recipies with ingredients in list,
  // if none exist then less ingridients are given from list
  for (int i = ingredients.length; i > 0; i--) {
    final subList = ingredients.sublist(0, i);

    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?apiKey=70e019e65fcf400a8155759bf6396c82&ingredients=${subList.join(',')}&number=100&tags=lunch&ranking=2'
    ));
    Random random = Random();

    if (response.statusCode == 200) {
      final recipes = json.decode(response.body) as List<dynamic>;
      if (recipes.isNotEmpty) {
        final recipe = recipes[random.nextInt(100)];
        print(recipe);
        return recipe;
      }
    } else {
      throw Exception('Failed to load recipe');
    }
  }
  throw Exception('No recipe found using the specified ingredients');
}

Future<Map<String, dynamic>> fetchDinnerRecipes() async {
    //get the list of everything in fridge and pantry
    final list = await ListItemHelper.getAllItems('me');
    print(list);

    final ingredients = list.split(',');
    // checks for recipies with ingredients in list,
    // if none exist then less ingridients are given from list
    for (int i = ingredients.length; i > 0; i--) {
      final subList = ingredients.sublist(0, i);

      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/findByIngredients?apiKey=70e019e65fcf400a8155759bf6396c82&ingredients=${subList.join(',')}&number=100&tags=dinner&ranking=2'
      ));
      Random random = Random();
      if (response.statusCode == 200) {
        final recipes = json.decode(response.body) as List<dynamic>;
        if (recipes.isNotEmpty) {
          final recipe = recipes[random.nextInt(100)];
          print(recipe);
          return recipe;
        }
      } else {
        throw Exception('Failed to load recipe');
      }
    }
    throw Exception('No recipe found using the specified ingredients');


}


void testFetchRandomRecipe() async {
  try {
    final recipe = await fetchBreakfastRecipe();
    print(recipe);
  } catch (e) {
    print('Error: $e');
  }
}

