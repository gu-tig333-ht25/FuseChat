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
      leading: Icon(icon, color: iconColor ?? Colors.black87, size: 30),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w100,
          color: textColor ?? Colors.black,
        ),
      ),
      trailing: actionText.isNotEmpty
          ? Text(
              actionText,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
      //contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
      horizontalTitleGap: 12.0,
    );
  }
}
