import 'dart:convert';
import 'package:http/http.dart' as http;


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
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/random?apiKey=cd91b9a2ae9c42f2ba4e630b74d57adf&tags=breakfast'));

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
      'https://api.spoonacular.com/recipes/random?apiKey=cd91b9a2ae9c42f2ba4e630b74d57adf&tags=lunch'));

  if (response.statusCode == 200) {
    final recipes = json.decode(response.body)['recipes'][0];
    print(recipes);
    return recipes;
  } else {
    throw Exception('Failed to load lunch recipes');
  }
}

Future<Map<String, dynamic>> fetchDinnerRecipes() async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/random?apiKey=cd91b9a2ae9c42f2ba4e630b74d57adf&tags=dinner'));

  if (response.statusCode == 200) {
    final recipes = json.decode(response.body)['recipes'][0];
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
