import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/view/widgets/global_widgets.dart';
import '../../model/investment_summary.dart';
import '../../model/tracker_model.dart';
import '../../utils/expense_type.dart';
import '../../utils/investment_type.dart';
import 'expense_tracker_notifier.dart';

final investmentProvider =
StateProvider<String>((ref) => InvestmentType.investmentLatestFirst.value);



final filteredInvestmentProvider = Provider<InvestmentSummary>((ref) {
  final filter = ref.watch(investmentProvider);
  final allData = ref.watch(expenseTrackerProvider).trackers;

  List<TrackerModel> filteredList = [];
  double currentAmount = 0.0;
  double investedAmount = 0.0;
  double totalReturns = 0.0;
  double returnsPercentage = 0.0;

  if (filter == InvestmentType.investmentLatestFirst.value) {
    filteredList = allData
        .where((tracker) =>
    tracker.trackerCategory == ExpenseType.investment.intValue)
        .toList()
      ..sort((a, b) => parseDate(b.date).compareTo(parseDate(a.date)));

    // Newest to Oldest
  } else if (filter == InvestmentType.investmentOldestFirst.value) {
    filteredList = allData
        .where((tracker) =>
    tracker.trackerCategory == ExpenseType.investment.intValue)
        .toList()
      ..sort((a, b) =>
          parseDate(a.date).compareTo(parseDate(b.date))); // Oldest to Newest
  } else if (filter == InvestmentType.investmentHighToLow.value) {
    filteredList = allData
        .where((tracker) =>
    tracker.trackerCategory == ExpenseType.investment.intValue)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  } else if (filter == InvestmentType.investmentLowToHigh.value) {
    filteredList = allData
        .where((tracker) =>
    tracker.trackerCategory == ExpenseType.investment.intValue)
        .toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  }

  for (var tracker in filteredList) {
    investedAmount += tracker.amount;
    totalReturns += tracker.amount * (tracker.percentage / 100);
    returnsPercentage += tracker.percentage;
  }
  if(filteredList.isNotEmpty) {
    returnsPercentage = returnsPercentage / filteredList.length;
  }
  currentAmount = investedAmount + totalReturns;

  return InvestmentSummary(
      trackerModel: filteredList,
      investmentModel: InvestmentModel(
          currentAmount: currentAmount.toStringAsFixed(2),
          investedAmount: investedAmount.toStringAsFixed(2),
          totalReturns: totalReturns.toStringAsFixed(2),
          returnsPercentage: returnsPercentage.toStringAsFixed(2)));
});