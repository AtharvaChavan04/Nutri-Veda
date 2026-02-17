import 'package:flutter/material.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class GreetingSection extends StatelessWidget {
  final String doctorName;

  const GreetingSection({
    super.key,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16, // ≈ 4.w
        vertical: 16, // ≈ 2.h
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Dr. $doctorName',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '${now.day}/${now.month}/${now.year}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
