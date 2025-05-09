import 'package:budgify/features/my_budget/view_model/riverpod/my_budget_notifier.dart';
import 'package:budgify/shared/view/widgets/containers/reusable_folded_corner_container2.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/paths.dart';
import '../../model/my_budget_model.dart';
import 'package:budgify/features/my_budget/view/widgets/filters/my_budget_filters.dart';


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
    final myBudgetList = ref.watch(filteredMyBudgetProvider);
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



