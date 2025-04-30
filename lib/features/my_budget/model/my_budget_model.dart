
import '../../../core/local/db_helper.dart';

class MyBudgetModel{
    final int? id;
    final String title;
    final String date;
    final String description;

    MyBudgetModel({
      this.id,
      required this.title,
      required this.date,
      required this.description,
    });

    factory MyBudgetModel.fromMap(Map<String, dynamic> map) {
      return MyBudgetModel(
        id: map[DBHelper.columnMyBudgetId],
        title: map[DBHelper.columnMyBudgetTitle],
        date: map[DBHelper.columnMyBudgetDate],
        description: map[DBHelper.columnMyBudgetDescription],
      );
    }

    Map<String,dynamic> toMap() {
      return {
        DBHelper.columnMyBudgetTitle: title,
        DBHelper.columnMyBudgetDate: date,
        DBHelper.columnMyBudgetDescription: description,
      };
    }

}