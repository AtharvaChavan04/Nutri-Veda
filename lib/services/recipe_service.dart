import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeService {
  final String url =
      "https://nutriveda2.app.n8n.cloud/webhook/diet-recipe-webhook";

  Future<Map<String, dynamic>> fetchRecipe({
    required String mealType,
    required String recipeName,
    required int calories,
    required String time,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "mealType": mealType,
        "recipeName": recipeName,
        "calories": calories,
        "time": time,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 🔥 Handle your current structure
      return data;
    } else {
      throw Exception("Failed to load recipe");
    }
  }
}