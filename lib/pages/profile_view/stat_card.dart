// in stat_card.dart
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 20),
            Text(value, style: TextTheme.of(context).titleLarge),
            const SizedBox(height: 20),
            Text(label, style: TextTheme.of(context).labelLarge),
          ],
        ),
      ),
    );
  }
}
