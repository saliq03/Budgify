import 'package:budgify/core/theme/app_colors.dart';
import 'package:budgify/core/theme/app_gradients.dart';
import 'package:budgify/core/theme/app_styles.dart';
import 'package:budgify/features/expense_tracker/model/currency_model.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/routes/paths.dart';
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../widgets/buttons/reusable_outlined_button.dart';
import '../widgets/dialog/reusable_dialog_class.dart';
import '../widgets/drawer/custom_drawer.dart';
import '../widgets/reusable_card_details.dart';
import '../widgets/transaction_info.dart';
import 'expense_management_page.dart';

//
class ExpenseTrackerPage extends ConsumerStatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  ConsumerState<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends ConsumerState<ExpenseTrackerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(expenseTrackerProvider.notifier).init();
    });
  }

  void showCurrencyPickerDialog() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        ref.read(currencyProvider.notifier).state =
            CurrencyModel.fromJson(currency);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final theme = Theme.of(context).colorScheme;
    final currency = ref.watch(currencyProvider).symbol;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomDrawer(h: h, w: w * 0.7),
      appBar: ReusableAppBar(
        text: 'Expense Tracker',
        // text: 'Profile',
        isCenterText: false,
        isMenu: true,
        onPressed: () {
          _scaffoldKey.currentState!.openEndDrawer();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacerH(),
            transactionFilter(theme),
            spacerH(10),
            // CurrencyPicker(),
            // spacerH(10),
            DateFilter(),
            spacerH(10),
            cardSection(w, context, currency),
            spacerH(),
            transactionSection(),
            spacerH(10),
            transactionInfo(theme, currency)

            // TransactionInfo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Paths.expenseManagementPage);
        },
        backgroundColor: theme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget transactionFilter(final theme) {
    return Consumer(builder: (context, ref, child) {
      final selectedValue = ref.watch(transactionProvider);

      return CustomDropDown(
        icon: Icons.arrow_drop_down_rounded,
        categories: TransactionType.values.map((e) => e.value).toList(),
        leadingIconSize: 20,
        onChanged: (newValue) {
          if (newValue != null) {
            ref.read(transactionProvider.notifier).state = newValue;
          }
        },
        selectedValue: selectedValue,
        leadingIcon: FontAwesomeIcons.receipt,
        color: theme.onSurface,
        borderColor: theme.onSurface,
      );
    });
  }

  Widget cardSection(
      final double w, final BuildContext context, final currency) {
    final wProvider = ref.watch(expenseTrackerProvider.notifier);
    final positiveBalance = wProvider.totalBalance >= 0;
    final zeroBalance = wProvider.totalBalance == 0;
    final zeroIncome = wProvider.totalIncome == 0;
    final zeroExpense = wProvider.totalExpense == 0;
    final totalBalanceColor = zeroBalance
        ? Colors.white
        : positiveBalance
            ? AppColors.lightGreen
            : AppColors.lightRed;
    final incomeColor = zeroIncome ? Colors.white : AppColors.lightGreen;
    final expenseColor = zeroExpense ? Colors.white : AppColors.lightRed;
    // Reverse the list to show latest items first

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
                  context: context, color: totalBalanceColor),
            ),
            spacerH(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!zeroBalance)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(
                      positiveBalance ? Icons.add : Icons.remove,
                      color: totalBalanceColor,
                      size: 20,
                    ),
                  ),
                spacerW(2),
                Flexible(
                    child: InkWell(
                  onTap: showCurrencyPickerDialog,
                  child: Text(
                    "$currency ${wProvider.totalBalance.abs()}",
                    style: AppStyles.headingPrimary(
                        context: context,
                        fontSize: 30,
                        color: totalBalanceColor),
                  ),
                )),
              ],
            ),
            spacerH(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ReusableCardDetails(
                    color: incomeColor,
                    text: "Income",
                    icon: Icons.arrow_circle_up_outlined,
                    amount: "$currency ${wProvider.totalIncome}",
                    isShow: !zeroIncome,
                    onTap: showCurrencyPickerDialog,
                  ),
                ),
                spacerW(),
                Expanded(
                  child: ReusableCardDetails(
                    color: expenseColor,
                    text: "Expense",
                    icon: Icons.arrow_circle_down_outlined,
                    amount: "$currency ${wProvider.totalExpense}",
                    isShow: !zeroExpense,
                    isExpense: true,
                    onTap: showCurrencyPickerDialog,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget transactionSection() {
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
          Navigator.pushNamed(context, Paths.allTransactionPage);
        })
      ],
    );
  }

  Widget transactionInfo(final ColorScheme theme, final currency) {
    final trackerList = ref.watch(filteredTransactionProvider);
    final isLoading = ref.watch(expenseTrackerProvider.notifier).isLoading;
    final rProvider = ref.read(expenseTrackerProvider.notifier);
    return Expanded(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : trackerList.isEmpty
              ? Center(
                  child: Text(
                    'No transactions found',
                    style: AppStyles.descriptionPrimary(
                      context: context,
                    ),
                  ),
                )
              : ListView.builder(
                  // reverse: true,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemBuilder: (context, index) {
                    var tl = trackerList[index];

                    return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                            tl.isExpense
                                ? Icons.arrow_circle_down_outlined
                                : Icons.arrow_circle_up_outlined,
                            color: tl.isExpense ? Colors.red : Colors.green,
                            size: 40),
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
                                tl.isExpense ? Icons.remove : Icons.add,
                                color: tl.isExpense ? Colors.red : Colors.green,
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
                                color: tl.isExpense ? Colors.red : Colors.green,
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
                ),
    );
  }
}

