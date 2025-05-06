import 'dart:ui';
import 'package:budgify/features/my_budget/model/my_budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/local/db_helper.dart';
import '../../utils/budget_filters_type.dart';
import 'budget_filter_provider.dart';

class MyBudgetNotifier extends StateNotifier<List<MyBudgetModel>> {
  MyBudgetNotifier() : super([]);
  DBHelper dbHelper = DBHelper();
  Database? database;
  bool isLoading = false;

  Future<void> init() async {
    await getDB();
    await fetchData();
    isLoading = false;
  }

  // Get the database instance
  Future<void> getDB() async {
    database = await dbHelper.getDB();
  }

  Future<void> addData(
      {required String title,
      required String date,
      required Color color,
      // required int colorCode,
      required String description}) async {
    bool isValueAdded = await dbHelper.addMyBudgetData(MyBudgetModel(
        title: title, date: date, description: description, color: color));
    // print("isValueAdded");
    // print(isValueAdded);
    if (isValueAdded) {
      fetchData();
    }
  }

  Future<void> updateData(
      {required int id,
      required String title,
      required Color color,
      required String date,
      // required int colorCode,
      required String description}) async {
    bool isValueAdded = await dbHelper.updateMyBudgetData(MyBudgetModel(
        id: id,
        title: title,
        date: date,
        description: description,
        color: color));
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

final filteredMyBudgetProvider = StateProvider<List<MyBudgetModel>>((ref) {
  final myBudgetList = ref.watch(myBudgetProvider);
  final budgetFilters = ref.watch(budgetFilterProvider);
  final filter1 = budgetFilters.filter1;
  final filter2 = budgetFilters.filter2;
  List<MyBudgetModel> filteredList = myBudgetList;

  ///Filter by date
  if (filter1 == Filter1Type.datetime.value) {
    ///Filter by date ascending
    if (filter2 == Filter2Type.ascending.value) {

      // filteredList=[];

      // filteredList.sort((a, b) => a.date.compareTo(b.date));
    }

    ///Filter by date descending
    else {
      // filteredList=[];
    }
  }

  ///Filter by title
  else {
    ///Filter by title ascending
    if (filter2 == Filter2Type.ascending.value) {

     // filteredList.sort((a, b) => a.title.compareTo(b.title));
    }

    ///Filter by title descending
    else {
      filteredList.reversed.toList();

    }
  }

  return filteredList;
});
