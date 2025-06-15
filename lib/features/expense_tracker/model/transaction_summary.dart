import 'package:budgify/features/expense_tracker/model/tracker_model.dart';

class TransactionSummary {
  final List<TrackerModel> trackerModel;
  final TransactionModel transactionModel;

  TransactionSummary({
    required this.trackerModel,
    required this.transactionModel,
  });

  // Add this static method
  static TransactionSummary empty() {
    return TransactionSummary(
      trackerModel: [],
      transactionModel: TransactionModel(
        income: '0.00',
        expense: '0.00',
        totalBalance: '0.00',
      ),
    );
  }
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