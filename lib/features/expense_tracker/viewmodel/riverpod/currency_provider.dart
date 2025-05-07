

import 'package:budgify/core/local/hive_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/currency_model.dart';

final currencyProvider = StateProvider<CurrencyModel>((ref) {
  // HiveDatabase hiveDatabase = HiveDatabase();
  // final currency = hiveDatabase.getValue(HiveDatabase.currentCurrencyBox);
  // print("Hive Database");
  // print(currency.toString());


  return CurrencyModel(
    name:  'Indian Rupee',
    code: 'INR',
    symbol: '₹',
  );
});