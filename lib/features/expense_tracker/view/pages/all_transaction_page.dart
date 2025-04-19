import 'package:budgify/features/expense_tracker/view/pages/expense_tracker_page.dart';
import 'package:budgify/features/expense_tracker/view/widgets/transaction_info.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/routes/paths.dart';
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import 'expense_management_page.dart';

class AllTransactionPage extends StatelessWidget {
  const AllTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: ReusableAppBar(
        text: "All Transactions",
        isCenterText: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            spacerH(),
            CurrencyPicker(),
            spacerH(10),
            transactionFilter(theme),
            spacerH(10),
            DateFilter(),
            spacerH(10),
            TransactionInfo(isTransactionPage: true,),
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
        categories: TransactionType.values.map((e)=> e.value).toList(),
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
}
