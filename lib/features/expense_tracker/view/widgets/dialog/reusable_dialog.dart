import 'package:flutter/material.dart';

import '../../../../../core/constants/static_assets.dart';
import '../../../../../core/theme/app_styles.dart';

class ReusableDialog extends StatelessWidget {
  final String dialogTitle;
  final Widget dialogRowItem1;
  final Widget dialogRowItem2;

  const ReusableDialog(
      {super.key,
      required this.dialogTitle,
      required this.dialogRowItem1,
      required this.dialogRowItem2});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: w,
        height: 215,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: w,
                height: 200,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                      color: theme.primary,
                      // color: Theme.of(context).primaryColor
                      width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dialogTitle,
                      style: AppStyles.headingPrimary(
                          context: context,
                          color: theme.onSurface,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(child: dialogRowItem1),
                          const SizedBox(width: 15),
                          Flexible(child: dialogRowItem2),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image(
                  image: AssetImage(StaticAssets.crossCloseIcon),
                  width: 45,
                  height: 45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
