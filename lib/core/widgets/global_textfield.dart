import 'package:flutter/material.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class GlobalTextField extends StatelessWidget {
  final TextEditingController controller;

  final String label;
  final String hint;

  final IconData? prefixIcon;
  final bool obscureText;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final String? errorText;

  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  final Widget? suffixWidget;

  const GlobalTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.errorText,
    this.onChanged,
    this.onFieldSubmitted,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        // Borders
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.colorScheme.primary,
            width: 2,
          ),
        ),

        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),

        // Prefix icon
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(11),
                child: Icon(
                  prefixIcon,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              )
            : null,

        // Custom suffix widget for password visibility or validation icons
        suffixIcon: suffixWidget != null
            ? Padding(
                padding: const EdgeInsets.all(11),
                child: suffixWidget,
              )
            : null,

        errorText: errorText,
      ),
    );
  }
}
