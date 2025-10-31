import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String actionText;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.actionText,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? TextTheme.of(context).labelLarge?.color,
        size: 30,
      ),
      title: Text(label, style: TextTheme.of(context).titleLarge),
      trailing: actionText.isNotEmpty
          ? Text(actionText, style: TextTheme.of(context).labelLarge)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
      horizontalTitleGap: 12.0,
    );
  }
}
