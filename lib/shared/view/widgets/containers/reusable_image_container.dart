import 'package:flutter/material.dart';
import '../../../../../core/theme/app_styles.dart';
import '../global_widgets.dart';

class ReusableImageContainer extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String time;

  const ReusableImageContainer(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.time});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: w,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.15), BlendMode.darken),
        ),
        boxShadow: [
          // BoxShadow(
          //   color: theme.shadow.withOpacity(0.2), // Adjust opacity for a natural shadow
          //   spreadRadius: 1, // Slight spread for softness
          //   blurRadius: 4, // Mimics Material shadow blur
          //   offset: Offset(0, 2), // Subtle downward shadow like a Card
          // ),

          BoxShadow(
            color:theme.onSurface.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(2, 4), // changes position of shadow

          )
        ]

      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 15,top: 15,right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title.toUpperCase(),
                      style: AppStyles.descriptionPrimary(
                          context: context, color: Colors.white,fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,),
                  spacerH(5),
                  Text("Duration: $time",
                      style: AppStyles.descriptionPrimary(
                          context: context,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
