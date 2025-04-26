import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../model/tracker_model.dart';
import '../../utils/expense_type.dart';
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import 'dialog/reusable_dialog_class.dart';

class ReusableListView extends StatelessWidget {
  final List<TrackerModel> trackerList;
  final String currency;
  final bool isScrollable;

  const ReusableListView(
      {super.key,
      required this.trackerList,
      required this.currency,
      required this.isScrollable});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: !isScrollable,
      physics: isScrollable
          ? AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      // reverse: true,
      padding: const EdgeInsets.only(bottom: 100),
      itemBuilder: (context, index) {
        final TrackerModel tl = trackerList[index];
        IconData icon = Icons.arrow_circle_up_outlined;
        Color color = Colors.green;
        double totalReturns = 0;
        double currentAmount = 0;
        double totalTax = 0;
        double netAmountAfterTax = 0;

        bool isTax = tl.trackerCategory == ExpenseType.tax.intValue;
        bool isInvestment =
            tl.trackerCategory == ExpenseType.investment.intValue;

        if (isInvestment) {
          totalReturns = tl.amount * (tl.percentage / 100);
          currentAmount = tl.amount + totalReturns;
        } else if (isTax) {
          totalTax = tl.amount * (tl.percentage / 100);
          netAmountAfterTax = tl.amount - totalTax;
        }

        switch (tl.trackerCategory) {
          case 0:
            icon = Icons.arrow_circle_up_outlined;
            color = Colors.green;
            break;
          case 1:
            icon = Icons.arrow_circle_down_outlined;
            color = Colors.red;
            break;
          case 3:
            icon = Icons.receipt_long;
            color = Colors.redAccent;
            break;
          case 2:
            icon = FontAwesomeIcons.sackDollar;
            color = Colors.blueAccent;
            break;
        }

        Color detailsColors = isTax
            ? (tl.percentage > 0 ? Colors.red : theme.onSurface)
            : (tl.percentage > 0
                ? Colors.green
                : (tl.percentage < 0 ? Colors.red : theme.onSurface));

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (isTax || isInvestment)
                ? Container(
                    width: w,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: color,
                                radius: 20,
                                child: Icon(icon, color: Colors.white)),
                            spacerW(),
                            SizedBox(
                              width: w * 0.5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tl.title,
                                    style: AppStyles.headingPrimary(
                                        context: context, fontSize: 17),
                                  ),
                                  spacerH(2),
                                  transactionsDetails(
                                      title: isTax
                                          ? "Before Tax:"
                                          : "Invested Amt:",
                                      value:
                                          "$currency ${tl.amount.toStringAsFixed(2)}",
                                      context: context,
                                      color: theme.onSurface),
                                  spacerH(2),
                                  transactionsDetails(
                                      title:
                                          isTax ? "After Tax:" : "Current Amt:",
                                      value: isTax
                                          ? "$currency ${netAmountAfterTax.toStringAsFixed(2)}"
                                          : "$currency ${currentAmount.toStringAsFixed(2)}",
                                      context: context,
                                      color: detailsColors),
                                  spacerH(2),
                                  transactionsDetails(
                                      title: (!isTax)
                                          ? "Total Return:"
                                          : "Total Tax:",
                                      value: isTax
                                          ? "$currency ${totalTax.toStringAsFixed(2)}"
                                          : "$currency ${totalReturns.toStringAsFixed(2)}",
                                      context: context,
                                      color: detailsColors),
                                  spacerH(2),
                                  transactionsDetails(
                                      title: !isTax ? "Return %:" : "Tax %:",
                                      value: tl.percentage.toStringAsFixed(2),
                                      context: context,
                                      color: detailsColors),
                                  spacerH(2),
                                ],
                              ),
                            ),
                            Spacer(),
                            reusableTrailingContent(
                                tl, theme, context),
                          ],
                        )
                      ],
                    ),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(icon, color: color, size: 40),
                    title: Text(
                      tl.title,
                      style: AppStyles.headingPrimary(
                          context: context, fontSize: 17),
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Icon(
                            (tl.trackerCategory == ExpenseType.tax.intValue ||
                                    tl.trackerCategory ==
                                        ExpenseType.expense.intValue)
                                ? Icons.remove
                                : Icons.add,
                            color: color,
                            size: 20,
                          ),
                        ),
                        spacerW(2),
                        Flexible(
                            child: Text(
                          "$currency ${tl.amount}",
                          style: AppStyles.headingPrimary(
                            context: context,
                            fontSize: 17,
                            color: color,
                          ),
                        )),
                      ],
                    ),
                    trailing:
                        reusableTrailingContent(tl, theme, context,),
                  ),
            const Divider()
          ],
        );
      },
      itemCount: trackerList.length,
    );
  }

  Widget transactionsDetails({
    required String title,
    required String value,
    required BuildContext context,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.descriptionPrimary(
              context: context, fontWeight: FontWeight.w600, fontSize: 14),
        ),
        spacerW(5),
        Flexible(
          child: Text(
            value,
            style: AppStyles.descriptionPrimary(
                context: context, color: color, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget reusableTrailingContent(
      var tl, final theme, final context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(tl.date,
            style:
                AppStyles.descriptionPrimary(context: context, fontSize: 13)),
        spacerH(5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Paths.expenseManagementPage,
                    arguments: tl);
              },
              child: Icon(
                Icons.edit,
                color: theme.primary,
                size: 25,
              ),
            ),
            spacerW(10),
            Consumer(
              builder: (context, ref, child) => InkWell(
                onTap: () async {
                  await ReusableDialogClass.deletedTransactionDialog(context, () {
                    ref.read(expenseTrackerProvider.notifier).deleteData(tl!.id);
                    Navigator.of(context).pop();
                  });
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 25,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
