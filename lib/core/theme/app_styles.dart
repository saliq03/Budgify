import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  // Text Styles
  static TextStyle headingPrimary({double? fontSize , FontWeight fontWeight = FontWeight.w600, required BuildContext context,Color? color}) {
    return TextStyle(
      fontWeight: fontWeight,
      fontSize:fontSize?? 20,
      fontFamily: "Montserrat",
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle descriptionPrimary({double fontSize = 16, FontWeight fontWeight = FontWeight.w400, required BuildContext context,Color? color, TextDecoration decoration = TextDecoration.none , Color? decorationColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      color:color?? Theme.of(context).colorScheme.onSurface,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  // Linear Gradients
  static Gradient appBarGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primaryContainer,
        Theme.of(context).colorScheme.primary,

      ],
    );
  }

  static const LinearGradient pinkPurple = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0XFFaa367c), Color(0XFF4a2fbd)],
  );

  static LinearGradient themeGradient(BuildContext context) => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)],
    // colors: [Color.fromRGBO(37, 146, 166, 1), ],
  );

  static const LinearGradient grayBlack = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0XFF2E2D36), Color(0XFF11101D)],
  );

  static const LinearGradient grayWhite = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF3F2FF)],
  );

  static LinearGradient chattingGradient= LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [const Color(0xFFDFFBFC) ,const Color(0xFFBFF5F7) ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0XFF7DE7EB), Color(0XFF33BBCF)],
  );

  static LinearGradient contactGradient(BuildContext context) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Theme.of(context).colorScheme.onSurface, Theme.of(context).colorScheme.onSurface.withAlpha(150)],
  );

  // Box Shadows
  static final BoxShadow primaryColorShadow = BoxShadow(
    color: AppColors.themeDark.withAlpha(100),
    blurRadius: 12.0,
    offset: const Offset(0.0, 0.0),
  );

  static final BoxShadow blackColorShadow = BoxShadow(
    color: Colors.black.withAlpha(100),
    blurRadius: 12.0,
    offset: const Offset(0.0, 0.0),
  );


}
