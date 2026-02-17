import 'package:flutter/material.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 75,
            height: 75,
            clipBehavior: Clip.hardEdge, 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/app_logo/nutri_veda_logo_2.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'NutriVeda',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Ayurvedic Healthcare & Nutrition',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
