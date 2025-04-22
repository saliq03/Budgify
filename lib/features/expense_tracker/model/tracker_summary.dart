import 'package:budgify/features/expense_tracker/model/tracker_model.dart';

class TrackerSummary {
  final List<TrackerModel> trackers;
  final TrackerCategory trackerCategory;

  TrackerSummary({
    required this.trackers,
    required this.trackerCategory,
  });
}

class TrackerCategory {
  final double totalIncome;
  final double totalExpense;
  final double totalBalance;
  final double investment;
  final double tax;

  const TrackerCategory({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalBalance,
    required this.investment,
    required this.tax,
  });
}
