import 'package:budgify/features/my_budget/model/budget_filter_model.dart';
import 'package:budgify/features/my_budget/utils/budget_filters_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//If the value constantly changes at the runtime.
//provider is used when the value is going to change at the runtime.
//value does not override at runtime value will be changed.
//mutable
final budgetFilterProvider = StateProvider<BudgetFilterModel>((ref) =>
    BudgetFilterModel(
      filter1: Filter1Type.title.value,
      filter2: Filter2Type.ascending.value,
    ));


//immutable
// provider is used when the value is not going to change at the runtime.
// can be used for static data.
// override the value
//If value does not change at the runtime.
// var budgetFilterProvider = Provider<BudgetFilterModel>((ref) =>
//     BudgetFilterModel(
//         filter1: Filter1Type.title.value,
//         filter2: Filter2Type.ascending.value));
