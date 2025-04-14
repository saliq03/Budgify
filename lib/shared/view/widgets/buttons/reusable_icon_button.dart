import 'package:flutter/material.dart';
import '../../../../core/theme/app_styles.dart';
import '../global_widgets.dart';

class ReusableIconButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final double spacerWidth;
  final double socialIconSize;
  final VoidCallback onTap;
  final List<Color> colors;

  const ReusableIconButton({super.key,
    required this.title,
    required this.icon,
    required this.colors,
    this.socialIconSize = 24,
    required this.onTap, this.spacerWidth=8});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4), // changes position of shadow
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: socialIconSize,
                ),
                spacerW(spacerWidth),
                Flexible(
                  child: Text(
                    title,
                    style: AppStyles.descriptionPrimary(context: context,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
