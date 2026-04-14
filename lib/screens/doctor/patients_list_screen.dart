import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/screens/doctor/add_patient_screen.dart';
import 'package:nutri_veda/screens/doctor/patients_profile_screen.dart';
import 'package:nutri_veda/screens/doctor/widgets/patient_card.dart';
import 'package:nutri_veda/services/patient_service.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

enum PatientFilter { all, pending }

class PatientsListScreen extends StatefulWidget {
  final String doctorId; // ✅ Pass doctorId

  const PatientsListScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  String _searchQuery = '';
  PatientFilter _selectedFilter = PatientFilter.all;

  final PatientService _patientService = PatientService();

  // ---------------- FILTER LOGIC ----------------
  List<DoctorPatient> _applyFilters(List<DoctorPatient> patients) {
    final query = _searchQuery.toLowerCase();

    return patients.where((patient) {
      final matchesFilter = _selectedFilter == PatientFilter.all ||
          (_selectedFilter == PatientFilter.pending && !patient.hasDietChart);

      final matchesSearch =
          query.isEmpty || patient.name.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Patients List'),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddPatientScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
            color: colorScheme.primary,
          ),
        ],
      ),

      // 🔥 STREAM BUILDER STARTS HERE
      body: StreamBuilder<List<DoctorPatient>>(
        stream: _patientService.getPatients(widget.doctorId),
        builder: (context, snapshot) {
          // ---------------- LOADING ----------------
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ---------------- ERROR ----------------
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final patients = snapshot.data ?? [];

          final filteredPatients = _applyFilters(patients);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchBar(colorScheme),
                const SizedBox(height: 16),
                _buildFilterChip(colorScheme),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildPatientList(filteredPatients),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: const InputDecoration(
                hintText: 'Search patients...',
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: _openFilterSheet,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.tune_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- FILTER CHIP ----------------
  Widget _buildFilterChip(ColorScheme colorScheme) {
    final label = _selectedFilter == PatientFilter.all
        ? 'All Patients'
        : 'Pending Diet Chart';

    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: _openFilterSheet,
        child: Chip(
          backgroundColor: colorScheme.primary.withOpacity(0.1),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          avatar: Icon(
            Icons.filter_list_rounded,
            color: colorScheme.primary,
            size: 18,
          ),
        ),
      ),
    );
  }

  // ---------------- PATIENT LIST ----------------
  Widget _buildPatientList(List<DoctorPatient> patients) {
    if (patients.isEmpty) {
      return Center(
        child: Text(
          'No Patients Found',
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
    }

    return ListView.separated(
      itemCount: patients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
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
    );
  }

  // ---------------- FILTER SHEET ----------------
  void _openFilterSheet() {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: colorScheme.surface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption(
                title: 'All Patients',
                icon: Icons.groups_rounded,
                filter: PatientFilter.all,
              ),
              const SizedBox(height: 16),
              _buildFilterOption(
                title: 'Pending Diet Chart',
                icon: Icons.pending_actions_rounded,
                filter: PatientFilter.pending,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({
    required String title,
    required IconData icon,
    required PatientFilter filter,
  }) {
    final colorScheme = AppTheme.lightTheme.colorScheme;
    final isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);

        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.08)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(child: Text(title)),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
