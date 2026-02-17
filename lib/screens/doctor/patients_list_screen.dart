import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/screens/doctor/patients_profile_screen.dart';
import 'package:nutri_veda/screens/doctor/widgets/patient_card.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

enum PatientFilter { all, pending }

class PatientsListScreen extends StatefulWidget {
  final List<DoctorPatient> patients;

  const PatientsListScreen({
    super.key,
    required this.patients,
  });

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  String _searchQuery = '';
  PatientFilter _selectedFilter = PatientFilter.all;
  bool _isLoading = false;

  // ---------------- FILTERED PATIENTS ----------------
  List<DoctorPatient> get _filteredPatients {
    final query = _searchQuery.toLowerCase();

    return widget.patients.where((patient) {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(colorScheme),
            const SizedBox(height: 16),
            _buildFilterChip(colorScheme),
            const SizedBox(height: 16),
            Expanded(child: _buildPatientList()),
          ],
        ),
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
  Widget _buildPatientList() {
    if (widget.patients.isEmpty) {
      return Center(
        child: Text(
          'No Patients Added Yet',
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
    }

    if (_filteredPatients.isEmpty) {
      return Center(
        child: Text(
          'No matching patients found',
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
    }

    return Stack(
      children: [
        ListView.separated(
          itemCount: _filteredPatients.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final patient = _filteredPatients[index];

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
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.05),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  // ---------------- FILTER BOTTOM SHEET ----------------
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                'Filter Patients',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
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

  // ---------------- FILTER OPTION ----------------
  Widget _buildFilterOption({
    required String title,
    required IconData icon,
    required PatientFilter filter,
  }) {
    final colorScheme = AppTheme.lightTheme.colorScheme;
    final isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);

        setState(() {
          _selectedFilter = filter;
          _isLoading = true;
        });

        await Future.delayed(const Duration(milliseconds: 500));

        setState(() => _isLoading = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.primary.withOpacity(0.12),
              child: Icon(icon, color: colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
