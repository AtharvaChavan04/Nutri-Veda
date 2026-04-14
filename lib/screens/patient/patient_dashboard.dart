import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:nutri_veda/utils/appTheme/app_theme.dart';
import 'patient_dashboard_tab.dart';
import 'patient_profile_screen.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 HEADER WITH NAME
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('patients')
                  .where(
                    'email',
                    isEqualTo:
                        FirebaseAuth.instance.currentUser!.email!.toLowerCase(),
                  )
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                String name = "User";

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final data = snapshot.data!.docs.first.data();
                  name = data['name'] ?? "User";
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 DYNAMIC NAME HERE
                      Text(
                        "Welcome, $name 👋",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Your Health Dashboard",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🔥 TAB BAR
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelColor: colorScheme.primary,
                          unselectedLabelColor: Colors.white70,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: const [
                            Tab(text: "Dashboard"),
                            Tab(text: "Profile"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // 🔥 CONTENT
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  PatientDashboardTab(),
                  PatientProfile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
