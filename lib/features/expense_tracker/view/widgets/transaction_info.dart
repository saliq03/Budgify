import 'package:budgify/features/expense_tracker/utils/expense_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import 'dialog/reusable_dialog_class.dart';

class TransactionInfo extends ConsumerWidget {
  // final bool isTransactionPage;

  const TransactionInfo({
    super.key,
    // this.isTransactionPage = false
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    // final trackerList = isTransactionPage
    //     ? ref.watch(filteredTransactionProvider)
    //     : ref.watch(expenseTrackerProvider).trackers;
    final trackerList = ref.watch(filteredTransactionProvider);
    final isLoading = ref.watch(expenseTrackerProvider.notifier).isLoading;
    final currency = ref.watch(currencyProvider).symbol;
    final rProvider = ref.read(expenseTrackerProvider.notifier);

    return isLoading
        ? SizedBox(
            width: w,
            height: 250,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : trackerList.isEmpty
            ? SizedBox(
                width: w,
                height: 250,
                child: Center(
                  child: Text(
                    'No transactions found',
                    style: AppStyles.descriptionPrimary(
                      context: context,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                      icon = FontAwesomeIcons.moneyBillWave;
                      color = Colors.redAccent;
                      break;
                    case 2:
                      icon = FontAwesomeIcons.chartLine;
                      color = Colors.blueAccent;
                      break;
                  }

                  return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(icon, color: color, size: 40),
                      title: Text(
                        tl.title,
                        style: AppStyles.headingPrimary(
                            context: context, fontSize: 18),
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
                              fontSize: 18,
                              color: color,
                            ),
                          )),
                        ],
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(tl.date,
                              style: AppStyles.descriptionPrimary(
                                  context: context, fontSize: 13)),
                          spacerH(5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Paths.expenseManagementPage,
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
                                  await ReusableDialogClass
                                      .deletedTransactionDialog(context, () {
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
                      ));
                },
                itemCount: trackerList.length,
              );
  }
}
