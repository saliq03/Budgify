import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';

class MyBudgetPage extends StatelessWidget {
  const MyBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(text: 'My Budget'),
    );
  }
}
