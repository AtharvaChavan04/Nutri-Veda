import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
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
  double get _bmi {
    final weight = widget.patient.weight;
    final height = widget.patient.height ?? 0;

    if (height == 0) return 0;

    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Patient Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
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
                        widget.patient.name[0],
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
                            widget.patient.name,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.patient.age} yrs • ${widget.patient.gender}',
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
                              'Blood Group: ${widget.patient.bloodGroup}',
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
                      _buildInfoRow('Weight', '${widget.patient.weight} kg'),
                      _buildInfoRow('Height', '${widget.patient.height} cm'),
                      _buildInfoRow('BMI', _bmi.toStringAsFixed(1)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- CONDITIONS ----------------
              _buildChipSection(
                title: 'Medical Conditions',
                items: widget.patient.conditions,
                chipColor: colorScheme.primary,
              ),

              const SizedBox(height: 24),

              // ---------------- ALLERGIES ----------------
              _buildChipSection(
                title: 'Allergies',
                items: widget.patient.allergies,
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
                      _buildInfoRow('Email', widget.patient.email),
                      _buildInfoRow(
                          'Contact Number', widget.patient.contactNumber),
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
          // TODO: Navigate to diet chart creation
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
}
