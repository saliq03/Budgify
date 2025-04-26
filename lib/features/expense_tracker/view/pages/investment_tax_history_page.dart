import 'package:budgify/features/expense_tracker/view/widgets/transaction_history/transaction_info.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/paths.dart';
import '../../../../shared/view/widgets/currency_picker.dart';
import '../../../../shared/view/widgets/date_filter.dart';
import '../widgets/filters/investment_filter.dart';
import '../widgets/filters/tax_filter.dart';
import '../widgets/transaction_history/reusable_info.dart';

class InvestmentTaxHistoryPage extends StatelessWidget {
  final bool isTaxPage;

  const InvestmentTaxHistoryPage({super.key, this.isTaxPage = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: ReusableAppBar(
        text: isTaxPage ? "Tax History" : "Investment History",
        isCenterText: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            spacerH(),
            CurrencyPicker(),
            spacerH(10),
            isTaxPage ? TaxFilter() : InvestmentFilter(),
            spacerH(10),
            DateFilter(),
            spacerH(10),
            ReusableInfo(
              isTaxPage: isTaxPage,
              isScrollable: true,
            )
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
