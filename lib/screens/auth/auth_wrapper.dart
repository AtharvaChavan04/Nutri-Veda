import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutri_veda/models/doctor_user_model.dart';
import 'package:nutri_veda/screens/auth/login_screen.dart';
import 'package:nutri_veda/screens/doctor/doctor_dashboard.dart';
import 'package:nutri_veda/screens/patient/patient_dashboard.dart';
import 'package:nutri_veda/services/auth_services.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // 🔄 Auth loading
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Not logged in
        if (!authSnapshot.hasData || authSnapshot.data == null) {
          return const LoginScreen();
        }

        // ✅ Logged in → fetch Firestore user
        return FutureBuilder<UserModel?>(
          future: _authService.getCurrentUser(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return const LoginScreen();
            }

            final UserModel currentUser = userSnapshot.data!;

            // 🔀 Role-based routing
            return currentUser.role == 'doctor'
                ? DoctorDashboard(currentUser: currentUser)
                : PatientDashboard();
          },
        );
      },
    );
  }
}
