import 'package:flutter/material.dart';
import 'package:nutri_veda/models/doctor_user_model.dart';
import 'package:nutri_veda/screens/auth/login_screen.dart';
import 'package:nutri_veda/screens/auth/sign_up_screen.dart';
import 'package:nutri_veda/screens/doctor/doctor_dashboard.dart';
import 'package:nutri_veda/screens/patient/patient_dashboard.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String patientDashboard = '/patientDashboard';
  static const String doctorDashboard = '/doctorDashboard';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    signUp: (context) => const SignUpScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case doctorDashboard:
        final UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => DoctorDashboard(currentUser: user),
        );
      case patientDashboard:
        // final UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => PatientDashboard(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
