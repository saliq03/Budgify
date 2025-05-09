import 'package:flutter/material.dart';
import '../../../../core/theme/app_styles.dart';
import '../global_widgets.dart';

class ReusableStylishContainer extends StatelessWidget {
  final double w;
  final double h;
  final List<Color> colors;
  final String? title;
  final String description;
  final String image;
  final String buttonText;
  final bool isCarousel;
  final bool isShowHeading;
  final VoidCallback onTap;

  const ReusableStylishContainer(
      {super.key,
        required this.w,
        this.h = 420,
        required this.colors,
        this.title,
        required this.description,
        required this.image,
        this.buttonText = "DOWNLOAD NOW", this.isCarousel=true, required this.onTap, this.isShowHeading=true});

  @override
  Widget build(BuildContext context) {
    // final double w = MediaQuery.of(context).size.height;
    return SizedBox(
      height: isCarousel? h+25 :h+25,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none, // Allow overflow
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                height: h,
                width: w,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    spacerH(50),
                    Column(
                      children: [
                        if(isShowHeading)
                          Text(title??"",
                              style: AppStyles.headingPrimary(context: context,color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        if(isShowHeading)
                          spacerH(5),
                        Text(description,
                          style: AppStyles.descriptionPrimary(context: context,color: Colors.white,fontSize: 15),
                          textAlign: TextAlign.center,
                          // overflow: TextOverflow.ellipsis,
                          // maxLines: 7,
                        ),
                      ],
                    ),
                    spacerH(),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: w,
                        height: 45,
                        decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          //   colors: [
                          //     Colors.white,
                          //     Colors.
                          //   ]
                          // colors: colors,
                          // ),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Material(
                          color: Colors.transparent,

                          child: InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Text(buttonText,
                                  style:
                                  AppStyles.headingPrimary(context: context,color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // if(isCarousel)
                    // spacerH(),

                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            // Adjust this value to give enough space for the CircleAvatar
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors[0], // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
