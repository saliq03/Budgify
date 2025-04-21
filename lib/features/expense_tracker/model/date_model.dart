class DateModel {
  final String? startDateFilter;
  final String? endDateFilter;
  final String? selectedDate;

  DateModel({
    this.startDateFilter,
    this.endDateFilter,
    this.selectedDate,
  });

  DateModel copyWith({
    String? startDateFilter,
    String? endDateFilter,
    String? selectedDate,
  }) {
    return DateModel(
      startDateFilter: startDateFilter ?? this.startDateFilter,
      endDateFilter: endDateFilter ?? this.endDateFilter,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
