import 'package:budgify/core/local/db_helper.dart';

class TrackerModel {
  int? id;
  String title;
  String date;
  double amount;
  int trackerCategory;
  double percentage;

  TrackerModel({
    this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.trackerCategory,
    required this.percentage,
  });

  factory TrackerModel.fromMap(Map<String, dynamic> map) {
    return TrackerModel(
        id: map[DBHelper.columnTrackerId],
        title: map[DBHelper.columnTrackerTitle],
        date: map[DBHelper.columnTrackerDate],
        amount: map[DBHelper.columnTrackerAmount],
        trackerCategory: map[DBHelper.columnTrackerCategory],
        percentage: map[DBHelper.columnTrackerPercentage] ?? 0.0,
    );
  }

  Map<String,dynamic> toMap() {
    return {
      DBHelper.columnTrackerTitle: title,
      DBHelper.columnTrackerDate: date,
      DBHelper.columnTrackerAmount: amount,
      DBHelper.columnTrackerCategory: trackerCategory,
      DBHelper.columnTrackerPercentage: percentage,
    };
  }
}
