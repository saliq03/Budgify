import 'package:budgify/core/theme/app_gradients.dart';
import 'package:budgify/features/expense_tracker/view/widgets/reusable_floating_action_button.dart';
import 'package:budgify/features/my_budget/view_model/riverpod/selected_color_provider.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:budgify/shared/view/widgets/text_view/reusable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/selected_color_contents.dart';
import '../../model/my_budget_model.dart';
import '../../view_model/riverpod/my_budget_notifier.dart';

class BudgetManagementPage extends ConsumerStatefulWidget {
  final MyBudgetModel? myBudgetModel;

  const BudgetManagementPage({super.key, this.myBudgetModel});

  @override
  ConsumerState<BudgetManagementPage> createState() =>
      _BudgetManagementPageState();
}

class _BudgetManagementPageState extends ConsumerState<BudgetManagementPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updatePage();
  }

  ///If we are in the update mode, we need to update the page with the data
  void updatePage() {
    if (widget.myBudgetModel != null) {
      titleController.text = widget.myBudgetModel!.title;
      descriptionController.text = widget.myBudgetModel!.description;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedColorProvider.notifier).state =
            widget.myBudgetModel!.color;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var selectedColor = ref.watch(selectedColorProvider);
    var selectedColorRProvider = ref.read(selectedColorProvider.notifier);
    var rProvider = ref.read(myBudgetProvider.notifier);
    return Scaffold(
      appBar: ReusableAppBar(
        text: "Budget Management",
        isCenterText: false,
      ),
      backgroundColor: selectedColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 65,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      selectedColorContents(selectedColorRProvider).length,
                  itemBuilder: (_, index) {
                    final color =
                        selectedColorContents(selectedColorRProvider)[index]
                            .color;
                    final onTap =
                        selectedColorContents(selectedColorRProvider)[index]
                            .onTap;
                    return GestureDetector(
                      onTap: onTap,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: Card(
                          elevation: 4,
                          shape: const CircleBorder(),
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedColor == color
                                    ? Colors.black
                                    : Colors.white,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                              color: color,
                              // borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
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
              if (titleController.text.isEmpty &&
                  descriptionController.text.isEmpty) {
                IconSnackBar.show(context,
                    label: "Both title & description are empty!",
                    snackBarType: SnackBarType.alert);
                return;
              }
              /// If we are in the update mode
              if (widget.myBudgetModel != null) {
                rProvider.updateData(
                    id: widget.myBudgetModel!.id!,
                    title: titleController.text,
                    color: selectedColor,
                    description: descriptionController.text,
                    date: widget.myBudgetModel!.date);
              } else {
                /// If we are in the add mode
                rProvider.addData(
                    color: selectedColor,
                    title: titleController.text,
                    date: DateTime.now().toString().split(" ")[0],
                    description: descriptionController.text);
              }
              Navigator.pop(context);
            },
            icon: Icons.save,
            colors: AppGradients.skyBlueMyAppGradient),
      ),
    );
  }
}
