import 'package:budgify/features/my_budget/model/my_budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/local/db_helper.dart';

class MyBudgetNotifier extends StateNotifier<List<MyBudgetModel>> {
  MyBudgetNotifier() : super([]);
  DBHelper dbHelper = DBHelper();
  Database? database;
  bool isLoading = false;

  Future<void> init() async {
    await getDB();
    isLoading = false;
  }

  // Get the database instance
  Future<void> getDB() async {
    database = await dbHelper.getDB();
  }

  Future<void> addData(
      {required String title,
      required String date,
      // required int colorCode,
      required String description}) async {
    bool isValueAdded = await dbHelper.addMyBudgetData(
        MyBudgetModel(title: title, date: date, description: description));
    // print("isValueAdded");
    // print(isValueAdded);
    if (isValueAdded) {
      fetchData();
    }
  }

  Future<void> updateData(
      {required int id,
      required String title,
      // required String date,
      // required int colorCode,
      required String description}) async {
    bool isValueAdded = await dbHelper.updateMyBudgetData(MyBudgetModel(
        id: id, title: title, date: "", description: description));
    if (isValueAdded) {
      fetchData();
    }
  }

  Future<void> deleteData(int id) async {
    bool isValueAdded = await dbHelper.deleteMyBudgetData(id);
    if (isValueAdded) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    List<MyBudgetModel> myBudgetList = await dbHelper.fetchMyBudgetData();
    state = myBudgetList;
  }
}


final myBudgetProvider =
StateNotifierProvider<MyBudgetNotifier, List<MyBudgetModel>>(
      (ref) => MyBudgetNotifier(),
);
