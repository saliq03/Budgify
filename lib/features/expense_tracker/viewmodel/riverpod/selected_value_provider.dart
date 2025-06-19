import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/expense_type.dart';

final selectedValueProvider =
StateProvider<String>((ref) => ExpenseType.income.value);

final chooseCategoryProvider =
StateProvider<int>((ref) => -1);