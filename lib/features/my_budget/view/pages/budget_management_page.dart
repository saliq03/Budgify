import 'package:budgify/core/theme/app_gradients.dart';
import 'package:budgify/core/theme/app_styles.dart';
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

    ///DateTime format
    final List dateTime = DateTime.now().toString().split(".")[0].split(" ");
    dateTime[0] = dateTime[0].replaceAll("-", "/");
    var twelveHoursSystem = int.parse(dateTime[1].substring(0, 2));
    if (twelveHoursSystem == 12) {
      dateTime[1] = "${dateTime[1]} PM";
    } else if (twelveHoursSystem > 12) {
      twelveHoursSystem = twelveHoursSystem - 12;
      dateTime[1] =
          "$twelveHoursSystem${dateTime[1].substring(2, dateTime[1].length)} PM";
    } else {
      dateTime[1] = "${dateTime[1]} AM";
    }
    final dateTimeString = "${dateTime[0]} | ${dateTime[1]}";

    return Scaffold(
      appBar: ReusableAppBar(
        text: "Budget Management",
        isCenterText: false,
      ),
      backgroundColor: selectedColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            ///It shows previous date if we are in the update mode but if we are in the add mode it shows current date
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
              child: Text(
                  widget.myBudgetModel != null
                      ? widget.myBudgetModel!.date
                      : dateTimeString,
                  style: AppStyles.descriptionPrimary(
                      context: context, color: Colors.black, fontSize: 15)),
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

              /// In both add and update mode, current date is used to save in database.
              /// If we are in the update mode
              if (widget.myBudgetModel != null) {
                rProvider.updateData(
                    id: widget.myBudgetModel!.id!,
                    title: titleController.text,
                    color: selectedColor,
                    description: descriptionController.text,
                    date: dateTimeString);
              } else {
                /// If we are in the add mode
                rProvider.addData(
                    color: selectedColor,
                    title: titleController.text,
                    date: dateTimeString,
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
