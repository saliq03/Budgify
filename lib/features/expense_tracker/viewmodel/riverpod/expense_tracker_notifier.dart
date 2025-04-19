import 'package:budgify/features/expense_tracker/model/currency_model.dart';
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
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalBalance = 0.0;

  // Asynchronous init method for initializing the state
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
      required double amount,
      required bool isExpense}) async {
    bool isValueAdded = await dbHelper.addTrackerData(TrackerModel(
        title: title, date: date, amount: amount, isExpense: isExpense));
    if (isValueAdded) {
      fetchData();
    }
  }


  Future<void> deleteData(int id) async {
    bool isValueDeleted = await dbHelper.deleteTrackerData(id);
    if (isValueDeleted) {
      fetchData();
    }
  }

  // Fetch data from the database and update the state
  Future<void> fetchData() async {
    totalIncome = 0.0;
    totalExpense = 0.0;
    totalBalance = 0.0;

    state = await dbHelper.fetchTrackerData(); // First, fetch data.

    for (var tracker in state) {
      if (tracker.isExpense) {
        totalExpense += tracker.amount;
      } else {
        totalIncome += tracker.amount;
      }
    }

    totalBalance = totalIncome - totalExpense;
  }
  }

// Create a provider for the ExpenseTrackerNotifier
final expenseTrackerProvider =
    StateNotifierProvider<ExpenseTrackerNotifier, List<TrackerModel>>(
  (ref) => ExpenseTrackerNotifier(),
);




final currencyProvider = StateProvider<CurrencyModel>((ref) {
  return CurrencyModel(
    name: 'United States Dollar',
    code: 'USD',
    symbol: '\$',
  );
});

final selectedValueProvider = StateProvider<String>((ref) => "Income");

final transactionProvider= StateProvider<String>((ref) => "Latest Transaction");