import 'package:flutter/material.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../../shared/view/widgets/global_widgets.dart';

class ReusableCardDetails extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final String amount;
  final bool isShow;
  final bool isExpense;
  final VoidCallback? onTap;
  final double iconSize;

  const ReusableCardDetails(
      {super.key,
        required this.text,
        this.iconSize = 20,
        required this.icon,
        required this.amount, required this.color, required this.isShow, this.isExpense= false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: iconSize,
            ),
            spacerW(5),
            Text(
              text,
              style: AppStyles.descriptionPrimary(
                  context: context, fontSize: 16, color: color),
            ),
          ],
        ),
        spacerH(5),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isShow)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  !isExpense
                      ? Icons.add
                      : Icons.remove,
                  color:color ,
                  size: 18,
                ),
              ),
            spacerW(2),
            Flexible(
              child: InkWell(
                onTap: onTap,
                child: Text(
                  amount,
                  style: AppStyles.headingPrimary(
                      context: context, fontSize: 18, color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                ),

              ),
            ),
          ],
        ),
      ],
    );
  }
}