import 'package:budgify/features/expense_tracker/model/tracker_model.dart';

class TrackerSummary {
  final List<TrackerModel> trackers;
  final double totalIncome;
  final double totalExpense;
  final double totalBalance;

  TrackerSummary({
    required this.trackers,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalBalance,
  });
}
