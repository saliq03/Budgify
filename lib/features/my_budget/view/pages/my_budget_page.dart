import 'package:budgify/features/expense_tracker/view/pages/expense_management_page.dart';
import 'package:budgify/features/my_budget/view_model/riverpod/my_budget_notifier.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'budget_management_page.dart';

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
    final double w = MediaQuery.of(context).size.width;
    final myBudgetList = ref.watch(myBudgetProvider);

    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: ReusableAppBar(text: 'My Budget'),
      body: Center(
        child: myBudgetList.isEmpty? Text(
          'No Budget Found',
          style: TextStyle(
            fontSize:16,
            color: theme.onSurface,
          ),
        ) : ListView.builder(
          itemCount: myBudgetList.length,
          itemBuilder: (context, index) {
            // print(myBudgetList[index].title);
            // print(myBudgetList[index].description);
            // print(myBudgetList[index].date);
            return ListTile(
              title: Text(myBudgetList[index].title),
              subtitle: Text(myBudgetList[index].description),
              trailing: Text(myBudgetList[index].date),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const BudgetManagementPage(),
          ));
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
