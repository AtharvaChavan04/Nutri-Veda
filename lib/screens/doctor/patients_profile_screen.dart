import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/screens/doctor/diet_chart_screen.dart';
import 'package:nutri_veda/screens/doctor/generate_diet_chart_screen.dart';
import 'package:nutri_veda/services/patient_service.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class PatientsProfileScreen extends StatefulWidget {
  final DoctorPatient patient;

  const PatientsProfileScreen({
    super.key,
    required this.patient,
  });

  @override
  State<PatientsProfileScreen> createState() => _PatientsProfileScreenState();
}

class _PatientsProfileScreenState extends State<PatientsProfileScreen> {
  late DoctorPatient patient;
  final PatientService _patientService = PatientService();

  @override
  void initState() {
    super.initState();
    patient = widget.patient;
  }

  double get _bmi {
    final weight = patient.weight;
    final height = patient.height ?? 0;

    if (height == 0) return 0;

    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  void _showEditPatientDialog() {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    final nameController = TextEditingController(text: patient.name);
    final ageController = TextEditingController(text: patient.age.toString());
    final weightController =
        TextEditingController(text: patient.weight.toString());
    final heightController =
        TextEditingController(text: patient.height?.toString() ?? '');

    final genderController = TextEditingController(text: patient.gender);
    final bloodGroupController =
        TextEditingController(text: patient.bloodGroup);

    final emailController = TextEditingController(text: patient.email);
    final contactController =
        TextEditingController(text: patient.contactNumber);

    final conditionsController =
        TextEditingController(text: patient.conditions.join(', '));
    final allergiesController =
        TextEditingController(text: patient.allergies.join(', '));

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Edit Patient Details",
                    style: AppTheme.lightTheme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  _editField("Name", nameController),
                  _editField("Age", ageController,
                      keyboardType: TextInputType.number),
                  _editField("Weight", weightController,
                      keyboardType: TextInputType.number),
                  _editField("Height", heightController,
                      keyboardType: TextInputType.number),
                  _editField("Gender", genderController),
                  _editField("Blood Group", bloodGroupController),
                  _editField("Email", emailController),
                  _editField("Contact Number", contactController,
                      keyboardType: TextInputType.phone),
                  _editField(
                      "Conditions (comma separated)", conditionsController),
                  _editField(
                      "Allergies (comma separated)", allergiesController),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: AppTheme.primaryDark),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          onPressed: () async {
                            final updatedPatient = patient.copyWith(
                              name: nameController.text.trim(),
                              age: int.tryParse(ageController.text) ?? 0,
                              weight:
                                  double.tryParse(weightController.text) ?? 0,
                              height: double.tryParse(heightController.text),
                              gender: genderController.text.trim(),
                              bloodGroup: bloodGroupController.text.trim(),
                              contactNumber: contactController.text.trim(),
                              email: emailController.text.trim(),
                              conditions: conditionsController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty)
                                  .toList(),
                              allergies: allergiesController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty)
                                  .toList(),
                            );

                            await _patientService.updatePatient(updatedPatient);

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Patient updated successfully"),
                              ),
                            );

                            setState(() {
                              patient = updatedPatient;
                            });
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Patient Profile'),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          IconButton(
            onPressed: () {
              _showEditPatientDialog();
            },
            icon: Icon(Icons.edit_rounded),
            color: colorScheme.primary,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- HEADER SECTION ----------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: colorScheme.primary,
                      child: Text(
                        patient.name[0],
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
                            patient.name,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${patient.age} yrs • ${patient.gender}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Blood Group: ${patient.bloodGroup}',
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

              // ---------------- HEALTH OVERVIEW ----------------
              Text(
                'Health Overview',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Material(
                elevation: 4,
                shadowColor: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                color: colorScheme.surface,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Weight', '${patient.weight} kg'),
                      _buildInfoRow('Height', '${patient.height} cm'),
                      _buildInfoRow('BMI', _bmi.toStringAsFixed(1)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- CONDITIONS ----------------
              _buildChipSection(
                title: 'Medical Conditions',
                items: patient.conditions,
                chipColor: colorScheme.primary,
              ),

              const SizedBox(height: 24),

              // ---------------- ALLERGIES ----------------
              _buildChipSection(
                title: 'Allergies',
                items: patient.allergies,
                chipColor: colorScheme.error,
              ),

              const SizedBox(height: 24),

              // ---------------- CONTACT DETAILS ----------------
              Text(
                'Contact Details',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Material(
                elevation: 4,
                shadowColor: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                color: colorScheme.surface,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Email', patient.email),
                      _buildInfoRow('Contact Number', patient.contactNumber),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

// ---------------- DIET CHART SECTION ----------------
              Text(
                'Diet Chart',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Material(
                elevation: 4,
                shadowColor: colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                color: colorScheme.surface,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------------- STATUS TEXT ----------------
                      Text(
                        patient.hasDietChart
                            ? "Generated ${patient.dietChartTimeAgo}"
                            : "No diet chart generated yet",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ---------------- BUTTON ----------------
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (patient.hasDietChart) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DietChartScreen(
                                    dietChartId: patient.dietChartId!,
                                    patient: patient,
                                  ),
                                ),
                              );
                            } else {
                              // 👉 Generate diet
                              final updatedPatient = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GenerateDietChartScreen(
                                    patient: patient,
                                  ),
                                ),
                              );

                              if (updatedPatient != null) {
                                setState(() {
                                  patient = updatedPatient;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            patient.hasDietChart
                                ? "View Diet Chart"
                                : "Generate Diet Chart",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GenerateDietChartScreen(
                patient: patient,
              ),
            ),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.restaurant_menu),
      ),
    );
  }

  // ---------------- REUSABLE INFO ROW ----------------
  Widget _buildInfoRow(String label, String value) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CHIP SECTION ----------------
  Widget _buildChipSection({
    required String title,
    required List<String> items,
    required Color chipColor,
  }) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Material(
          elevation: 4,
          shadowColor: chipColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.surface,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline,
              ),
            ),
            child: items.isEmpty
                ? Text(
                    'None',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: chipColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: chipColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _editField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colorScheme.secondary),
          filled: true,
          fillColor: colorScheme.surface,

          // ✅ DEFAULT BORDER
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary.withOpacity(0.4),
            ),
          ),

          // ✅ WHEN FOCUSED
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),

          // ✅ OPTIONAL (ERROR STATE)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
}
