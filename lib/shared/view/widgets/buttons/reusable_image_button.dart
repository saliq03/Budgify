import 'package:flutter/material.dart';

import '../global_widgets.dart';

class ReusableImageButton extends StatelessWidget {
  final Color? color;
  final VoidCallback onTap;
  final String url;
  final double? width;
  final double? height;

  const ReusableImageButton(
      {super.key,
        this.color,
        required this.onTap,
        required this.url,
       this.width=30,
       this.height});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return InkWell(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        onTap: onTap,
        child: staticImage(
            assetName: url, color: color ?? theme.onSurface, width: width, height: height));
  }
}