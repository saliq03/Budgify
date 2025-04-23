import 'package:budgify/features/expense_tracker/view/widgets/transaction_filter/transaction_filter1.dart';
import 'package:budgify/features/expense_tracker/view/widgets/transaction_info.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/routes/paths.dart';
import '../../../../shared/view/widgets/currency_picker.dart';
import '../../../../shared/view/widgets/date_filter.dart';
import '../../utils/transaction_type.dart';
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../widgets/custom_drop_down.dart';

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
            TransactionFilter1(),
            spacerH(10),
            DateFilter(),
            spacerH(10),
            TransactionInfo(),
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
}
