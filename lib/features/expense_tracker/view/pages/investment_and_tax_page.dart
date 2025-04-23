import 'package:budgify/features/expense_tracker/utils/invest_and_tax_type.dart';
import 'package:budgify/features/expense_tracker/view/widgets/transaction_filter/transaction_filter2.dart';
import 'package:budgify/features/expense_tracker/viewmodel/riverpod/expense_tracker_notifier.dart';
import 'package:budgify/shared/view/widgets/date_filter.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_styles.dart';
import '../widgets/buttons/reusable_outlined_button.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/reusable_card_details.dart';

class InvestmentAndTaxPage extends ConsumerWidget {
  const InvestmentAndTaxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              spacerH(),
              TransactionFilter2(),
              spacerH(10),
              cardSection(w, context, "USD"),
              spacerH(10),
              DateFilter(),
              spacerH(20),
              transactionSection(context),
            ],
          ),
        ),
      ),
    );
  }


  Widget cardSection(
      final double w, final BuildContext context, final currency) {
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
            Text(
              "Total Balance",
              style: AppStyles.descriptionPrimary(
                  context: context, color: Colors.white),
            ),
            spacerH(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                spacerW(2),
                Flexible(
                    child: Text(
                  "$currency 0.0",
                  style: AppStyles.headingPrimary(
                      context: context, fontSize: 30, color: Colors.white),
                )),
              ],
            ),
            spacerH(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ReusableCardDetails(
                    color: Colors.white,
                    text: "Investment",
                    icon: Icons.arrow_circle_up_outlined,
                    amount: "0.0",
                    isShow: true,
                    onTap: () {},
                  ),
                ),
                spacerW(),
                Expanded(
                  child: ReusableCardDetails(
                    color: Colors.white,
                    text: "Invest Returns",
                    icon: Icons.arrow_circle_up_outlined,
                    amount: "0.0",
                    isShow: true,
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
                    text: "Tax Amount",
                    icon: Icons.arrow_circle_down_outlined,
                    amount: "00",
                    isShow: true,
                    isExpense: true,
                    onTap: () {},
                  ),
                ),
                spacerW(),
                Expanded(
                  child: ReusableCardDetails(
                    color: Colors.white,
                    text: "Total Tax %",
                    icon: Icons.arrow_circle_down_outlined,
                    amount: "00",
                    isShow: true,
                    isExpense: true,
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

  Widget transactionSection(BuildContext  context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "Recent Transactions",
            style: AppStyles.headingPrimary(context: context, fontSize: 19),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        spacerW(),
        ReusableOutlinedButton(onPressed: () {
          Navigator.pushNamed(context, Paths.allTransactionInvestAndTaxPage);
        })
      ],
    );
  }
}
