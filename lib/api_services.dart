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

Future<Map<String, dynamic>> fetchRandomRecipe() async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/random?apiKey=2050d2039ea145d2bace74820055e741'));

  if (response.statusCode == 200) {
    final recipe = json.decode(response.body)['recipes'][0];
    print(recipe);
    return recipe;
  } else {
    throw Exception('Failed to load recipe');
  }
}

void testFetchRandomRecipe() async {
  try {
    final recipe = await fetchRandomRecipe();
    print(recipe);
  } catch (e) {
    print('Error: $e');
  }
}
//void main() {
 // testFetchRandomRecipe();
//}
