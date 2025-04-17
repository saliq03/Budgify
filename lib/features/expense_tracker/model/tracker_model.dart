import 'package:budgify/core/local/db_helper.dart';

class TrackerModel {
  int? id;
  String title;
  String date;
  double amount;
  bool isExpense;

  TrackerModel({
    this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isExpense,
  });

  factory TrackerModel.fromMap(Map<String, dynamic> map) {
    return TrackerModel(
        id: map[DBHelper.columnTrackerId],
        title: map[DBHelper.columnTrackerTitle],
        date: map[DBHelper.columnTrackerDate],
        amount: map[DBHelper.columnTrackerAmount],
        isExpense: map[DBHelper.columnIsExpense] == 1);
  }

  Map<String,dynamic> toMap() {
    return {
      DBHelper.columnTrackerTitle: title,
      DBHelper.columnTrackerDate: date,
      DBHelper.columnTrackerAmount: amount,
      DBHelper.columnIsExpense: isExpense ? 1 : 0,
    };
  }

}
