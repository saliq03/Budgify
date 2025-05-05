import 'package:budgify/core/theme/app_styles.dart';
import 'package:budgify/features/my_budget/view_model/riverpod/my_budget_notifier.dart';
import 'package:budgify/shared/view/widgets/containers/reusable_folded_corner_container2.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/paths.dart';
import '../../model/budget_filter_model.dart';
import '../../model/my_budget_model.dart';
import '../../utils/budget_filters_type.dart';
import '../../view_model/riverpod/budget_filter_provider.dart';

class MyBudgetPage extends ConsumerStatefulWidget {
  const MyBudgetPage({super.key});

  @override
  ConsumerState<MyBudgetPage> createState() => _MyBudgetPageState();
}

class _MyBudgetPageState extends ConsumerState<MyBudgetPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myBudgetProvider.notifier).init();
    });
    //   Future.microtask(() {
    //     ref.read(expenseTrackerProvider.notifier).init();
    //   });
  }

  @override
  Widget build(BuildContext context) {
    final myBudgetList = ref.watch(myBudgetProvider);
    // final selectedColor = ref.watch(selectedColorProvider);

    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: ReusableAppBar(text: 'My Budget'),
      body: Column(
        children: [
          spacerH(),
          MyBudgetFilters(),
          spacerH(10),
          Expanded(
            child: Center(
              child: myBudgetList.isEmpty
                  ? Text(
                      'No Budget Found',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.onSurface,
                      ),
                    )
                  : ListView.builder(
                      itemCount: myBudgetList.length,
                      padding: const EdgeInsets.only(top: 10, bottom: 80),
                      itemBuilder: (context, index) {
                        final budget = myBudgetList[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, bottom: 10),
                          child: ReusableFoldedCornerContainer2(
                            id: budget.id!,
                            title: budget.title,
                            description: budget.description,
                            date: budget.date,
                            color: budget.color,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Paths.budgetManagementPage,
                                  arguments: MyBudgetModel(
                                    id: budget.id!,
                                    title: budget.title,
                                    description: budget.description,
                                    date: budget.date,
                                    color: budget.color,
                                  ));
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Paths.budgetManagementPage);
        },
        backgroundColor: theme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MyBudgetFilters extends ConsumerStatefulWidget {
  const MyBudgetFilters({super.key});

  @override
  ConsumerState<MyBudgetFilters> createState() => _MyBudgetFiltersState();
}

class _MyBudgetFiltersState extends ConsumerState<MyBudgetFilters> {
  bool isSelected = false;
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final filterRProvider = ref.read(budgetFilterProvider.notifier);
    final filterWProvider = ref.watch(budgetFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppStyles.headingPrimary(context: context),
              ),
              spacerW(15),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                child: Icon(
                  Icons.filter_list,
                  color: theme.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (isSelected)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Filter1Type.values.map((e) {
                return RadioListTile<String>(
                  title: Text(e.value),
                  value: e.value,
                  groupValue: filterWProvider.filter1,
                  onChanged: (value) {
                    filterRProvider.state = filterRProvider.state.copyWith(
                      filter1: value!,
                    );
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
