import 'package:flutter/material.dart';

import '../../../../../core/theme/app_styles.dart';

class ReusableOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReusableOutlinedButton(
      {super.key, this.text = "View all >>", required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
            color: theme.surface,
            border: Border.all(color: theme.onSurface, width: 0.8),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          text,
          style: AppStyles.descriptionPrimary(context: context, fontSize: 14),
        ),
      ),
    );
  }
}


