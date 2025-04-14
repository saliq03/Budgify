import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isCenterText;
  final String text;
  final VoidCallback? onPressed;
  final bool isMenu;
  final PreferredSizeWidget? bottom;

  const ReusableAppBar({
    super.key,
    this.isCenterText = true,
    required this.text,
    this.onPressed,
    this.isMenu = false, this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final Color foregroundColor = Colors.white;
    // final Color foregroundColor = theme.surface;
    return AppBar(
      backgroundColor: theme.primary,
      centerTitle: isCenterText,
      foregroundColor: foregroundColor,
      title: Text(
        text,
        style: AppStyles.headingPrimary(context: context,color: foregroundColor),
      ),
      actions: [
        if (isMenu)
          IconButton(
            icon: Icon(
              Icons.menu,
              color: foregroundColor,
            ),
            onPressed: onPressed,
          ),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