class CurrencyPicker extends ConsumerWidget {
  const CurrencyPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final theme = Theme.of(context).colorScheme;
    final double w = MediaQuery.of(context).size.width;
    final rProvider = ref.read(currencyProvider.notifier);
    return Container(
      width: w,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.surface,
        border: Border.all(
          width: 1,
          color: theme.onSurface,
        ),
      ),
      child: InkWell(
        onTap: () {
          showCurrencyPicker(
            context: context,
            showFlag: true,
            showCurrencyName: true,
            showCurrencyCode: true,
            onSelect: (Currency currency) {
              rProvider.state = CurrencyModel.fromJson(currency);
              // print(currency.name);
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Text(
              "${currency.name} - ${currency.code} - ${currency.symbol}",
              style: AppStyles.descriptionPrimary(context: context),
            )),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: theme.onSurface,
            )
          ],
        ),
      ),
    );
  }
}

class DateFilter extends StatelessWidget {
  const DateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ShowDate()),
        spacerW(8),
        Icon(Icons.remove),
        spacerW(8),
        Expanded(child: ShowDate())
      ],
    );
  }
}

class ShowDate extends StatelessWidget {
  const ShowDate({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 45,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.primary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: Colors.white,
                size: 20,
              ),
              spacerW(8),
              Text(
                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                style: AppStyles.descriptionPrimary(
                    context: context, color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ));
  }
}

