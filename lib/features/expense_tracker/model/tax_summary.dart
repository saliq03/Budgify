import 'package:budgify/features/expense_tracker/model/tracker_model.dart';

class TaxSummary {
  final List<TrackerModel> trackerModel;
  final TaxModel taxModel;

  const TaxSummary({
    required this.trackerModel,
    required this.taxModel,
  });
}

/// A data model representing tax-related information.
class TaxModel {
  /// The final amount after tax is applied.
  final String netAmountAfterTax;

  /// The portion of the amount on which tax was calculated.
  final String taxableAmount;

  /// The total tax calculated on the taxable amount.
  final String totalTax;

  /// The percentage rate used to calculate the tax.
  final String taxPercentage;

  /// Constructs a [TaxModel] with the given financial details.
  const TaxModel({
    required this.netAmountAfterTax,
    required this.taxableAmount,
    required this.totalTax,
    required this.taxPercentage,
  });
}
