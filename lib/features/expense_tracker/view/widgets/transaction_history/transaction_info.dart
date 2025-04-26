import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import '../../../../../core/theme/app_styles.dart';
import '../../../viewmodel/riverpod/currency_provider.dart';
import '../../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../../../viewmodel/riverpod/transaction_provider.dart';
import '../reusable_list_view.dart';

class TransactionInfo extends ConsumerWidget {
  final bool isScrollable;

  const TransactionInfo({
    super.key,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final trackerList = ref.watch(filteredTransactionProvider);
    final isLoading = ref.watch(expenseTrackerProvider.notifier).isLoading;
    final currency = ref.watch(currencyProvider).symbol;
    return isLoading
        ? SizedBox(
            width: w,
            height: isScrollable ? h - 200 : 250,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : trackerList.isEmpty
            ? SizedBox(
                width: w,
                height: isScrollable ? h - 200 : 250,
                child: Center(
                  child: Text(
                    'No transactions found',
                    style: AppStyles.descriptionPrimary(
                      context: context,
                    ),
                  ),
                ),
              )
            : isScrollable
                ? Expanded(
                    child: ReusableListView(
                      trackerList: trackerList,
                      currency: currency,
                      isScrollable: isScrollable,
                    ),
                  )
                : ReusableListView(
                    trackerList: trackerList,
                    currency: currency,
                    isScrollable: isScrollable,
                  );
  }
}

//  Widget reusableListView(
//       {required final trackerList,
//       required final theme,
//       required final context,
//       required final rProvider,
//       required final double w,
//       required final currency}) {
//     return ListView.builder(
//       shrinkWrap: !isScrollable,
//       physics: isScrollable
//           ? AlwaysScrollableScrollPhysics()
//           : const NeverScrollableScrollPhysics(),
//       // reverse: true,
//       padding: const EdgeInsets.only(bottom: 100),
//       itemBuilder: (context, index) {
//         TrackerModel tl = trackerList[index];
//         IconData icon = Icons.arrow_circle_up_outlined;
//         Color color = Colors.green;
//         double totalReturns = tl.amount * (tl.percentage / 100);
//         double currentAmount = tl.amount + totalReturns;
//         double totalTax = tl.amount * (tl.percentage / 100);
//         double netAmountAfterTax = tl.amount - totalTax;
//
//         switch (tl.trackerCategory) {
//           case 0:
//             icon = Icons.arrow_circle_up_outlined;
//             color = Colors.green;
//             break;
//           case 1:
//             icon = Icons.arrow_circle_down_outlined;
//             color = Colors.red;
//             break;
//           case 3:
//             icon = Icons.receipt_long;
//             color = Colors.redAccent;
//             break;
//           case 2:
//             icon = FontAwesomeIcons.sackDollar;
//             color = Colors.blueAccent;
//             break;
//         }
//
//         bool isTax = tl.trackerCategory == ExpenseType.tax.intValue;
//         bool isInvestment =
//             tl.trackerCategory == ExpenseType.investment.intValue;
//         Color detailsColors = isTax
//             ? (tl.percentage > 0 ? Colors.red : theme.onSurface)
//             : (tl.percentage > 0
//                 ? Colors.green
//                 : (tl.percentage < 0 ? Colors.red : theme.onSurface));
//
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             (isTax || isInvestment)
//                 ? Container(
//                     width: w,
//                     margin: const EdgeInsets.only(bottom: 5),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                                 backgroundColor: color,
//                                 radius: 20,
//                                 child: Icon(icon, color: Colors.white)),
//                             spacerW(),
//                             SizedBox(
//                               width: w * 0.5,
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     tl.title,
//                                     style: AppStyles.headingPrimary(
//                                         context: context, fontSize: 17),
//                                   ),
//                                   spacerH(2),
//                                   transactionsDetails(
//                                       title: isTax
//                                           ? "Before Tax:"
//                                           : "Invested Amt:",
//                                       value: tl.amount.toStringAsFixed(2),
//                                       context: context,
//                                       color: theme.onSurface),
//                                   spacerH(2),
//                                   transactionsDetails(
//                                       title:
//                                           isTax ? "After Tax:" : "Current Amt:",
//                                       value: isTax
//                                           ? netAmountAfterTax.toStringAsFixed(2)
//                                           : currentAmount.toStringAsFixed(2),
//                                       context: context,
//                                       color: detailsColors),
//                                   spacerH(2),
//                                   transactionsDetails(
//                                       title: (!isTax)
//                                           ? "Total Return:"
//                                           : "Total Tax:",
//                                       value: isTax
//                                           ? totalTax.toStringAsFixed(2)
//                                           : totalReturns.toStringAsFixed(2),
//                                       context: context,
//                                       color: detailsColors),
//                                   spacerH(2),
//                                   transactionsDetails(
//                                       title: !isTax ? "Return %:" : "Tax %:",
//                                       value: tl.percentage.toStringAsFixed(2),
//                                       context: context,
//                                       color: detailsColors),
//                                   spacerH(2),
//                                 ],
//                               ),
//                             ),
//                             Spacer(),
//                             reusableTrailingContent(
//                                 tl, theme, context, rProvider),
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//                 : ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     leading: Icon(icon, color: color, size: 40),
//                     title: Text(
//                       tl.title,
//                       style: AppStyles.headingPrimary(
//                           context: context, fontSize: 17),
//                     ),
//                     subtitle: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 3),
//                           child: Icon(
//                             (tl.trackerCategory == ExpenseType.tax.intValue ||
//                                     tl.trackerCategory ==
//                                         ExpenseType.expense.intValue)
//                                 ? Icons.remove
//                                 : Icons.add,
//                             color: color,
//                             size: 20,
//                           ),
//                         ),
//                         spacerW(2),
//                         Flexible(
//                             child: Text(
//                           "$currency ${tl.amount}",
//                           style: AppStyles.headingPrimary(
//                             context: context,
//                             fontSize: 17,
//                             color: color,
//                           ),
//                         )),
//                       ],
//                     ),
//                     trailing:
//                         reusableTrailingContent(tl, theme, context, rProvider),
//                   ),
//             const Divider()
//           ],
//         );
//       },
//       itemCount: trackerList.length,
//     );
//   }
//
//   Widget transactionsDetails({
//     required String title,
//     required String value,
//     required BuildContext context,
//     required Color color,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: AppStyles.descriptionPrimary(
//               context: context, fontWeight: FontWeight.w600, fontSize: 14),
//         ),
//         spacerW(5),
//         Flexible(
//           child: Text(
//             value,
//             style: AppStyles.descriptionPrimary(
//                 context: context, color: color, fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget reusableTrailingContent(
//       var tl, final theme, final context, final rProvider) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(tl.date,
//             style:
//                 AppStyles.descriptionPrimary(context: context, fontSize: 13)),
//         spacerH(5),
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             InkWell(
//               onTap: () {
//                 Navigator.pushNamed(context, Paths.expenseManagementPage,
//                     arguments: tl);
//               },
//               child: Icon(
//                 Icons.edit,
//                 color: theme.primary,
//                 size: 25,
//               ),
//             ),
//             spacerW(10),
//             InkWell(
//               onTap: () async {
//                 await ReusableDialogClass.deletedTransactionDialog(context, () {
//                   rProvider.deleteData(tl.id!);
//                   Navigator.of(context).pop();
//                 });
//               },
//               child: Icon(
//                 Icons.delete,
//                 color: Colors.red,
//                 size: 25,
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }

//Row(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Padding(
//                                   padding:
//                                   const EdgeInsets.only(
//                                       top: 3),
//                                   child: Icon(
//                                     (tl.trackerCategory ==
//                                         ExpenseType.tax
//                                             .intValue ||
//                                         tl.trackerCategory ==
//                                             ExpenseType
//                                                 .expense
//                                                 .intValue)
//                                         ? Icons.remove
//                                         : Icons.add,
//                                     color: color,
//                                     size: 20,
//                                   ),
//                                 ),
//                                 spacerW(2),
//                                 Flexible(
//                                     child: Text(
//                                       "$currency ${tl.amount}",
//                                       style:
//                                       AppStyles.headingPrimary(
//                                         context: context,
//                                         fontSize: 17,
//                                         color: color,
//                                       ),
//                                     )),
//                               ],
//                             ),

// final trackerList = isTransactionPage
//     ? ref.watch(filteredTransactionProvider)
//     : ref.watch(expenseTrackerProvider).trackers;

// InvestmentModel iModel = InvestmentModel(
//     currentAmount: "0",
//     investedAmount: "0",
//     totalReturns: "0",
//     returnsPercentage: "0");
// TaxModel tModel = TaxModel(
//     netAmountAfterTax: "0",
//     taxableAmount: "0",
//     totalTax: "0",
//     taxPercentage: "0");

// iModel = getInvestmentDetails(
//     investedAmount: tl.amount, returnsPercentage: tl.percentage);

// tModel = getTaxDetails(taxableAmount: tl.amount, taxPercentage: tl.percentage);