// class ExpenseTrackerPage extends ConsumerStatefulWidget {
//   const ExpenseTrackerPage({super.key});
//
//   @override
//   ConsumerState<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
// }
//
// class _ExpenseTrackerPageState extends ConsumerState<ExpenseTrackerPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(expenseTrackerProvider.notifier).init();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     final theme = Theme.of(context).colorScheme;
//     final rProvider=ref.read(currencyProvider.notifier);
//     final currency = ref.watch(currencyProvider);
//     return Scaffold(
//       key: _scaffoldKey,
//       endDrawer: CustomDrawer(h: h, w: w * 0.7),
//       appBar: ReusableAppBar(
//         text: 'Expense Tracker',
//         // text: 'Profile',
//         isCenterText: false,
//         isMenu: true,
//         onPressed: () {
//           _scaffoldKey.currentState!.openEndDrawer();
//         },
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             spacerH(),
//             Container(
//               width: w,
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: theme.surface,
//                 border: Border.all(
//                   width: 1,
//                   color: theme.onSurface,
//                 ),
//               ),
//               child: InkWell(
//                 onTap: (){
//                   showCurrencyPicker(
//                     context: context,
//                     showFlag: true,
//                     showCurrencyName: true,
//                     showCurrencyCode: true,
//                     onSelect: (Currency currency) {
//                       rProvider.state=CurrencyModel.fromJson(currency);
//                       // print(currency.name);
//                     },
//                   );
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(child: Text("${currency.name} - ${currency.code} - ${currency.symbol}",style: AppStyles.descriptionPrimary(context: context),)),
//                     Icon(
//                       Icons.arrow_drop_down_rounded,
//                       color: theme.onSurface,
//                     )
//
//                   ],
//                 ),
//               ),
//             ),
//             spacerH(),
//             cardSection(w, context,currency.symbol),
//             spacerH(),
//             transactionSection(),
//             spacerH(10),
//             transactionInfo(theme,currency.symbol),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, Paths.expenseManagementPage);
//         },
//         backgroundColor: theme.primary,
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   Widget cardSection(final double w, final BuildContext context,final currency) {
//     final wProvider =ref.watch(expenseTrackerProvider.notifier);
//     final positiveBalance = wProvider.totalBalance >= 0;
//     final zeroBalance = wProvider.totalBalance == 0;
//     final zeroIncome = wProvider.totalIncome == 0;
//     final zeroExpense = wProvider.totalExpense == 0;
//     final totalBalanceColor= zeroBalance? Colors.white :positiveBalance ? AppColors.lightGreen : AppColors.lightRed;
//     final incomeColor=zeroIncome ?Colors.white: AppColors.lightGreen;
//     final expenseColor=zeroExpense ?Colors.white: AppColors.lightRed;
//     // Reverse the list to show latest items first
//
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Container(
//         width: w,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 colors: AppGradients.skyBlueMyAppGradient,
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight),
//             borderRadius: BorderRadius.circular(15)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Total Balance",
//               style: AppStyles.descriptionPrimary(
//                   context: context, color: totalBalanceColor),
//             ),
//             spacerH(5),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if(!zeroBalance)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12),
//                     child: Icon(
//                       positiveBalance
//                           ? Icons.add
//                           : Icons.remove,
//                       color:totalBalanceColor,
//                       size: 20,
//                     ),
//                   ),
//                 spacerW(2),
//                 Flexible(
//                     child: Text("$currency ${wProvider.totalBalance.abs()}",
//                       style: AppStyles.headingPrimary(
//                           context: context, fontSize: 30, color: totalBalanceColor),
//                     )),
//               ],
//             ),
//             spacerH(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: ReusableCardDetails(
//                     color: incomeColor,
//                     text: "Income",
//                     icon: Icons.arrow_circle_up_outlined,
//                     amount: "$currency ${wProvider.totalIncome}", isShow: !zeroIncome,
//                   ),
//                 ),
//                 spacerW(),
//                 Expanded(
//                   child: ReusableCardDetails(
//                     color: expenseColor,
//                     text: "Expense",
//                     icon: Icons.arrow_circle_down_outlined,
//                     amount: "$currency ${wProvider.totalExpense}", isShow: !zeroExpense,
//                     isExpense: true,
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget transactionSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Flexible(
//           child: Text(
//             "Recent Transactions",
//             style: AppStyles.headingPrimary(context: context, fontSize: 19),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//         ),
//         spacerW(),
//         ReusableOutlinedButton(onPressed: () {})
//       ],
//     );
//   }
//
//   Widget transactionInfo(final ColorScheme theme,final currency) {
//     final trackerList = ref.watch(expenseTrackerProvider).reversed.toList();
//     final isLoading = ref.watch(expenseTrackerProvider.notifier).isLoading;
//     final rProvider = ref.read(expenseTrackerProvider.notifier);
//     return Expanded(
//       child: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : trackerList.isEmpty
//           ? Center(
//         child: Text(
//           'No transactions found',
//           style: AppStyles.descriptionPrimary(
//             context: context,
//           ),
//         ),
//       )
//           : ListView.builder(
//         // reverse: true,
//         padding: const EdgeInsets.only(bottom: 100),
//         itemBuilder: (context, index) {
//           var tl = trackerList[index];
//
//           return ListTile(
//               contentPadding: EdgeInsets.zero,
//               leading: Icon(
//                   tl.isExpense
//                       ? Icons.arrow_circle_down_outlined
//                       : Icons.arrow_circle_up_outlined,
//                   color: tl.isExpense ? Colors.red : Colors.green,
//                   size: 40),
//               title: Text(
//                 tl.title,
//                 style: AppStyles.headingPrimary(
//                     context: context, fontSize: 18),
//               ),
//               subtitle: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 3),
//                     child: Icon(
//                       tl.isExpense ? Icons.remove : Icons.add,
//                       color: tl.isExpense ? Colors.red : Colors.green,
//                       size: 20,
//                     ),
//                   ),
//                   spacerW(2),
//                   Flexible(
//                       child: Text("$currency ${tl.amount}",
//                         style: AppStyles.headingPrimary(
//                           context: context,
//                           fontSize: 18,
//                           color: tl.isExpense ? Colors.red : Colors.green,
//                         ),
//                       )),
//                 ],
//               ),
//               trailing: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(tl.date,
//                       style: AppStyles.descriptionPrimary(
//                           context: context, fontSize: 13)),
//                   spacerH(5),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pushNamed(
//                               context, Paths.expenseManagementPage,
//                               arguments: tl);
//                         },
//                         child: Icon(
//                           Icons.edit,
//                           color: theme.primary,
//                           size: 25,
//                         ),
//                       ),
//                       spacerW(10),
//                       InkWell(
//                         onTap: () async {
//                           await ReusableDialogClass
//                               .deletedTransactionDialog(context, () {
//                             rProvider.deleteData(tl.id!);
//                             Navigator.of(context).pop();
//                           });
//                         },
//                         child: Icon(
//                           Icons.delete,
//                           color: Colors.red,
//                           size: 25,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ));
//         },
//         itemCount: trackerList.length,
//       ),
//     );
//   }
// }
