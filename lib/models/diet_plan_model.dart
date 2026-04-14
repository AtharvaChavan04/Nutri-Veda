import 'package:nutri_veda/models/recipe_model.dart';

class DietPlanModel {
  final List<RecipeModel> breakfast;
  final List<RecipeModel> lunch;
  final List<RecipeModel> dinner;
  final List<RecipeModel> snacks;

  DietPlanModel({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });

  factory DietPlanModel.empty() {
    return DietPlanModel(
      breakfast: [],
      lunch: [],
      dinner: [],
      snacks: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.map((e) => e.toJson()).toList(),
      'lunch': lunch.map((e) => e.toJson()).toList(),
      'dinner': dinner.map((e) => e.toJson()).toList(),
      'snacks': snacks.map((e) => e.toJson()).toList(),
    };
  }

  factory DietPlanModel.fromJson(Map<String, dynamic> json) {
  return DietPlanModel(
    breakfast: (json['breakfast'] as List? ?? [])
        .map((e) => RecipeModel.fromJson(e))
        .toList(),
    lunch: (json['lunch'] as List? ?? [])
        .map((e) => RecipeModel.fromJson(e))
        .toList(),
    dinner: (json['dinner'] as List? ?? [])
        .map((e) => RecipeModel.fromJson(e))
        .toList(),
    snacks: (json['snacks'] as List? ?? [])
        .map((e) => RecipeModel.fromJson(e))
        .toList(),
  );
}
}
