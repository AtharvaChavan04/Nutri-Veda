import 'package:flutter/material.dart';
import 'package:nutri_veda/utils/appTheme/app_theme.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback onAddPatient;
  final VoidCallback onCreateDietChart;

  const QuickActionsSection({
    super.key,
    required this.onAddPatient,
    required this.onCreateDietChart,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          'Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.person_add_alt_1,
                title: 'Add New Patient',
                iconBgColor: colorScheme.primary.withValues(alpha: 0.12),
                iconColor: colorScheme.primary,
                onTap: onAddPatient,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ActionCard(
                icon: Icons.insert_chart_outlined_rounded,
                title: 'Create Diet Chart',
                iconBgColor: colorScheme.tertiary.withValues(alpha: 0.15),
                iconColor: colorScheme.tertiary,
                onTap: onCreateDietChart,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),

            const SizedBox(height: 18),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
