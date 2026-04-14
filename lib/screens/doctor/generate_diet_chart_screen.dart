import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutri_veda/models/diet_chart_model.dart';
import 'package:nutri_veda/models/diet_plan_model.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/models/recipe_model.dart';
import 'package:nutri_veda/screens/doctor/widgets/recipe_bottom_sheet.dart';
import 'package:nutri_veda/services/diet_chart_firestore_service.dart';
import 'package:nutri_veda/services/patient_service.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class GenerateDietChartScreen extends StatefulWidget {
  final DoctorPatient? patient;

  const GenerateDietChartScreen({super.key, this.patient});

  @override
  State<GenerateDietChartScreen> createState() =>
      _GenerateDietChartScreenState();
}

class _GenerateDietChartScreenState extends State<GenerateDietChartScreen> {
  DoctorPatient? selectedPatient;

  String selectedMeal = 'Breakfast';

  final List<String> meals = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  final Map<String, List<RecipeModel>> mealPlans = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': [],
  };

  final PatientService _patientService = PatientService();
  final DietChartService _dietChartService = DietChartService();

  @override
  void initState() {
    super.initState();
    selectedPatient = widget.patient;
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser!.uid;
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Create Diet Chart"),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // ---------------- PATIENT SECTION ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: selectedPatient == null
                ? _buildPatientSelector(colorScheme, doctorId)
                : _buildSelectedPatientCard(colorScheme),
          ),

          const SizedBox(height: 12),

          // ---------------- MEAL TABS ----------------
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                final isSelected = meal == selectedMeal;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMeal = meal;
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        meal,
                        style: TextStyle(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ---------------- RECIPES ----------------
          Expanded(
            child: Column(
              children: [
                // ---------------- RECIPES ----------------
                Expanded(
                  child: mealPlans[selectedMeal]!.isEmpty
                      ? _buildEmptyState()
                      : _buildRecipeList(colorScheme),
                ),

                // ---------------- ADD BUTTON (ALWAYS VISIBLE) ----------------
              ],
            ),
          ),

          // ---------------- SAVE BUTTON ----------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: selectedPatient == null ? null : _saveDietChart,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: selectedPatient == null
                    ? colorScheme.onSurface.withValues(alpha: 0.3)
                    : colorScheme.primary,
              ),
              child: Text(
                "Save Diet Chart",
                style: TextStyle(
                  color: selectedPatient == null
                      ? colorScheme.onSurface.withValues(alpha: 0.5)
                      : colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PATIENT SELECTOR ----------------
  Widget _buildPatientSelector(ColorScheme colorScheme, String doctorId) {
    return GestureDetector(
      onTap: () => _openPatientSelector(doctorId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Select Patient",
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down,
                color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  // ---------------- PATIENT CARD ----------------
  Widget _buildSelectedPatientCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.person, size: 32, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Creating diet chart for",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedPatient!.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedPatient = null;
              });
            },
            child: Text(
              "Change",
              style: TextStyle(color: colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }

  // ---------------- SAVE DIET CHART ----------------
  Future<void> _saveDietChart() async {
    if (selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select patient first")),
      );
      return;
    }

    // 🔥 Check if at least one meal has recipes
    final hasAnyRecipe = mealPlans.values.any((list) => list.isNotEmpty);

    if (!hasAnyRecipe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add at least one recipe")),
      );
      return;
    }

    try {
      final doctorId = FirebaseAuth.instance.currentUser!.uid;

      // 🔥 Create DietChart object
      final dietChart = DietChart(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: selectedPatient!.id,
        patientEmail: selectedPatient!.email.toLowerCase(),
        doctorId: doctorId,
        createdAt: DateTime.now(),
        dietPlan: DietPlanModel(
          breakfast: mealPlans['Breakfast'] ?? [],
          lunch: mealPlans['Lunch'] ?? [],
          dinner: mealPlans['Dinner'] ?? [],
          snacks: mealPlans['Snacks'] ?? [],
        ),
      );

      // 🔥 Save to Firestore
      await _dietChartService.saveDietChart(dietChart);

      // 🔥 Update patient
      final updatedPatient = selectedPatient!.copyWith(
        hasDietChart: true,
        dietChartId: dietChart.id,
        dietChartGeneratedAt: DateTime.now(),
      );

      await _patientService.updatePatient(updatedPatient);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diet chart saved successfully")),
      );

      Navigator.pop(context, updatedPatient);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // ---------------- PATIENT BOTTOM SHEET ----------------
  void _openPatientSelector(String doctorId) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StreamBuilder<List<DoctorPatient>>(
          stream: _patientService.getPatients(doctorId),
          builder: (context, snapshot) {
            final patients = snapshot.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];

                return ListTile(
                  title: Text(patient.name),
                  onTap: () {
                    setState(() {
                      selectedPatient = patient;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // ---------------- EMPTY ----------------
  Widget _buildEmptyState() {
    return Center(
      child: GestureDetector(
        onTap: _onAddRecipe,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_circle_outline, size: 50),
            SizedBox(height: 10),
            Text("Add Recipe"),
          ],
        ),
      ),
    );
  }

  // ---------------- RECIPES ----------------
  Widget _buildRecipeList(ColorScheme colorScheme) {
    final recipes = mealPlans[selectedMeal]!;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipes.length + 1,
      itemBuilder: (context, index) {
        // ---------------- ADD BUTTON AT END ----------------
        if (index == recipes.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: GestureDetector(
              onTap: _onAddRecipe,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary),
                ),
                child: Center(
                  child: Text(
                    "Add More",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // ---------------- RECIPE CARD ----------------
        final recipe = recipes[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              )
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String text, ColorScheme colorScheme) {
    return Chip(
      label: Text(text),
      backgroundColor: colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }

  // ---------------- ADD RECIPE ----------------
  void _onAddRecipe() async {
    if (selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select patient first")),
      );
      return;
    }

    final selectedRecipes = await showModalBottomSheet<List<RecipeModel>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => RecipeBottomSheet(
        mealType: selectedMeal,
        patient: selectedPatient!,
      ),
    );

    if (selectedRecipes != null && selectedRecipes.isNotEmpty) {
      setState(() {
        mealPlans[selectedMeal]!.addAll(selectedRecipes);
      });
    }
  }
}
