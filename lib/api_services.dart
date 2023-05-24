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
  // Get the list of everything in fridge and pantry
  final list = await ListItemHelper.getAllItems();

  final ingredients = list.split(',');
  // Check for recipes with ingredients in the list,
  // if none exist then fewer ingredients are given from the list
  for (int i = ingredients.length; i > 0; i--) {
    final subList = ingredients.sublist(0, i);

    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?apiKey=2d6f252163ae49dfa8887978d63c2073&ingredients=${subList.join(',')}&number=100&tags=breakfast&ranking=2'
    ));

    if (response.statusCode == 200) {
      final recipes = json.decode(response.body) as List<dynamic>;
      if (recipes.isNotEmpty) {
        final recipe = recipes[Random().nextInt(100)] as Map<String, dynamic>;

        // Get the recipe ID
        final int recipeId = recipe['id'];

        // Make an additional API call to retrieve the extended ingredients and instructions
        final extendedIngredientsResponse = await http.get(Uri.parse(
            'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=2d6f252163ae49dfa8887978d63c2073&includeNutrition=true'
        ));

        if (extendedIngredientsResponse.statusCode == 200) {
          final extendedRecipe = json.decode(extendedIngredientsResponse.body) as Map<String, dynamic>;
          final extendedIngredients = extendedRecipe['extendedIngredients'] as List<dynamic>;
          final instructions = extendedRecipe['instructions'] as String;

          // Add the extended ingredients and instructions to the recipe object
          recipe['extendedIngredients'] = extendedIngredients;
          recipe['instructions'] = instructions;

          print(recipe);
          return recipe;
        } else {
          throw Exception('Failed to load extended ingredients and instructions for the recipe');
        }
      }
    } else {
      throw Exception('Failed to load recipe');
    }
  }
  throw Exception('No recipe found using the specified ingredients');
}


Future<Map<String, dynamic>> fetchLunchRecipes() async {
  // Get the list of everything in fridge and pantry
  final list = await ListItemHelper.getAllItems();

  final ingredients = list.split(',');
  // Check for recipes with ingredients in the list,
  // if none exist then fewer ingredients are given from the list
  for (int i = ingredients.length; i > 0; i--) {
    final subList = ingredients.sublist(0, i);

    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?apiKey=2d6f252163ae49dfa8887978d63c2073&ingredients=${subList.join(',')}&number=100&tags=lunch&ranking=2'
    ));

    if (response.statusCode == 200) {
      final recipes = json.decode(response.body) as List<dynamic>;
      if (recipes.isNotEmpty) {
        final recipe = recipes[Random().nextInt(100)] as Map<String, dynamic>;

        // Get the recipe ID
        final int recipeId = recipe['id'];

        // Make an additional API call to retrieve the extended ingredients
        final extendedIngredientsResponse = await http.get(Uri.parse(
            'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=2d6f252163ae49dfa8887978d63c2073&includeNutrition=true'
        ));

        if (extendedIngredientsResponse.statusCode == 200) {
          final extendedRecipe = json.decode(extendedIngredientsResponse.body) as Map<String, dynamic>;
          final extendedIngredients = extendedRecipe['extendedIngredients'] as List<dynamic>;
          final instructions = extendedRecipe['instructions'] as String;
          // Add the extended ingredients to the recipe object
          recipe['extendedIngredients'] = extendedIngredients;
          recipe['instructions'] = instructions;
          print(recipe);
          return recipe;
        } else {
          throw Exception('Failed to load extended ingredients for the recipe');
        }
      }
    } else {
      throw Exception('Failed to load recipe');
    }
  }
  throw Exception('No recipe found using the specified ingredients');
}

Future<Map<String, dynamic>> fetchDinnerRecipes() async {
  // Get the list of everything in fridge and pantry
  final list = await ListItemHelper.getAllItems();

  final ingredients = list.split(',');
  // Check for recipes with ingredients in the list,
  // if none exist then fewer ingredients are given from the list
  for (int i = ingredients.length; i > 0; i--) {
    final subList = ingredients.sublist(0, i);

    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?apiKey=2d6f252163ae49dfa8887978d63c2073&ingredients=${subList.join(',')}&number=100&tags=dinner&ranking=2'
    ));

    if (response.statusCode == 200) {
      final recipes = json.decode(response.body) as List<dynamic>;
      if (recipes.isNotEmpty) {
        final recipe = recipes[Random().nextInt(100)] as Map<String, dynamic>;

        // Get the recipe ID
        final int recipeId = recipe['id'];

        // Make an additional API call to retrieve the extended ingredients
        final extendedIngredientsResponse = await http.get(Uri.parse(
            'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=2d6f252163ae49dfa8887978d63c2073&includeNutrition=true'
        ));

        if (extendedIngredientsResponse.statusCode == 200) {
          final extendedRecipe = json.decode(extendedIngredientsResponse.body) as Map<String, dynamic>;
          final extendedIngredients = extendedRecipe['extendedIngredients'] as List<dynamic>;
          final instructions = extendedRecipe['instructions'] as String;
          // Add the extended ingredients to the recipe object
          recipe['extendedIngredients'] = extendedIngredients;
          recipe['instructions'] = instructions;
          print(recipe);
          return recipe;
        } else {
          throw Exception('Failed to load extended ingredients for the recipe');
        }
      }
    } else {
      throw Exception('Failed to load recipe');
    }
  }
  throw Exception('No recipe found using the specified ingredients');
}


/*void testFetchRandomRecipe() async {
  try {
    final recipe = await fetchBreakfastRecipe();
    print(recipe);
  } catch (e) {
    print('Error: $e');
  }
}*/

