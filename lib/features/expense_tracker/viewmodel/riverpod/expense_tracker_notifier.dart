import 'package:budgify/features/expense_tracker/model/date_model.dart';
import 'package:budgify/features/expense_tracker/utils/expense_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/local/db_helper.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../model/tracker_model.dart';
import '../../model/tracker_summary.dart';

class ExpenseTrackerNotifier extends StateNotifier<TrackerSummary> {
  ExpenseTrackerNotifier(this.ref)
      : super(TrackerSummary(
            trackers: [],
            trackerCategory: TrackerCategory(
              totalIncome: 0.0,
              totalExpense: 0.0,
              totalBalance: 0.0,
              investment: 0.0,
              tax: 0.0,
            )));
  Ref ref;
  bool isLoading = true;
  DBHelper dbHelper = DBHelper();
  Database? database;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalBalance = 0.0;
  double totalInvestment = 0.0;
  double totalTax = 0.0;

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
      required int trackerCategory,
      required double percentage}) async {
    bool isValueAdded = await dbHelper.addTrackerData(TrackerModel(
        title: title,
        date: date,
        amount: amount,
        trackerCategory: trackerCategory,
        percentage: percentage));
    if (isValueAdded) {
      fetchData();
    }
  }

  Future<void> updateData(
      {required int id,
      required String title,
      required String date,
      required double amount,
      required int trackerCategory,
      required double percentage}) async {
    bool isValueUpdated = await dbHelper.updateTrackerData(TrackerModel(
        id: id,
        title: title,
        date: date,
        amount: amount,
        trackerCategory: trackerCategory,
        percentage: percentage));
    if (isValueUpdated) {
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
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    double totalInvestment = 0.0;
    double totalTax = 0.0;

    List<TrackerModel> list = await dbHelper.fetchTrackerData();
    final rProvider = ref.read(dateProvider);

    List<TrackerModel> filteredList = [];
    if (rProvider.startDateFilter == null) {
      filteredList = list.reversed.toList();
    } else {
      DateTime startDate = parseDate(rProvider.startDateFilter!);
      // DateTime startDate = DateTime.now().subtract(Duration(days: 30));
      DateTime endDate = parseDate(rProvider.endDateFilter!);

      filteredList = list.where((tracker) {
        DateTime trackerDate = parseDate(tracker.date);
        return trackerDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            trackerDate.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
    }

    for (var tracker in filteredList) {
      if (tracker.trackerCategory == ExpenseType.expense.intValue) {
        totalExpense += tracker.amount;
      } else if (tracker.trackerCategory == ExpenseType.investment.intValue) {
        totalInvestment += tracker.amount;
      } else if (tracker.trackerCategory == ExpenseType.tax.intValue) {
        totalTax += tracker.amount;
      } else {
        totalIncome += tracker.amount;
      }
    }

    state = TrackerSummary(
      trackers: filteredList,
      trackerCategory: TrackerCategory(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        totalBalance: (totalIncome - totalExpense) + totalInvestment - totalTax,
        investment: totalInvestment,
        tax: totalTax,
      ),
    );
  }
}

// Create a provider for the ExpenseTrackerNotifier
final expenseTrackerProvider =
    StateNotifierProvider<ExpenseTrackerNotifier, TrackerSummary>(
  (ref) => ExpenseTrackerNotifier(ref),
);

final dateProvider = StateProvider<DateModel>((ref) {
  return DateModel(
    // startDateFilter: formatDate(DateTime.now().subtract(Duration(days: 30))),
    endDateFilter: formatDate(DateTime.now()),
    selectedDate: formatDate(DateTime.now()),
  );
});
