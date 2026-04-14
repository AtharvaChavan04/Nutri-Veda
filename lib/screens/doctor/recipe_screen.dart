import 'package:flutter/material.dart';
import 'package:nutri_veda/services/recipe_service.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class RecipeScreen extends StatefulWidget {
  final String mealType;
  final String recipeName;
  final int calories;
  final String time;

  const RecipeScreen({
    super.key,
    required this.mealType,
    required this.recipeName,
    required this.calories,
    required this.time,
  });

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isLoading = true;
  final RecipeService _recipeService = RecipeService();

  List<String> ingredients = [];
  List<String> steps = [];
  String tips = "";

  @override
  void initState() {
    super.initState();
    _fetchRecipe();
  }

  Future<void> _fetchRecipe() async {
    try {
      final data = await _recipeService.fetchRecipe(
        mealType: widget.mealType,
        recipeName: widget.recipeName,
        calories: widget.calories,
        time: widget.time,
      );

      setState(() {
        ingredients = List<String>.from(data['ingredients']);
        steps = List<String>.from(data['steps']);
        tips = data['tips'] ?? "";
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Recipe"),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- TITLE ----------------
                  Text(
                    widget.recipeName,
                    style: AppTheme.lightTheme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  // ---------------- META ----------------
                  Row(
                    children: [
                      _metaChip("${widget.calories} kcal", colorScheme),
                      const SizedBox(width: 8),
                      _metaChip(widget.time, colorScheme),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ---------------- INGREDIENTS ----------------
                  _sectionCard(
                    title: "Ingredients",
                    child: Column(
                      children: ingredients.map((item) {
                        return _bulletItem(item);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---------------- STEPS ----------------
                  _sectionCard(
                    title: "Steps",
                    child: Column(
                      children: List.generate(steps.length, (index) {
                        return _stepItem(index + 1, steps[index]);
                      }),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---------------- TIPS ----------------
                  if (tips.isNotEmpty)
                    _sectionCard(
                      title: "Tips",
                      child: Text(
                        tips,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  // ---------------- META CHIP ----------------
  Widget _metaChip(String text, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ---------------- SECTION CARD ----------------
  Widget _sectionCard({required String title, required Widget child}) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // ---------------- BULLET ITEM ----------------
  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• "),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  // ---------------- STEP ITEM ----------------
  Widget _stepItem(int number, String text) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: colorScheme.primary,
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
