import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> fetchRecipeData( int recipeId) async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=d06e57ea3ff9451985a6f2856e19b2b2'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load recipe data');
  }
}

Future<Map<String, dynamic>> fetchRandomRecipe() async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/random?apiKey=<d06e57ea3ff9451985a6f2856e19b2b2>'));

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
void main() {
  testFetchRandomRecipe();
}
