import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/models/user_model.dart';
import 'package:nutri_veda/screens/doctor/patients_list_screen.dart';
import 'package:nutri_veda/screens/doctor/widgets/greeting_section.dart';
import 'package:nutri_veda/screens/doctor/widgets/patients_awaiting_section.dart';
import 'package:nutri_veda/screens/doctor/widgets/quick_action_section.dart';
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

  List<DoctorPatient> get _mockPatients => [
        DoctorPatient(
          id: '1',
          doctorId: 'doctor_1',
          name: 'Sarah Johnson',
          age: 35,
          gender: 'Female',
          weight: 68.5,
          height: 165.0,
          bloodGroup: 'A+',
          email: 'sarah@example.com',
          contactNumber: '9876543210',
          conditions: ['Diabetes', 'Hypertension'],
          allergies: ['None'],
          goals: ['Weight management', 'Blood sugar control'],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          hasDietChart: true,
        ),
        DoctorPatient(
          id: '2',
          doctorId: 'doctor_1',
          name: 'Michael Chen',
          age: 42,
          gender: 'Male',
          weight: 85.0,
          height: 178.0,
          bloodGroup: 'O+',
          email: 'michael@example.com',
          contactNumber: '9123456780',
          conditions: ['PCOS', 'Thyroid'],
          allergies: ['Dairy', 'Gluten'],
          goals: ['Hormone balance', 'Weight loss'],
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          hasDietChart: true,
        ),
        DoctorPatient(
          id: '3',
          doctorId: 'doctor_1',
          name: 'Emily Rodriguez',
          age: 28,
          gender: 'Female',
          weight: 62.0,
          height: 160.0,
          bloodGroup: 'B+',
          email: 'emily@example.com',
          contactNumber: '9012345678',
          conditions: ['High Cholesterol'],
          allergies: ['Shellfish'],
          goals: ['Cholesterol management', 'Healthy eating'],
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          hasDietChart: true,
        ),
        DoctorPatient(
          id: '4',
          doctorId: 'doctor_1',
          name: 'David Wilson',
          age: 55,
          gender: 'Male',
          weight: 92.0,
          height: 182.0,
          bloodGroup: 'AB+',
          email: 'david@example.com',
          contactNumber: '9988776655',
          conditions: ['Type 2 Diabetes', 'Obesity'],
          allergies: ['Penicillin'],
          goals: ['Weight loss', 'Blood sugar control'],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          hasDietChart: true,
        ),
        DoctorPatient(
          id: '5',
          doctorId: 'doctor_1',
          name: 'Priya Patel',
          age: 31,
          gender: 'Female',
          weight: 58.0,
          height: 155.0,
          bloodGroup: 'A-',
          email: 'priya@example.com',
          contactNumber: '9765432109',
          conditions: ['Anemia', 'Vitamin D Deficiency'],
          allergies: ['Nuts'],
          goals: ['Increase hemoglobin', 'Weight gain'],
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
          hasDietChart: true,
        ),
        DoctorPatient(
          id: '6',
          doctorId: 'doctor_1',
          name: 'John Smith',
          age: 45,
          gender: 'Male',
          weight: 80.0,
          height: 175.0,
          bloodGroup: 'O-',
          email: 'john@example.com',
          contactNumber: '9345678123',
          conditions: ['Hypertension'],
          allergies: ['None'],
          goals: ['Blood pressure control', 'Healthy eating'],
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
          hasDietChart: false,
        ),
        DoctorPatient(
          id: '7',
          doctorId: 'doctor_1',
          name: 'Anjali Mehta',
          age: 29,
          gender: 'Female',
          weight: 54.0,
          height: 162.0,
          bloodGroup: 'B+',
          email: 'anjali@example.com',
          contactNumber: '9090909090',
          conditions: ['PCOS'],
          allergies: ['Seafood'],
          goals: ['Hormonal balance', 'Weight management'],
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
          hasDietChart: false,
        ),
        DoctorPatient(
          id: '8',
          doctorId: 'doctor_1',
          name: 'Rahul Verma',
          age: 50,
          gender: 'Male',
          weight: 88.0,
          height: 170.0,
          bloodGroup: 'A+',
          email: 'rahul@example.com',
          contactNumber: '9811122233',
          conditions: ['Type 2 Diabetes', 'High Cholesterol'],
          allergies: ['None'],
          goals: ['Reduce sugar levels', 'Improve heart health'],
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
          hasDietChart: true,
        ),
        DoctorPatient(
          id: '9',
          doctorId: 'doctor_1',
          name: 'Sneha Kapoor',
          age: 33,
          gender: 'Female',
          weight: 60.0,
          height: 158.0,
          bloodGroup: 'O+',
          email: 'sneha@example.com',
          contactNumber: '9870011223',
          conditions: ['Anxiety', 'Vitamin B12 Deficiency'],
          allergies: ['Gluten'],
          goals: ['Improve energy levels', 'Balanced nutrition'],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          hasDietChart: false,
        ),
        DoctorPatient(
          id: '10',
          doctorId: 'doctor_1',
          name: 'Arjun Nair',
          age: 38,
          gender: 'Male',
          weight: 76.5,
          height: 172.0,
          bloodGroup: 'AB-',
          email: 'arjun@example.com',
          contactNumber: '9001122334',
          conditions: ['Fatty Liver'],
          allergies: ['Peanuts'],
          goals: ['Liver detox', 'Weight loss'],
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          hasDietChart: false,
        ),
      ];

  List<DoctorPatient> get _awaitingPatients =>
      _mockPatients.where((p) => !p.hasDietChart).toList();

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
                  SingleChildScrollView(
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PatientsAwaitingSection(
                            patients: _awaitingPatients,
                            totalPatientsCount: _mockPatients.length,
                            onAddPatient: () {
                              // TODO: Navigate to patient's screen
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ---------------- SECTION 3: PATIENT OVERVIEW ----------------
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Patient Overview',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  // ---------------- TOTAL PATIENTS CARD ----------------
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme
                                                .lightTheme.colorScheme.shadow
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
                                            padding: const EdgeInsets.all(12),
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
                                            '${_mockPatients.length}',
                                            style: AppTheme.lightTheme.textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Active Patients',
                                            style: AppTheme
                                                .lightTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // ---------------- TOTAL DIET PLANS CARD ----------------
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme
                                                .lightTheme.colorScheme.shadow
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
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.primaryContainer
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
                                            '${_mockPatients.where((p) => p.hasDietChart).length}',
                                            style: AppTheme.lightTheme.textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Diet Plans',
                                            style: AppTheme
                                                .lightTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurfaceVariant,
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

                        SizedBox(height: 16),

                        // Section 4: Quick Actions
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: QuickActionsSection(
                            onAddPatient: () {
                              // Add Patients Screen
                            },
                            onCreateDietChart: () {
                              // Generate Diet Chart Screen
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // Section 5: Recently Generated Diet Charts
                      ],
                    ),
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
                                        patients: _mockPatients,
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
                  const Center(
                    child: Text(
                      'Doctor Profile Screen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
