import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> fetchRecipeData( int recipeId) async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=2050d2039ea145d2bace74820055e741'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load recipe data');
  }
}

Future<Map<String, dynamic>> fetchBreakfastRecipe() async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/random?apiKey=2050d2039ea145d2bace74820055e741&tags=breakfast'));

  if (response.statusCode == 200) {
    final recipe = json.decode(response.body)['recipes'][0];
    print(recipe);
    return recipe;
  } else {
    throw Exception('Failed to load recipe');
  }
}
Future<Map<String, dynamic>> fetchLunchRecipes() async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/random?apiKey=2050d2039ea145d2bace74820055e741&tags=lunch'));

  if (response.statusCode == 200) {
    final recipes = json.decode(response.body)['recipes'];
    print(recipes);
    return recipes;
  } else {
    throw Exception('Failed to load lunch recipes');
  }
}

Future<Map<String, dynamic>> fetchDinnerRecipes() async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/random?apiKey=2050d2039ea145d2bace74820055e741&tags=dinner'));

  if (response.statusCode == 200) {
    final recipes = json.decode(response.body)['recipes'];
    print(recipes);
    return recipes;
  } else {
    throw Exception('Failed to load dinner recipes');
  }
}


void testFetchRandomRecipe() async {
  try {
    final recipe = await fetchBreakfastRecipe();
    print(recipe);
  } catch (e) {
    print('Error: $e');
  }
}
//void main() {
 // testFetchRandomRecipe();
//}
