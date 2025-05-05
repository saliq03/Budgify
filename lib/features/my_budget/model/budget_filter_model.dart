class BudgetFilterModel{
  final String filter1;
  final String filter2;

  BudgetFilterModel({
    required this.filter1,
    required this.filter2,
  });

  BudgetFilterModel copyWith({
    String? filter1,
    String? filter2,
  }) {
    return BudgetFilterModel(
      filter1: filter1 ?? this.filter1,
      filter2: filter2 ?? this.filter2,
    );
  }
}