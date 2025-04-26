import 'package:budgify/features/expense_tracker/model/tracker_model.dart';

class TransactionSummary{
  final List<TrackerModel> trackerModel;
  final TransactionModel transactionModel;
  const TransactionSummary({
    required this.trackerModel,
    required this.transactionModel,
  });
}


class TransactionModel {
  final String income;
  final String expense;
  final String totalBalance;

  const TransactionModel({
    required this.income,
    required this.expense,
    required this.totalBalance,
  });
}