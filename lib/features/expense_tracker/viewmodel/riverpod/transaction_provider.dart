import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../model/tracker_model.dart';
import '../../model/transaction_summary.dart';
import '../../utils/expense_type.dart';
import '../../utils/transaction_type.dart';
import 'expense_tracker_notifier.dart';

final transactionProvider =
StateProvider<String>((ref) => TransactionType.allTransactions.value);

final filteredTransactionProvider = Provider<TransactionSummary>((ref) {
  final wProvider = ref.watch(expenseTrackerDateFiltered).trackerCategory;

  double totalBalance = 0.0, totalIncome = 0.0, totalExpense = 0.0;
  final isExcludeInvestmentAndTax = ref.watch(transactionProvider) ==
      TransactionType.excludingInvestmentAndTax.value;

  if (isExcludeInvestmentAndTax) {
    totalBalance = wProvider.totalIncome - wProvider.totalExpense;
    totalIncome = wProvider.totalIncome;
    totalExpense = wProvider.totalExpense;
  } else {
    totalBalance = wProvider.totalIncome -
        wProvider.totalExpense +
        wProvider.investment -
        wProvider.tax;
    if (wProvider.investment > 0) {
      totalIncome += wProvider.investment + wProvider.totalIncome;
      totalExpense += wProvider.totalExpense - wProvider.tax;
    } else {
      totalIncome += wProvider.totalIncome;
      totalExpense +=
          wProvider.totalExpense - wProvider.tax - wProvider.investment;
    }
  }


  final filter = ref.watch(transactionProvider);
  final allData = ref.watch(expenseTrackerProvider).trackers;

  List<TrackerModel> filteredList = [];

  if (filter == TransactionType.mostExpensive.value) {
    filteredList = allData
        .where((tracker) =>
    tracker.trackerCategory == ExpenseType.expense.intValue)
        .toList()
      ..sort((a, b) => b.amount!.compareTo(a.amount!));
  } else if (filter == TransactionType.excludingInvestmentAndTax.value) {
    filteredList = allData
        .where((tracker) =>
    (tracker.trackerCategory != ExpenseType.investment.intValue) &&
        (tracker.trackerCategory != ExpenseType.tax.intValue))
        .toList();
  } else if (filter == TransactionType.leastExpensive.value) {
    filteredList = allData
        .where((tracker) =>
    tracker.trackerCategory == ExpenseType.expense.intValue)
        .toList()
      ..sort((a, b) => a.amount!.compareTo(b.amount!));
  } else if (filter == TransactionType.transactionsNewestToOldest.value) {
    filteredList = allData.toList()
      ..sort((a, b) =>
          parseDate(b.date).compareTo(parseDate(a.date))); // Newest to Oldest
  } else if (filter == TransactionType.mostIncome.value) {
    filteredList = allData
        .where(
            (tracker) => tracker.trackerCategory == ExpenseType.income.intValue)
        .toList()
      ..sort((a, b) => b.amount!.compareTo(a.amount!));
  } else if (filter == TransactionType.leastIncome.value) {
    filteredList = allData
        .where(
            (tracker) => tracker.trackerCategory == ExpenseType.income.intValue)
        .toList()
      ..sort((a, b) => a.amount!.compareTo(b.amount!));
  } else if (filter == TransactionType.transactionsOldestToNewest.value) {
    filteredList = allData.toList()
      ..sort((a, b) =>
          parseDate(a.date).compareTo(parseDate(b.date))); // Oldest to Newest
  } else {
    filteredList = allData;
  }
  return TransactionSummary(
      trackerModel: filteredList,
      transactionModel: TransactionModel(
        income: totalIncome.toStringAsFixed(2),
        expense: totalExpense.toStringAsFixed(2),
        totalBalance: totalBalance.toStringAsFixed(2),
      ));
});