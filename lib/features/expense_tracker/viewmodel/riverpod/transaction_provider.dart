import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../model/tracker_model.dart';
import '../../utils/expense_type.dart';
import '../../utils/transaction_type.dart';
import 'expense_tracker_notifier.dart';

final transactionProvider =
StateProvider<String>((ref) => TransactionType.allTransactions.value);


final filteredTransactionProvider = Provider<List<TrackerModel>>((ref) {
  final filter = ref.watch(transactionProvider);
  final allData = ref.watch(expenseTrackerProvider).trackers;

  List<TrackerModel> filteredList = [];

  if (filter == TransactionType.mostExpensive.value) {
    filteredList = allData
        .where((tracker) =>
    tracker.trackerCategory == ExpenseType.expense.intValue)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
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
      ..sort((a, b) => a.amount.compareTo(b.amount));
  } else if (filter == TransactionType.transactionsNewestToOldest.value) {
    filteredList = allData.toList()
      ..sort((a, b) =>
          parseDate(b.date).compareTo(parseDate(a.date))); // Newest to Oldest
  } else if (filter == TransactionType.mostIncome.value) {
    filteredList = allData
        .where(
            (tracker) => tracker.trackerCategory == ExpenseType.income.intValue)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  } else if (filter == TransactionType.leastIncome.value) {
    filteredList = allData
        .where(
            (tracker) => tracker.trackerCategory == ExpenseType.income.intValue)
        .toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  } else if (filter == TransactionType.transactionsOldestToNewest.value) {
    filteredList = allData.toList()
      ..sort((a, b) =>
          parseDate(a.date).compareTo(parseDate(b.date))); // Oldest to Newest
  } else {
    filteredList = allData;
  }
  return filteredList;
});