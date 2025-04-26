

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/currency_model.dart';

final currencyProvider = StateProvider<CurrencyModel>((ref) {
  return CurrencyModel(
    name: 'United States Dollar',
    code: 'USD',
    symbol: '\$',
  );
});