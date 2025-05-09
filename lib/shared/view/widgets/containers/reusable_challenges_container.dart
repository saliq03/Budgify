import 'package:flutter/material.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_styles.dart';
import '../global_widgets.dart';

class ReusableChallengesContainer extends StatelessWidget {
  final String title;
  final List<Color> gradientColors;
  final String image;
  const ReusableChallengesContainer({super.key, required this.title,required this.gradientColors, required this.image});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only( top: 20),
          child: Card(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(15),
              width: w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: w * 0.5,
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  spacerH(15),
                  SizedBox(
                    width: w * 0.5,
                    child: const Text(
                      "Start your 7X4 challenge today and get a full body workout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  spacerH(15),
                  SizedBox(
                    width: w * 0.45,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: w,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: AppGradients.greenGradient,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Material(
                          color: Colors.transparent,

                          child: InkWell(
                            // onTap: onTap,
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Text("Start Now",
                                  style:
                                  AppStyles.descriptionPrimary(context: context,color: Colors.white,fontSize: 15)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Image(
            image: AssetImage(image),
            width: w * 0.5,
            height: 200,
          ),
        ),
      ],
    );
  }
}