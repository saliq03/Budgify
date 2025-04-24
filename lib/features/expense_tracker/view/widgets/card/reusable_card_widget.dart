import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../shared/view/widgets/global_widgets.dart';
import '../../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../reusable_card_details.dart';

class ReusableCardWidget extends ConsumerWidget {
  final bool isTax;

  const ReusableCardWidget({super.key, this.isTax = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider).symbol;
    final double w = MediaQuery.of(context).size.width;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: w,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: AppGradients.skyBlueMyAppGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ReusableCardDetails(
                    color: Colors.white,
                    text: 'Current Amount',
                    icon: isTax
                        ? Icons.receipt_long
                        : FontAwesomeIcons.sackDollar,
                    amount: "$currency 0.0",
                    isShow: true,
                    iconSize: 18,
                    onTap: () {},
                  ),
                ),
                spacerW(),

                Expanded(
                  child: ReusableCardDetails(
                    color: Colors.white,
                    text: isTax ? "Tax Amount" : "Original Amount",
                    icon: isTax
                        ? Icons.receipt_long
                        : FontAwesomeIcons.sackDollar,
                    amount: "$currency  0.0",
                    isShow: true,
                    iconSize: 18,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            spacerH(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ReusableCardDetails(
                    color: Colors.white,
                    text: isTax ? "Total Tax" :"Total Returns",
                    icon: isTax
                        ? Icons.receipt_long
                        : FontAwesomeIcons.sackDollar,
                    amount: "$currency 0.0",
                    isShow: true,
                    iconSize: 18,
                    onTap: () {},
                  ),
                ),

                spacerW(),
                Expanded(
                  child: ReusableCardDetails(
                    color: Colors.white,
                    text: isTax ? "Total Tax %" :"Returns %",
                    icon: isTax
                        ? Icons.receipt_long
                        : FontAwesomeIcons.sackDollar,
                    amount:  "0%",
                    isShow: true,
                    iconSize: 18,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Text(
// "Current Amount",
// style: AppStyles.descriptionPrimary(
// context: context, color: Colors.white),
// ),
// spacerH(5),
// Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisSize: MainAxisSize.min,
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 12),
// child: Icon(
// Icons.add,
// color: Colors.white,
// size: 20,
// ),
// ),
// spacerW(2),
// Flexible(
// child: Text(
// "$currency 0.0",
// style: AppStyles.headingPrimary(
// context: context, fontSize: 30, color: Colors.white),
// )),
// ],
// ),

//            spacerH(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: ReusableCardDetails(
//                     color: Colors.white,
//                     text: "Tax Amount",
//                     icon: Icons.receipt_long,
//                     amount: "00",
//                     isShow: true,
//                     isExpense: true,
//                     onTap: () {},
//                   ),
//                 ),
//                 spacerW(),
//                 Expanded(
//                   child: ReusableCardDetails(
//                     color: Colors.white,
//                     text: "Total Tax %",
//                     icon: Icons.receipt_long,
//                     amount: "00",
//                     isShow: true,
//                     isExpense: true,
//                     onTap: () {},
//                   ),
//                 ),
//               ],
//             ),
