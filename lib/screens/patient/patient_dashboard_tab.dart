import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_veda/screens/doctor/recipe_screen.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class PatientDashboardTab extends StatelessWidget {
  const PatientDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser!.email!.toLowerCase();

    final colorScheme = AppTheme.lightTheme.colorScheme;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('diet_charts') // ✅ correct collection
          .where('patientEmail', isEqualTo: email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No diet assigned yet"));
        }

        final data = snapshot.data!.docs.first.data();
        final diet = data['dietPlan'];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔥 HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.restaurant_menu, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Diet Plan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Follow consistently for best results",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 MEALS
              _mealCard("Breakfast", "🍳", diet['breakfast'], context),
              _mealCard("Lunch", "🍛", diet['lunch'], context),
              _mealCard("Dinner", "🍲", diet['dinner'], context),
              _mealCard("Snacks", "🍎", diet['snacks'], context),
            ],
          ),
        );
      },
    );
  }

  // 🔥 MEAL CARD WITH NAVIGATION
  Widget _mealCard(
      String title, String emoji, List items, BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        children: items.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("No items added"),
                )
              ]
            : items.map<Widget>((e) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeScreen(
                          mealType: title,
                          recipeName: e['name'],
                          calories: e['calories'],
                          time: e['time'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['name'] ?? "No name",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${e['calories'] ?? 0} kcal • ${e['time'] ?? ''}",
                        ),
                        const SizedBox(height: 6),

                        // 🔥 OPTIONAL CHIPS
                        if (e['taste'] != null || e['digestibility'] != null)
                          Wrap(
                            spacing: 8,
                            children: [
                              if (e['taste'] != null)
                                _chip(e['taste'][0], colorScheme),
                              if (e['digestibility'] != null)
                                _chip(e['digestibility'], colorScheme),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
      ),
    );
  }

  // 🔥 CHIP UI
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
