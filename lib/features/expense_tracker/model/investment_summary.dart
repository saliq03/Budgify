import 'package:budgify/features/expense_tracker/model/tracker_model.dart';

class InvestmentSummary {
  final List<TrackerModel> trackerModel;
  final InvestmentModel investmentModel;

  const InvestmentSummary({
    required this.trackerModel,
    required this.investmentModel,
  });
}

class InvestmentModel {
  final String currentAmount;
  final String investedAmount;
  final String totalReturns;
  final String returnsPercentage;

  const InvestmentModel({
    required this.currentAmount,
    required this.investedAmount,
    required this.totalReturns,
    required this.returnsPercentage,
  });
}
