import 'package:flutter/material.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class WelcomeSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextAlign textAlign;

  const WelcomeSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }
}
