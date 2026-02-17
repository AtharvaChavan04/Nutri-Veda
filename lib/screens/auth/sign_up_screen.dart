import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutri_veda/core/widgets/global_textfield.dart';
import 'package:nutri_veda/core/widgets/snackbar_helper.dart';
import 'package:nutri_veda/models/user_model.dart';
import 'package:nutri_veda/screens/auth/widgets/app_logo.dart';
import 'package:nutri_veda/screens/auth/widgets/auth_redirect_text.dart';
import 'package:nutri_veda/screens/auth/widgets/role_toggle_section.dart';
import 'package:nutri_veda/screens/auth/widgets/welcome_section.dart';
import 'package:nutri_veda/services/auth_services.dart';
import 'package:nutri_veda/utils/appRoutes/app_routes.dart'; // Import AppRoutes
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isDoctorRole = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateName(String value) {
    setState(() {
      if (value.isEmpty) {
        _nameError = 'Full name is required';
      } else if (value.length < 3) {
        _nameError = 'Name must be at least 3 characters';
      } else {
        _nameError = null;
      }
    });
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
    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  Future<void> _handleSignUp() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      UserModel user = await _authService.signUp(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: _isDoctorRole ? 'doctor' : 'patient',
      );

      HapticFeedback.lightImpact();

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome ${user.fullName}!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );

      // Navigate to appropriate dashboard WITH user data
      if (!mounted) return;
      if (user.role == 'doctor') {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.doctorDashboard,
          arguments: user, // Pass user as argument
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.patientDashboard,
          arguments: user, // Pass user as argument
        );
      }
    } catch (e) {
      if (!mounted) return;
      SnackBarHelper.show(
        context,
        message: e.toString(),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        icon: Icons.error_outline,
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
                    title: 'Create Your Account',
                    subtitle:
                        'Sign up to access your ${_isDoctorRole ? 'doctor' : 'health'} dashboard',
                  ),
                  const SizedBox(height: 20),
                  RoleToggleSection(
                    isDoctorRole: _isDoctorRole,
                    onRoleChanged: (value) {
                      setState(() => _isDoctorRole = value);
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildNameField(),
                  const SizedBox(height: 10),
                  _buildEmailField(),
                  const SizedBox(height: 10),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _buildSignUpButton(),
                  const SizedBox(height: 12),
                  AuthRedirectText(
                    questionText: "Already have an account? ",
                    actionText: "Sign In",
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.login);
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

  Widget _buildNameField() {
    return GlobalTextField(
      controller: _nameController,
      label: "Full Name",
      hint: "Enter your full name",
      prefixIcon: Icons.person,
      onChanged: _validateName,
      errorText: _nameError,
    );
  }

  Widget _buildEmailField() {
    return GlobalTextField(
      controller: _emailController,
      label: "Email Address",
      hint: "Enter your email",
      prefixIcon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      onChanged: _validateEmail,
      errorText: _emailError,
    );
  }

  Widget _buildPasswordField() {
    return GlobalTextField(
      controller: _passwordController,
      label: "Password",
      hint: "Create a password",
      prefixIcon: Icons.lock,
      obscureText: !_isPasswordVisible,
      onChanged: _validatePassword,
      errorText: _passwordError,
      suffixWidget: GestureDetector(
        onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        child: Icon(
          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isFormValid && !_isLoading ? _handleSignUp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
          Icon(
            Icons.verified_user,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 15,
          ),
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
