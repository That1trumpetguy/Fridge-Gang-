import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchRecipeData(String apiKey, int recipeId) async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load recipe data');
  }
}
Future<Map<String, dynamic>> fetchRandomRecipe() async {
  final response = await http.get(Uri.parse(
      'https://api.spoonacular.com/recipes/random?apiKey=<c6ffa181d6d044d59f1076d9e79bf391>&tags=breakfast'));

  if (response.statusCode == 200) {

      return json.decode(response.body)['recipes'][0];

  } else {
    throw Exception('Failed to load recipe');
  }
}


void main() async {
  final apiKey = 'YOUR_API_KEY_HERE';
  final recipeId = 12345;
  final recipeData = await fetchRecipeData(apiKey, recipeId);
  print(recipeData);
}