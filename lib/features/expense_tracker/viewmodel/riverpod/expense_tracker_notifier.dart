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

    state = await dbHelper.fetchTrackerData();

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

final transactionProvider = StateProvider<String>(
    (ref) => TransactionType.transactionsNewestToOldest.value);

final filteredTransactionProvider = Provider<List<TrackerModel>>((ref) {
  final filter = ref.watch(transactionProvider);
  final allData = ref.watch(expenseTrackerProvider);

  List<TrackerModel> filteredList = [];

  // if (filter == TransactionType.onlyIncome.value) {
  //   filteredList = allData.where((tracker) => !tracker.isExpense).toList();
  // } else if (filter == TransactionType.onlyExpense.value) {
  //   filteredList = allData.where((tracker) => tracker.isExpense).toList();
  // }

  if (filter == TransactionType.mostExpensive.value) {
    filteredList = allData.where((tracker) => tracker.isExpense).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  } else if (filter == TransactionType.leastExpensive.value) {
    filteredList = allData.where((tracker) => tracker.isExpense).toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  } else if (filter == TransactionType.transactionsNewestToOldest.value) {
    filteredList = allData.reversed.toList();
  } else if (filter == TransactionType.mostIncome.value) {
    filteredList = allData.where((tracker) => !tracker.isExpense).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  } else if (filter == TransactionType.leastIncome.value) {
    filteredList = allData.where((tracker) => !tracker.isExpense).toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  } else {
    filteredList = allData;
  }
  return filteredList;
});

enum TransactionType {
  transactionsNewestToOldest,
  transactionsOldestToNewest,
  mostExpensive,
  leastExpensive,
  // onlyIncome,
  // onlyExpense,
  mostIncome,
  leastIncome;


  String get value {
    switch (this) {
      case TransactionType.transactionsNewestToOldest:
        return 'Transactions: Latest First';
      case TransactionType.transactionsOldestToNewest:
        return 'Transactions: Oldest First';
      case TransactionType.mostExpensive:
        return 'Most Expensive First';
      case TransactionType.mostIncome:
        return 'Highest Income First';
      case TransactionType.leastExpensive:
        return 'Least Expensive First';
      case TransactionType.leastIncome:
        return 'Lowest Income First';
      // case TransactionType.mostExpensive:
      //   return 'Most to Least Expensive';
      // case TransactionType.mostIncome:
      //   return 'Most to Least Income';
      // case TransactionType.leastExpensive:
      //   return 'Least to Most Expensive';
      // case TransactionType.leastIncome:
      //   return 'Least to Most Income';
      // case TransactionType.onlyIncome:
      //   return 'Only Income';
      // case TransactionType.onlyExpense:
      //   return 'Only Expense';
    }
  }
}
