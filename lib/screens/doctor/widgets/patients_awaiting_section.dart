import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/screens/doctor/patients_profile_screen.dart';
import 'package:nutri_veda/screens/doctor/widgets/patient_card.dart';

class PatientsAwaitingSection extends StatelessWidget {
  final List<DoctorPatient> patients;
  final VoidCallback onAddPatient;
  final int totalPatientsCount; // Add this parameter

  const PatientsAwaitingSection({
    super.key,
    required this.patients,
    required this.onAddPatient,
    required this.totalPatientsCount, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patients Awaiting Diet Chart',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Patient List
          if (patients.isNotEmpty)
            SizedBox(
              height: 180, // Fixed height for scrollable area
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: patients.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final patient = patients[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PatientsProfileScreen(patient: patient),
                        ),
                      );
                    },
                    child: PatientCard(
                      patient: patient,
                    ),
                  );
                },
              ),
            )
          else
            _buildEmptyState(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasPatients = totalPatientsCount > 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      child: Column(
        children: [
          Icon(
            hasPatients
                ? Icons.assignment_turned_in_outlined
                : Icons.group_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            hasPatients ? 'All caught up!' : 'No patients yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              hasPatients
                  ? 'All your patients have diet charts. Add new patients to create personalized diet plans.'
                  : 'You don\'t have any patients yet. Add your first patient to start creating diet charts.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onAddPatient,
            child: Text(hasPatients ? 'Add New Patient' : 'Add First Patient'),
          ),
        ],
      ),
    );
  }
}
