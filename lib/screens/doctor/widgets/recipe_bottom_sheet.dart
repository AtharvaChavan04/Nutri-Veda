import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/models/recipe_model.dart';
import 'package:nutri_veda/services/diet_chart_n8n_service.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class RecipeBottomSheet extends StatefulWidget {
  final String mealType;
  final DoctorPatient patient;

  const RecipeBottomSheet({
    super.key,
    required this.mealType,
    required this.patient,
  });

  @override
  State<RecipeBottomSheet> createState() => _RecipeBottomSheetState();
}

class _RecipeBottomSheetState extends State<RecipeBottomSheet> {
  final DietService _dietService = DietService();

  bool isLoading = true;
  List<RecipeModel> recipes = [];
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      final result = await _dietService.fetchRecipes(
        mealType: widget.mealType,
        patient: widget.patient,
      );

      setState(() {
        recipes = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 🔹 Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 🔹 Title
          Text(
            "Select ${widget.mealType} Recipes",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          // 🔹 Content
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      final isSelected = selectedIndexes.contains(index);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedIndexes.remove(index);
                            } else {
                              selectedIndexes.add(index);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary.withOpacity(0.08)
                                : colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text("${recipe.calories} kcal • ${recipe.time}"),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  _chip(recipe.taste.first, colorScheme),
                                  _chip(recipe.digestibility, colorScheme),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // 🔹 Add button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedIndexes.isEmpty
                  ? null
                  : () {
                      final selectedRecipes =
                          selectedIndexes.map((i) => recipes[i]).toList();

                      Navigator.pop(context, selectedRecipes);
                    },
              child: Text(
                "Add Selected (${selectedIndexes.length})",
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, ColorScheme colorScheme) {
    return Chip(
      label: Text(text),
      backgroundColor: colorScheme.primaryContainer,
      labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
    );
  }
}
