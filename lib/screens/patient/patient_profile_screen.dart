import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_veda/screens/auth/login_screen.dart';
import 'package:nutri_veda/services/auth_services.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser!.email!.toLowerCase();

    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .where('email', isEqualTo: email)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Profile not found"));
          }

          final data = snapshot.data!.docs.first.data();

          final weight = data['weight'] ?? 0;
          final height = data['height'] ?? 0;

          double bmi = 0;
          if (height != 0) {
            final h = height / 100;
            bmi = weight / (h * h);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 HEADER
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          data['name'][0],
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'],
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${data['age']} yrs • ${data['gender']}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                      color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Blood Group: ${data['bloodGroup']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔥 HEALTH OVERVIEW
                Text(
                  'Health Overview',
                  style: AppTheme.lightTheme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                _card(
                  child: Column(
                    children: [
                      _infoRow('Weight', '$weight kg'),
                      _infoRow('Height', '$height cm'),
                      _infoRow('BMI', bmi.toStringAsFixed(1)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔥 CONDITIONS
                _chipSection(
                  title: 'Medical Conditions',
                  items: List<String>.from(data['conditions'] ?? []),
                  color: colorScheme.primary,
                ),

                const SizedBox(height: 24),

                // 🔥 ALLERGIES
                _chipSection(
                  title: 'Allergies',
                  items: List<String>.from(data['allergies'] ?? []),
                  color: colorScheme.error,
                ),

                const SizedBox(height: 24),

                // 🔥 CONTACT
                Text(
                  'Contact Details',
                  style: AppTheme.lightTheme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                _card(
                  child: Column(
                    children: [
                      _infoRow('Email', data['email']),
                      _infoRow('Contact', data['contactNumber']),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔥 LOGOUT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService().logout();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Logout"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- COMMON WIDGETS ----------------

  Widget _card({required Widget child}) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Material(
      elevation: 4,
      shadowColor: colorScheme.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      color: colorScheme.surface,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outline),
        ),
        child: child,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _chipSection({
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTheme.lightTheme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _card(
          child: items.isEmpty
              ? const Text("None")
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
