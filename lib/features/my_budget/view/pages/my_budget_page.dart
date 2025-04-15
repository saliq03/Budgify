import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';

class MyBudgetPage extends StatelessWidget {
  const MyBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: ReusableAppBar(text: 'My Budget'),
      body: Center(
        child: Text(
          'No Budget Found',
          style: TextStyle(
            fontSize:16,
            color: theme.onSurface,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: theme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
