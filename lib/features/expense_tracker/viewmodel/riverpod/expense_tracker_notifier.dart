import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/local/db_helper.dart';
import '../../model/tracker_model.dart';

class ExpenseTrackerNotifier extends StateNotifier<List<TrackerModel>> {
  ExpenseTrackerNotifier()
      : super([]); // Start with an empty list as the initial state
  bool isLoading = true;
  DBHelper dbHelper = DBHelper();
  Database? database;

  // Asynchronous init method for initializing the state
  Future<void> init() async {
    await getDB();
    await insertData();
    isLoading = false;
  }

  // Get the database instance
  Future<void> getDB() async {
    database = await dbHelper.getDB();
  }

  Future<void> addData(
      {required String title,
      required String date,
      required double amount,
      required bool isExpense}) async {
    bool isValueAdded = await dbHelper.addTrackerData(TrackerModel(
        title: title, date: date, amount: amount, isExpense: isExpense));
    if (isValueAdded) {
      insertData();
    }
  }

  // Fetch data from the database and update the state
  Future<void> insertData() async {
    state = await dbHelper
        .fetchTrackerData(); // Creating a new list to ensure state is updated properly
  }
}

// Create a provider for the ExpenseTrackerNotifier
final expenseTrackerProvider =
    StateNotifierProvider<ExpenseTrackerNotifier, List<TrackerModel>>(
  (ref) => ExpenseTrackerNotifier(),
);
