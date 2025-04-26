import 'package:budgify/features/expense_tracker/model/currency_model.dart';
import 'package:budgify/features/expense_tracker/model/date_model.dart';
import 'package:budgify/features/expense_tracker/model/investment_summary.dart';
import 'package:budgify/features/expense_tracker/model/tax_summary.dart';
import 'package:budgify/features/expense_tracker/utils/expense_type.dart';
import 'package:budgify/features/expense_tracker/utils/investment_type.dart';
import 'package:budgify/features/expense_tracker/utils/tax_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/local/db_helper.dart';
import '../../../../shared/view/widgets/global_widgets.dart';
import '../../model/tracker_model.dart';
import '../../model/tracker_summary.dart';
import '../../utils/transaction_type.dart';

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
  bool isLoading = false;
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

final currencyProvider = StateProvider<CurrencyModel>((ref) {
  return CurrencyModel(
    name: 'United States Dollar',
    code: 'USD',
    symbol: '\$',
  );
});

final selectedValueProvider =
    StateProvider<String>((ref) => ExpenseType.income.value);

final transactionProvider =
    StateProvider<String>((ref) => TransactionType.allTransactions.value);

final investmentProvider =
    StateProvider<String>((ref) => InvestmentType.investmentLatestFirst.value);

final taxProvider =
    StateProvider<String>((ref) => TaxType.taxLatestFirst.value);

final filteredTransactionProvider = Provider<List<TrackerModel>>((ref) {
  final filter = ref.watch(transactionProvider);
  final allData = ref.watch(expenseTrackerProvider).trackers;

  List<TrackerModel> filteredList = [];

  if (filter == TransactionType.mostExpensive.value) {
    filteredList = allData
        .where((tracker) =>
            tracker.trackerCategory == ExpenseType.expense.intValue)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  } else if (filter == TransactionType.excludingInvestmentAndTax.value) {
    filteredList = allData
        .where((tracker) =>
            (tracker.trackerCategory != ExpenseType.investment.intValue) &&
            (tracker.trackerCategory != ExpenseType.tax.intValue))
        .toList();
  } else if (filter == TransactionType.leastExpensive.value) {
    filteredList = allData
        .where((tracker) =>
            tracker.trackerCategory == ExpenseType.expense.intValue)
        .toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  } else if (filter == TransactionType.transactionsNewestToOldest.value) {
    filteredList = allData.toList()
      ..sort((a, b) =>
          parseDate(b.date).compareTo(parseDate(a.date))); // Newest to Oldest
  } else if (filter == TransactionType.mostIncome.value) {
    filteredList = allData
        .where(
            (tracker) => tracker.trackerCategory == ExpenseType.income.intValue)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  } else if (filter == TransactionType.leastIncome.value) {
    filteredList = allData
        .where(
            (tracker) => tracker.trackerCategory == ExpenseType.income.intValue)
        .toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  } else if (filter == TransactionType.transactionsOldestToNewest.value) {
    filteredList = allData.toList()
      ..sort((a, b) =>
          parseDate(a.date).compareTo(parseDate(b.date))); // Oldest to Newest
  } else {
    filteredList = allData;
  }
  return filteredList;
});

