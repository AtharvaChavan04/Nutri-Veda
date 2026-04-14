import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';
import 'package:nutri_veda/services/patient_service.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  String _selectedGender = 'Male';
  String? _selectedBloodGroup;

  final List<String> _conditions = [];
  final List<String> _allergies = [];

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Patient'),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- BASIC INFO ----------------
                _buildSectionTitle('Basic Information'),

                _buildTextField(_nameController, 'Full Name'),

                _buildTextField(
                  _ageController,
                  'Age',
                  isNumber: true,
                ),

                _buildTextField(
                  _emailController,
                  'Email',
                  isEmail: true,
                ),

                _buildTextField(
                  _contactController,
                  'Contact Number',
                  isPhone: true,
                ),

                const SizedBox(height: 12),

                _buildGenderSelector(),

                const SizedBox(height: 30),

                // ---------------- HEALTH METRICS ----------------
                _buildSectionTitle('Health Metrics'),

                _buildTextField(
                  _weightController,
                  'Weight (kg)',
                  isNumber: true,
                ),

                _buildTextField(
                  _heightController,
                  'Height (cm)',
                  isNumber: true,
                  optional: true,
                ),

                _buildBloodGroupDropdown(),

                const SizedBox(height: 30),

                // ---------------- MEDICAL INFO ----------------
                _buildSectionTitle('Medical Information'),

                _buildChipInput(
                  'Medical Conditions',
                  _conditions,
                  _conditionsController,
                ),

                const SizedBox(height: 20),

                _buildChipInput(
                  'Allergies',
                  _allergies,
                  _allergiesController,
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Add Patient',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- SECTION TITLE ----------------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  // ---------------- TEXT FIELD ----------------
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isEmail = false,
    bool isPhone = false,
    bool optional = false,
  }) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        autovalidateMode:
            AutovalidateMode.onUserInteraction, // ✅ LIVE VALIDATION
        keyboardType: isNumber
            ? TextInputType.number
            : (isEmail
                ? TextInputType.emailAddress
                : (isPhone ? TextInputType.phone : TextInputType.text)),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: colorScheme.surface,

          // ✅ NORMAL BORDER
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          // ✅ FOCUSED BORDER
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.primary),
          ),

          // 🔴 ERROR BORDER
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.error),
          ),

          // 🔴 FOCUSED ERROR BORDER
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.error, width: 1.5),
          ),
        ),
        validator: (value) {
          final val = value?.trim() ?? '';

          if (!optional && val.isEmpty) {
            return 'Required';
          }

          // ✅ EMAIL VALIDATION
          if (isEmail && val.isNotEmpty) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(val)) {
              return 'Enter valid email';
            }
          }

          // ✅ PHONE VALIDATION
          if (isPhone && val.isNotEmpty) {
            if (!RegExp(r'^\d{10}$').hasMatch(val)) {
              return 'Enter 10 digit phone number';
            }
          }

          // ✅ AGE VALIDATION
          if (label == 'Age' && val.isNotEmpty) {
            final age = int.tryParse(val);
            if (age == null || age <= 0 || age > 120) {
              return 'Enter valid age';
            }
          }

          // ✅ NUMBER VALIDATION
          if (isNumber && val.isNotEmpty) {
            final number = double.tryParse(val);
            if (number == null || number <= 0) {
              return 'Enter valid number';
            }
          }

          return null;
        },
      ),
    );
  }

  // ---------------- BLOOD GROUP DROPDOWN ----------------
  Widget _buildBloodGroupDropdown() {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedBloodGroup,
        items: _bloodGroups.map((group) {
          return DropdownMenuItem(
            value: group,
            child: Text(group),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedBloodGroup = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Blood Group',
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (value) {
          if (value == null) {
            return 'Select blood group';
          }
          return null;
        },
      ),
    );
  }

  // ---------------- GENDER SELECTOR ----------------
  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(child: _genderChip('Male')),
        const SizedBox(width: 10),
        Expanded(child: _genderChip('Female')),
        const SizedBox(width: 10),
        Expanded(child: _genderChip('Other')),
      ],
    );
  }

  Widget _genderChip(String gender) {
    final colorScheme = AppTheme.lightTheme.colorScheme;
    final bool isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          gender,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  // ---------------- CHIP INPUT ----------------
  Widget _buildChipInput(
    String title,
    List<String> list,
    TextEditingController controller,
  ) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Add and press enter',
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onSubmitted: (value) {
            final item = value.trim();
            if (item.isEmpty) return;

            if (!list.contains(item)) {
              setState(() {
                list.add(item);
              });
            }

            controller.clear();
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: list.map((item) {
            return Chip(
              label: Text(item),
              onDeleted: () {
                setState(() => list.remove(item));
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------- SUBMIT ----------------
  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 🔹 Get current user
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      // Optional: you can add loading later
    });

    try {
      // 🔹 Generate patient ID
      final patientId =
          FirebaseFirestore.instance.collection('patients').doc().id;

      final name = _nameController.text.trim();
      final age = int.parse(_ageController.text.trim());
      final email = _emailController.text.trim();
      final contact = _contactController.text.trim();
      final weight = double.parse(_weightController.text.trim());

      final height = _heightController.text.trim().isEmpty
          ? null
          : double.parse(_heightController.text.trim());

      final bloodGroup = _selectedBloodGroup;

      // 🔥 CREATE MODEL
      final newPatient = DoctorPatient(
        id: patientId,
        doctorId: user.uid, // ✅ IMPORTANT FIX
        name: name,
        age: age,
        gender: _selectedGender,
        weight: weight,
        height: height,
        bloodGroup: bloodGroup,
        email: email,
        contactNumber: contact,
        conditions: _conditions,
        allergies: _allergies,
        createdAt: DateTime.now(),
        hasDietChart: false,
      );

      // 🔥 SAVE TO FIREBASE
      await PatientService().addPatient(newPatient);

      // ✅ CLEAR FORM
      _clearForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient added successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _ageController.clear();
    _emailController.clear();
    _contactController.clear();
    _weightController.clear();
    _heightController.clear();

    _conditionsController.clear();
    _allergiesController.clear();

    setState(() {
      _selectedGender = 'Male';
      _selectedBloodGroup = null;
      _conditions.clear();
      _allergies.clear();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _conditionsController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }
}
