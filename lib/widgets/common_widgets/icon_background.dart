import 'package:chat_app2/constants/theme.dart';
import 'package:flutter/material.dart';

class IconBorder extends StatelessWidget {
  const IconBorder({Key? key, required this.icon, required this.onTap})
      : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: AppColors.secondary,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(width: 2, color: theme.cardColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 25, color: theme.iconTheme.color),
        ),
      ),
    );
  }
}
