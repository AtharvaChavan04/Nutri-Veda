import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/models/recipe_model.dart';

class DietService {
  final String _baseUrl =
      "https://nutriveda2.app.n8n.cloud/webhook/diet-recipes"; 

  // =========================================================
  // ✅ FETCH RECIPES FROM N8N
  // =========================================================
  Future<List<RecipeModel>> fetchRecipes({
    required String mealType,
    required DoctorPatient patient,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "mealType": mealType,
          "patient": {
            "age": patient.age,
            "weight": patient.weight,
            "conditions": patient.conditions,
            "allergies": patient.allergies,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List recipesJson = data['recipes'];

        return recipesJson.map((json) {
          return RecipeModel(
            name: json['name'],
            calories: json['calories'],
            time: json['preparationTime'], // 🔥 mapping fix
            taste: [_mapTaste(json['tasteProfile'])],
            digestibility: _mapDigestibility(json['digestibility']),
          );
        }).toList();
      } else {
        throw Exception("Failed to fetch recipes");
      }
    } catch (e) {
      throw Exception("API Error: $e");
    }
  }

  // =========================================================
  // 🔥 NORMALIZATION (VERY IMPORTANT)
  // =========================================================

  String _mapTaste(String? taste) {
    if (taste == null) return "Sweet";

    taste = taste.toLowerCase();

    if (taste.contains("hot")) return "Hot";
    if (taste.contains("cold")) return "Cold";
    if (taste.contains("sour")) return "Sour";
    if (taste.contains("bitter")) return "Bitter";

    return "Sweet";
  }

  String _mapDigestibility(String? value) {
    if (value == null) return "Medium";

    value = value.toLowerCase();

    if (value.contains("easy")) return "High";
    if (value.contains("moderate")) return "Medium";

    return "Low";
  }
}