final filteredInvestmentProvider = Provider<InvestmentSummary>((ref) {
  final filter = ref.watch(investmentProvider);
  final allData = ref.watch(expenseTrackerProvider).trackers;

  List<TrackerModel> filteredList = [];
  double currentAmount = 0.0;
  double investedAmount = 0.0;
  double totalReturns = 0.0;
  double returnsPercentage = 0.0;

  if (filter == InvestmentType.investmentLatestFirst.value) {
    filteredList = allData
        .where((tracker) =>
            tracker.trackerCategory == ExpenseType.investment.intValue)
        .toList()
      ..sort((a, b) => parseDate(b.date).compareTo(parseDate(a.date)));

    // Newest to Oldest
  } else if (filter == InvestmentType.investmentOldestFirst.value) {
    filteredList = allData
        .where((tracker) =>
            tracker.trackerCategory == ExpenseType.investment.intValue)
        .toList()
      ..sort((a, b) =>
          parseDate(a.date).compareTo(parseDate(b.date))); // Oldest to Newest
  } else if (filter == InvestmentType.investmentHighToLow.value) {
    filteredList = allData
        .where((tracker) =>
            tracker.trackerCategory == ExpenseType.investment.intValue)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  } else if (filter == InvestmentType.investmentLowToHigh.value) {
    filteredList = allData
        .where((tracker) =>
            tracker.trackerCategory == ExpenseType.investment.intValue)
        .toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  }

  for (var tracker in filteredList) {
    currentAmount += tracker.amount;
    returnsPercentage += tracker.percentage;
  }
  returnsPercentage = returnsPercentage / filteredList.length;
  investedAmount = currentAmount / (1 + (returnsPercentage / 100));
  totalReturns = currentAmount - investedAmount;

  return InvestmentSummary(
      trackerModel: filteredList,
      investmentModel: InvestmentModel(
          currentAmount: currentAmount.toStringAsFixed(2),
          investedAmount: investedAmount.toStringAsFixed(2),
          totalReturns: totalReturns.toStringAsFixed(2),
          returnsPercentage: returnsPercentage.toStringAsFixed(2)));
});

final filteredTaxProvider = Provider<TaxSummary>((ref) {
  final filter = ref.watch(taxProvider);
  final allData = ref.watch(expenseTrackerProvider).trackers;

  List<TrackerModel> filteredList = [];

  double netAmountAfterTax = 0.0;

  /// The portion of the amount on which tax was calculated.
  double taxableAmount = 0.0;

  /// The total tax calculated on the taxable amount.
  double totalTax = 0.0;

  /// The percentage rate used to calculate the tax.
  double taxPercentage = 0.0;

  if (filter == TaxType.taxLatestFirst.value) {
    filteredList = allData
        .where((tracker) => tracker.trackerCategory == ExpenseType.tax.intValue)
        .toList()
      ..sort((a, b) =>
          parseDate(b.date).compareTo(parseDate(a.date))); // Newest to Oldest
  } else if (filter == TaxType.taxOldestFirst.value) {
    filteredList = allData
        .where((tracker) => tracker.trackerCategory == ExpenseType.tax.intValue)
        .toList()
      ..sort((a, b) =>
          parseDate(a.date).compareTo(parseDate(b.date))); // Oldest to Newest
  } else if (filter == TaxType.taxHighToLow.value) {
    filteredList = allData
        .where((tracker) => tracker.trackerCategory == ExpenseType.tax.intValue)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  } else if (filter == TaxType.taxLowToHigh.value) {
    filteredList = allData
        .where((tracker) => tracker.trackerCategory == ExpenseType.tax.intValue)
        .toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  } else {
    filteredList = allData;
  }

  for (var tracker in filteredList) {
    taxableAmount += tracker.amount;
    taxPercentage += tracker.percentage;
  }
  taxPercentage = taxPercentage / filteredList.length;
  totalTax = taxableAmount * (taxPercentage / 100);
  netAmountAfterTax = taxableAmount - totalTax;

  return TaxSummary(
      trackerModel: filteredList,
      taxModel: TaxModel(
          netAmountAfterTax: netAmountAfterTax.toStringAsFixed(2),
          taxableAmount: taxableAmount.toStringAsFixed(2),
          totalTax: totalTax.toStringAsFixed(2),
          taxPercentage: taxPercentage.toStringAsFixed(2)));
});

final dateProvider = StateProvider<DateModel>((ref) {
  return DateModel(
    // startDateFilter: formatDate(DateTime.now().subtract(Duration(days: 30))),
    endDateFilter: formatDate(DateTime.now()),
    selectedDate: formatDate(DateTime.now()),
  );
});

//final investmentAndTaxProvider =
//     StateProvider<String>((ref) => InvestAndTaxType.investmentAndTax.value);
