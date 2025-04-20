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

  const ReusableCardDetails(
      {super.key,
        required this.text,
        required this.icon,
        required this.amount, required this.color, required this.isShow, this.isExpense= false, this.onTap});

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
              color: color,
              size: 20,
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
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}