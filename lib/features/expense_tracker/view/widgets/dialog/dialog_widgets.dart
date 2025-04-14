import 'package:flutter/material.dart';

class DialogYesNoButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final VoidCallback onTapFun;
  final Color color;

  const DialogYesNoButton(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.onTapFun,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final shadowColor = Theme.of(context).colorScheme.onSurface;
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(2, 4), // changes position of shadow
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        // clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTapFun,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}