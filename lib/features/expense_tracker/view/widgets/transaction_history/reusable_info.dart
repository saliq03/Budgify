import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/routes/paths.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../shared/view/widgets/global_widgets.dart';
import '../../../utils/expense_type.dart';
import '../../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../dialog/reusable_dialog_class.dart';

class ReusableInfo extends ConsumerWidget {
  final bool isTaxPage;
  final bool isScrollable;

  const ReusableInfo({
    super.key,
    this.isTaxPage = true,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerList = isTaxPage
        ? ref.watch(filteredTaxProvider).trackerModel
        : ref.watch(filteredInvestmentProvider).trackerModel;
    final isLoading = ref.watch(expenseTrackerProvider.notifier).isLoading;
    final currency = ref.watch(currencyProvider).symbol;
    final rProvider = isTaxPage
        ? ref.read(taxProvider.notifier)
        : ref.read(investmentProvider.notifier);
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final theme = Theme.of(context).colorScheme;
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
                    isTaxPage ? 'No Tax History' : 'No Investment History',
                    style: AppStyles.descriptionPrimary(
                      context: context,
                    ),
                  ),
                ),
              )
            : isScrollable
                ? Expanded(
                    child: reusableListView(
                      trackerList: trackerList,
                      theme: theme,
                      context: context,
                      rProvider: rProvider,
                      w: w,
                      currency: currency,
                    ),
                  )
                : reusableListView(
                    trackerList: trackerList,
                    theme: theme,
                    context: context,
                    rProvider: rProvider,
                    w: w,
                    currency: currency,
                  );
  }

  Widget reusableListView(
      {required final trackerList,
      required final theme,
      required final context,
      required final rProvider,
      required final double w,
      required final currency}) {
    return ListView.builder(
      shrinkWrap: !isScrollable,
      physics: isScrollable
          ? AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      // reverse: true,
      padding: const EdgeInsets.only(bottom: 100),
      itemBuilder: (context, index) {
        var tl = trackerList[index];
        IconData icon = Icons.arrow_circle_up_outlined;
        Color color = Colors.green;

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

        bool isTax = tl.trackerCategory == ExpenseType.tax.intValue;
        bool isInvestment =
            tl.trackerCategory == ExpenseType.investment.intValue;

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
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Icon(
                                          (tl.trackerCategory ==
                                                      ExpenseType
                                                          .tax.intValue ||
                                                  tl.trackerCategory ==
                                                      ExpenseType
                                                          .expense.intValue)
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
                                  spacerH(2),
                                  Row(
                                    children: [
                                      Text(
                                        isTax ? "Tax:" : "Return:",
                                        style: AppStyles.descriptionPrimary(
                                            context: context, fontSize: 14),
                                      ),
                                      spacerW(5),
                                      Text(
                                        "${tl.percentage}%",
                                        style: AppStyles.descriptionPrimary(
                                            context: context, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  spacerH(2),
                                  Row(
                                    children: [
                                      Text(
                                        isInvestment
                                            ? "Invested Amount :"
                                            : "Original Amount :",
                                        style: AppStyles.descriptionPrimary(
                                            context: context, fontSize: 14),
                                      ),
                                      Text(
                                        "${0}",
                                        style: AppStyles.descriptionPrimary(
                                            context: context, fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Spacer(),
                            reusableTrailingContent(
                                tl, theme, context, rProvider),
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
                        reusableTrailingContent(tl, theme, context, rProvider),
                  ),
            const Divider()
          ],
        );
      },
      itemCount: trackerList.length,
    );
  }

  Widget reusableTrailingContent(
      var tl, final theme, final context, final rProvider) {
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
            InkWell(
              onTap: () async {
                await ReusableDialogClass.deletedTransactionDialog(context, () {
                  rProvider.deleteData(tl.id!);
                  Navigator.of(context).pop();
                });
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 25,
              ),
            ),
          ],
        )
      ],
    );
  }
}
