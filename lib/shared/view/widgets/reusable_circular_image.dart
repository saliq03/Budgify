import 'package:flutter/material.dart';
import '../../../core/constants/static_assets.dart';

class ReusableCircularImage extends StatelessWidget {
  final double width;
  final double height;
  final String image;
  final double borderWidth;
  final Color? borderColor;
  final BoxFit fit;
  const ReusableCircularImage({super.key, this.width=50,this.height=50, this.image=StaticAssets.appIcon, this.borderWidth=0.5, this.borderColor , this.fit=BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(image),
          fit: fit,
        ),
        border: Border.all(color: borderColor??theme.onSurface, width: borderWidth),
      ),
    );
  }
}
