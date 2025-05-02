import 'package:budgify/core/theme/app_gradients.dart';
import 'package:budgify/features/expense_tracker/view/widgets/reusable_floating_action_button.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:budgify/shared/view/widgets/text_view/reusable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_model/riverpod/my_budget_notifier.dart';

class BudgetManagementPage extends StatefulWidget {
  const BudgetManagementPage({super.key});

  @override
  State<BudgetManagementPage> createState() => _BudgetManagementPageState();
}

class _BudgetManagementPageState extends State<BudgetManagementPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        text: "Budget Management",
        isCenterText: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            spacerH(10),
            ReusableTextField(
              controller: titleController,
              hintText: "Heading",
              isBorder: false,
              maxLines: null,
              isHeading: true,
              keyboardType: TextInputType.multiline,
              filled: false,
            ),
            spacerH(20),
            ReusableTextField(
              controller: descriptionController,
              hintText: "Description",
              maxLines: null,
              isBorder: false,
              keyboardType: TextInputType.multiline,
              filled: false,
            )
          ],
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) => ReusableFloatingActionButton(
            onTap: () {
              ref.read(myBudgetProvider.notifier).addData(
                  title: titleController.text,
                  date: DateTime.now().toString().split(".")[0],
                  description: descriptionController.text);
              Navigator.pop(context);
            },
            icon: Icons.save,
            colors: AppGradients.skyBlueMyAppGradient),
        child: ReusableFloatingActionButton(
            onTap: () {

            },
            icon: Icons.save,
            colors: AppGradients.skyBlueMyAppGradient),
      ),
    );
  }
}
