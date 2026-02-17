import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_veda/core/widgets/global_textfield.dart';
import 'package:nutri_veda/core/widgets/snackbar_helper.dart';
import 'package:nutri_veda/screens/auth/widgets/app_logo.dart';
import 'package:nutri_veda/screens/auth/widgets/auth_redirect_text.dart';
import 'package:nutri_veda/screens/auth/widgets/role_toggle_section.dart';
import 'package:nutri_veda/screens/auth/widgets/welcome_section.dart';
import 'package:nutri_veda/services/auth_services.dart';
import 'package:nutri_veda/utils/appRoutes/app_routes.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isDoctorRole = true;

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else if (value.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  bool get _isFormValid {
    return _emailError == null &&
        _passwordError == null &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final selectedRole = _isDoctorRole ? 'doctor' : 'patient';

      if (user.role != selectedRole) {
        // ❌ BLOCK ACCESS HERE
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        SnackBarHelper.show(
          context,
          message: 'Selected role does not match your account.',
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          icon: Icons.warning_amber_rounded,
        );
        return;
      }

      // ✅ Login successful - pass user data directly
      if (!mounted) return;

      // In _handleLogin method:
      if (user.role == 'doctor') {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.doctorDashboard,
          arguments: user,
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.patientDashboard,
          arguments: user,
        );
      }
    } catch (e) {
      if (!mounted) return;

      SnackBarHelper.show(
        context,
        message: e.toString(),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const AppLogo(),
                  const SizedBox(height: 30),
                  WelcomeSection(
                    title: 'Welcome Back',
                    subtitle:
                        'Sign in to access your ${_isDoctorRole ? 'doctor' : 'health'} dashboard',
                  ),
                  const SizedBox(height: 10),
                  RoleToggleSection(
                    isDoctorRole: _isDoctorRole,
                    onRoleChanged: (value) {
                      setState(() => _isDoctorRole = value);
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildEmailField(),
                  const SizedBox(height: 10),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _buildLoginButton(),
                  const SizedBox(height: 10),
                  AuthRedirectText(
                    questionText: "Don't have an account? ",
                    actionText: "Sign Up",
                    onTap: () {
                      Navigator.pushNamed(context, '/sign_up');
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  _buildComplianceBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- FIELDS ----------------

  Widget _buildEmailField() {
    return GlobalTextField(
      controller: _emailController,
      label: "Email Address",
      hint: "Enter your email",
      prefixIcon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      onChanged: _validateEmail,
      errorText: _emailError,
      suffixWidget: _emailController.text.isNotEmpty && _emailError == null
          ? Icon(
              Icons.check_circle,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            )
          : null,
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalTextField(
          controller: _passwordController,
          label: "Password",
          hint: "Enter your password",
          prefixIcon: Icons.lock,
          obscureText: !_isPasswordVisible,
          onChanged: _validatePassword,
          onFieldSubmitted: (_) => _handleLogin(),
          errorText: _passwordError,
          suffixWidget: GestureDetector(
            onTap: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
            child: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isFormValid && !_isLoading ? _handleLogin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildComplianceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_user,
              color: AppTheme.lightTheme.colorScheme.primary, size: 15),
          const SizedBox(width: 8),
          Text(
            'HIPAA Compliant & Secure',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
