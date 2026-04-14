import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/models/doctor_user_model.dart';
import 'package:nutri_veda/screens/doctor/add_patient_screen.dart';
import 'package:nutri_veda/screens/doctor/doctor_profile_screen.dart';
import 'package:nutri_veda/screens/doctor/generate_diet_chart_screen.dart';
import 'package:nutri_veda/screens/doctor/patients_list_screen.dart';
import 'package:nutri_veda/screens/doctor/widgets/greeting_section.dart';
import 'package:nutri_veda/screens/doctor/widgets/patients_awaiting_section.dart';
import 'package:nutri_veda/screens/doctor/widgets/quick_action_section.dart';
import 'package:nutri_veda/services/patient_service.dart'; // ✅ ADD THIS
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class DoctorDashboard extends StatefulWidget {
  final UserModel currentUser;
  const DoctorDashboard({super.key, required this.currentUser});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final PatientService _patientService = PatientService(); // ✅ ADD

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                indicatorColor: AppTheme.lightTheme.colorScheme.primary,
                labelColor: AppTheme.lightTheme.colorScheme.primary,
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Patients'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ---------------- DASHBOARD TAB ----------------
                  StreamBuilder<List<DoctorPatient>>(
                    stream: _patientService.getPatients(widget.currentUser.uid),
                    builder: (context, snapshot) {
                      // ✅ LOADING
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // ✅ DATA
                      final patients = snapshot.data ?? [];

                      // ✅ DERIVED DATA (same as your mock logic)
                      final awaitingPatients =
                          patients.where((p) => !p.hasDietChart).toList();

                      final totalPatients = patients.length;

                      final totalDietPlans =
                          patients.where((p) => p.hasDietChart).length;

                      // ---------------- YOUR ORIGINAL UI (UNCHANGED) ----------------
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Greeting Section
                            GreetingSection(
                              doctorName: widget.currentUser.fullName,
                            ),

                            const SizedBox(height: 10),

                            // Section 2: Patients Awaiting Diet Chart
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: PatientsAwaitingSection(
                                patients: awaitingPatients, // ✅ UPDATED
                                totalPatientsCount: totalPatients, // ✅ UPDATED
                                onAddPatient: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddPatientScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ---------------- SECTION 3: PATIENT OVERVIEW ----------------
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Patient Overview',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      // TOTAL PATIENTS
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .lightTheme.colorScheme.surface,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.lightTheme
                                                    .colorScheme.shadow
                                                    .withValues(alpha: 0.05),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.primary
                                                      .withValues(alpha: 0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Icon(
                                                  Icons.people,
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.primary,
                                                  size: 22,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                '$totalPatients', // ✅ UPDATED
                                                style: AppTheme.lightTheme
                                                    .textTheme.headlineMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Total Patients',
                                                style: AppTheme.lightTheme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      // TOTAL DIET PLANS
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .lightTheme.colorScheme.surface,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.lightTheme
                                                    .colorScheme.shadow
                                                    .withValues(alpha: 0.05),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .primaryContainer
                                                      .withValues(alpha: 0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Icon(
                                                  Icons.restaurant_menu,
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.onPrimary
                                                      .withValues(alpha: 0.88),
                                                  size: 22,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                '$totalDietPlans', // ✅ UPDATED
                                                style: AppTheme.lightTheme
                                                    .textTheme.headlineMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Diet Plans',
                                                style: AppTheme.lightTheme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Quick Actions
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: QuickActionsSection(
                                onAddPatient: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddPatientScreen(),
                                    ),
                                  );
                                },
                                onCreateDietChart: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const GenerateDietChartScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  ),

                  // ---------------- PATIENTS TAB ----------------
                  Scaffold(
                    backgroundColor:
                        AppTheme.lightTheme.scaffoldBackgroundColor,
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.groups_rounded,
                              size: 80,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            Text(
                              'Patients',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Manage your patient list here',
                              textAlign: TextAlign.center,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: 180,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PatientsListScreen(
                                        doctorId: widget.currentUser.uid,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'View Patient List',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ---------------- PROFILE TAB ----------------
                  const DoctorProfileScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
