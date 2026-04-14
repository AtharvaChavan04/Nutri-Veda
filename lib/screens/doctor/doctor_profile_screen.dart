import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutri_veda/models/doctor_user_model.dart';
import 'package:nutri_veda/screens/auth/login_screen.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      setState(() {
        user = UserModel.fromMap(doc.data()!);
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Logout",
          ),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "Logout",
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return const Center(child: Text("No data found"));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Container(
              width: double.infinity, // ✅ FULL WIDTH (important for alignment)
              padding: const EdgeInsets.all(16),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16), // ✅ SAME AS CARDS
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      user!.fullName.isNotEmpty ? user!.fullName[0] : "D",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // 🔥 THIS FIXES OVERFLOW + ALIGNMENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user!.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // ✅ PREVENT OVERFLOW
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user!.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // ✅ PREVENT OVERFLOW
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 INFO SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _modernCard("Phone", user!.phone),
                  _modernCard("Qualification", user!.qualification),
                  _modernCard("Experience", user!.experience),
                  _modernCard("Specialization", user!.specialization),
                  _modernCard("Clinic Name", user!.clinicName),
                  _modernCard("Clinic Address", user!.clinicAddress),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditDoctorProfileScreen(user: user!),
                          ),
                        );
                        _fetchUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _modernCard(String title, String? value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),

          // 🔥 THIS FIXES OVERFLOW
          Text(
            (value == null || value.isEmpty) ? "Not added" : value,
            softWrap: true,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: (value == null || value.isEmpty)
                  ? Colors.red
                  : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// EDIT PROFILE SECTION

class EditDoctorProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditDoctorProfileScreen({super.key, required this.user});

  @override
  State<EditDoctorProfileScreen> createState() =>
      _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // ✅ ADDED

  late TextEditingController phoneController;
  late TextEditingController qualificationController;
  late TextEditingController experienceController;
  late TextEditingController specializationController;
  late TextEditingController clinicNameController;
  late TextEditingController clinicAddressController;

  @override
  void initState() {
    super.initState();

    phoneController = TextEditingController(text: widget.user.phone ?? "");
    qualificationController =
        TextEditingController(text: widget.user.qualification ?? "");
    experienceController =
        TextEditingController(text: widget.user.experience ?? "");
    specializationController =
        TextEditingController(text: widget.user.specialization ?? "");
    clinicNameController =
        TextEditingController(text: widget.user.clinicName ?? "");
    clinicAddressController =
        TextEditingController(text: widget.user.clinicAddress ?? "");
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final updatedUser = widget.user.copyWith(
      phone: phoneController.text.trim(),
      qualification: qualificationController.text.trim(),
      experience: experienceController.text.trim(),
      specialization: specializationController.text.trim(),
      clinicName: clinicNameController.text.trim(),
      clinicAddress: clinicAddressController.text.trim(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(updatedUser.toMap());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Form(
        // ✅ ADDED
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _field("Phone", phoneController),
              _field("Qualification", qualificationController),
              _field("Experience", experienceController),
              _field("Specialization", specializationController),
              _field("Clinic Name", clinicNameController),
              _field("Clinic Address", clinicAddressController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: colorScheme.surface),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        autovalidateMode:
            AutovalidateMode.onUserInteraction, // ✅ LIVE VALIDATION

        keyboardType:
            label == "Phone" ? TextInputType.number : TextInputType.text,

        inputFormatters: label == "Phone"
            ? [FilteringTextInputFormatter.digitsOnly] // ✅ ONLY DIGITS
            : null,

        maxLength: label == "Phone" ? 10 : null, // ✅ LIMIT

        validator: (value) {
          if (label == "Phone") {
            if (value == null || value.isEmpty) {
              return "Phone number is required";
            }
            if (value.length != 10) {
              return "Enter valid 10-digit number";
            }
          }
          return null;
        },

        decoration: InputDecoration(
          labelText: label,
          counterText: "", // ✅ hides 0/10 text

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.secondary,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
