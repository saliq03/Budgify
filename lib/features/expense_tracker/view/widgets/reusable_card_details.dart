import 'package:flutter/material.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../../shared/view/widgets/global_widgets.dart';

class ReusableCardDetails extends StatelessWidget {
  final String text;
  final IconData icon;
  final IconData currencySymbol;
  final String amount;

  const ReusableCardDetails(
      {super.key,
        required this.text,
        required this.icon,
        required this.currencySymbol,
        required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            spacerW(5),
            Text(
              text,
              style: AppStyles.descriptionPrimary(
                  context: context, fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        spacerH(5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(
                currencySymbol,
                color: Colors.white,
                size: 20,
              ),
            ),
            spacerW(2),
            Flexible(
                child: Text(
                  amount,
                  style: AppStyles.headingPrimary(
                      context: context, fontSize: 18, color: Colors.white),
                )),
          ],
        ),
      ],
    );
  }
}