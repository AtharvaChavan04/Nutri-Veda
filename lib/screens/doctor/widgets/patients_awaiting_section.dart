import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/screens/doctor/patients_profile_screen.dart';
import 'package:nutri_veda/screens/doctor/widgets/patient_card.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class PatientsAwaitingSection extends StatelessWidget {
  final List<DoctorPatient> patients;
  final VoidCallback onAddPatient;
  final int totalPatientsCount;
  const PatientsAwaitingSection({
    super.key,
    required this.patients,
    required this.onAddPatient,
    required this.totalPatientsCount,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patients Awaiting Diet Chart',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        if (patients.isNotEmpty)
          SizedBox(
            height: 180,
            child: ListView.separated(
              itemCount: patients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final patient = patients[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientsProfileScreen(patient: patient),
                      ),
                    );
                  },
                  child: PatientCard(patient: patient),
                );
              },
            ),
          )
        else
          _buildEmptyState(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasPatients = totalPatientsCount > 0;
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return SizedBox(
      height: 180, // ✅ same as ListView height
      child: Center(
        // ✅ centers vertically + horizontally
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ prevents stretching
          children: [
            Icon(
              hasPatients
                  ? Icons.assignment_turned_in_outlined
                  : Icons.group_outlined,
              size: 48,
            ),
            Text(
              hasPatients ? 'All caught up!' : 'No patients yet',
            ),
            Text(
              hasPatients
                  ? 'All patients have diet charts'
                  : 'Add your first patient',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAddPatient,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary, // ✅ background
                foregroundColor: colorScheme.onPrimary, // ✅ text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                hasPatients ? 'Add New Patient' : 'Add First Patient',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
