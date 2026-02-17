import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutri_veda/firebase_options.dart';
import 'package:nutri_veda/screens/auth/auth_wrapper.dart';
import 'package:nutri_veda/utils/appRoutes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
