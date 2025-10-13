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
        color: iconColor ?? Color.fromARGB(255, 204, 208, 211),
        size: 30,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w100,
          color: textColor ?? Color.fromARGB(255, 204, 208, 211),
        ),
      ),
      trailing: actionText.isNotEmpty
          ? Text(
              actionText,
              style: TextStyle(
                color: Color.fromARGB(200, 204, 208, 211),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
      horizontalTitleGap: 12.0,
    );
  }
}
