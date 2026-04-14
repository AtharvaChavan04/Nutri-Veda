import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_veda/models/diet_chart_model.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/screens/doctor/recipe_screen.dart';
import 'package:nutri_veda/services/diet_chart_firestore_service.dart';
import 'package:nutri_veda/services/pdf_service.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class DietChartScreen extends StatefulWidget {
  final String dietChartId;
  final DoctorPatient patient;

  const DietChartScreen({
    super.key,
    required this.dietChartId,
    required this.patient,
  });

  @override
  State<DietChartScreen> createState() => _DietChartScreenState();
}

class _DietChartScreenState extends State<DietChartScreen> {
  final DietChartService _dietChartService = DietChartService();
  String doctorName = "Doctor";

  DietChart? dietChart;
  bool isLoading = true;

  Future<void> _fetchDoctorName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        setState(() {
          doctorName = doc.data()?['fullName'] ?? "Doctor";
        });
      }
    } catch (e) {
      print("Error fetching doctor name: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDiet();
    _fetchDoctorName();
  }

  Future<void> _fetchDiet() async {
    try {
      final result =
          await _dietChartService.getDietChartById(widget.dietChartId);

      setState(() {
        dietChart = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Diet Chart"),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dietChart == null
              ? const Center(child: Text("No diet found"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildMealSection(
                        "Breakfast",
                        dietChart!.dietPlan.breakfast,
                        colorScheme,
                      ),
                      _buildMealSection(
                        "Lunch",
                        dietChart!.dietPlan.lunch,
                        colorScheme,
                      ),
                      _buildMealSection(
                        "Dinner",
                        dietChart!.dietPlan.dinner,
                        colorScheme,
                      ),
                      _buildMealSection(
                        "Snacks",
                        dietChart!.dietPlan.snacks,
                        colorScheme,
                      ),

                      const SizedBox(height: 20),

                      // ---------------- PDF BUTTON ----------------
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (dietChart == null) return;

                            final pdfService = PdfService();
                            await pdfService.generateAndPrintDietChart(
                              chart: dietChart!,
                              patient: widget.patient,
                              doctorName: doctorName,
                            );
                          },
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                          ),
                          label: const Text("Print / Export PDF"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // ---------------- MEAL SECTION ----------------
  Widget _buildMealSection(
      String title, List recipes, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
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
          if (recipes.isEmpty)
            Text(
              "No items",
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            )
          else
            Column(
              children: recipes.map<Widget>((recipe) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeScreen(
                          mealType: title, // Breakfast / Lunch / etc
                          recipeName: recipe.name,
                          calories: recipe.calories,
                          time: recipe.time,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("${recipe.calories} kcal • ${recipe.time}"),
                        const SizedBox(height: 6),
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
              }).toList(),
            )
        ],
      ),
    );
  }

  Widget _chip(String text, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
