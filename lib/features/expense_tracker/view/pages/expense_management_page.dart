import 'package:budgify/features/expense_tracker/model/card_model.dart';
import 'package:budgify/features/expense_tracker/model/date_model.dart';
import 'package:budgify/features/expense_tracker/viewmodel/riverpod/on_changed_value_provider.dart';
import 'package:budgify/shared/view/widgets/containers/reusable_folded_corner_container.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:budgify/core/theme/app_gradients.dart';
import 'package:budgify/core/theme/app_styles.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:budgify/shared/view/widgets/text_view/reusable_text_field.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/currency_model.dart';
import '../../model/tracker_model.dart';
import '../../utils/expense_type.dart';
import '../../viewmodel/riverpod/currency_provider.dart';
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../../viewmodel/riverpod/selected_value_provider.dart';
import '../widgets/custom_drop_down.dart';

class ExpenseManagementPage extends ConsumerStatefulWidget {
  final TrackerModel? trackerModel;

  const ExpenseManagementPage({this.trackerModel, super.key});

  @override
  ConsumerState<ExpenseManagementPage> createState() =>
      _ExpenseManagementPageState();
}

class _ExpenseManagementPageState extends ConsumerState<ExpenseManagementPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateValues();
    });
  }

  void updateValues() {
    if (widget.trackerModel != null) {
      // final dateRef = ref.watch(dateProvider);

      titleController.text = widget.trackerModel!.title;

      if (widget.trackerModel!.amount != null) {
        amountController.text = widget.trackerModel!.amount.toString();
      }

      ref.read(selectedValueProvider.notifier).state =
          ExpenseType.investment.value;

      final selectedExpenseType = ExpenseType.values
          .firstWhere(
            (e) => e.intValue == widget.trackerModel!.trackerCategory,
            orElse: () => ExpenseType.expense, // Default fallback if not found
          )
          .value;

      // print("Selected Expense Type: ${selectedExpenseType}");

      ref.read(selectedValueProvider.notifier).state = selectedExpenseType;
      if (widget.trackerModel!.percentage != 0.0) {
        percentageController.text = widget.trackerModel!.percentage.toString();
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedValue = ref.watch(selectedValueProvider);
    final rProvider = ref.read(currencyProvider.notifier);
    final currency = ref.watch(currencyProvider).symbol;
    final dateRef = ref.watch(dateProvider);
    final isTaxPage = selectedValue == ExpenseType.tax.value;
    final isShowReturn = selectedValue == ExpenseType.investment.value ||
        selectedValue == ExpenseType.tax.value;

    final String selectedText;
    if (selectedValue == ExpenseType.income.value) {
      selectedText = "Add Income";
    } else if (selectedValue == ExpenseType.expense.value) {
      selectedText = "Add Expense";
    } else if (selectedValue == ExpenseType.investment.value) {
      selectedText = "Add Investment";
    } else {
      selectedText = "Add Tax";
    }
    final trackerRProvider = ref.read(expenseTrackerProvider.notifier);
    final double w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    final onChangedValue = ref.read(onChangeValueProvider);
    final onChangedProvider= ref.read(onChangedInvestmentTaxProvider);

    return Scaffold(
      appBar: ReusableAppBar(
        text: 'Expense Management',
        isCenterText: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            spacerH(40),
            Visibility(
                visible: isShowReturn,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: ReusableFoldedCornerContainer(
                    isTaxPage: isTaxPage,
                    section1: CardModel(
                        name: isTaxPage ? "After Tax:" : "Current Amount:",
                        value: "$currency${onChangedProvider.beforeOperationAmount}"),
                    section2: CardModel(
                        name: isTaxPage ? "Before Tax:" : "Invested Amount:",
                        value: "$currency${onChangedProvider.afterOperationAmount}"),
                    section3: CardModel(
                        name: isTaxPage ? "Total Tax:" : "Total Returns:",
                        value: "$currency${onChangedProvider.changedAmount}" ),
                    section4: CardModel(
                      name: isTaxPage ? "Tax %:" : "Returns %:",
                      value: onChangedValue.percentage == "0" || onChangedValue.percentage == ""
                          ? "0.0%"
                          : "${onChangedValue.percentage}%",
                    ),
                  ),
                )),
            spacerH(),

            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: w,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  gradient: LinearGradient(
                      colors: AppGradients.skyBlueMyAppGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      selectedText,
                      style: AppStyles.headingPrimary(
                          context: context, color: Colors.white),
                    ),
                    spacerH(15),
                    ReusableTextField(
                      controller: titleController,
                      hintText: "Enter Title",
                      prefixIcon: Icons.title_outlined,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                    ),
                    spacerH(),
                    ReusableTextField(
                      prefixText: currency,
                      onTapPrefix: () {
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currency currency) {
                            rProvider.state = CurrencyModel.fromJson(currency);
                            // print(currency.name);
                          },
                        );
                      },
                      controller: amountController,
                      hintText: "Enter Amount",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                        // FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value){
                        ref.read(onChangeValueProvider.notifier).state =
                            onChangedValue.copyWith(
                          beforeOperationAmount: value,
                          percentage: percentageController.text,
                          isTaxPage: isTaxPage,
                        );
                      },
                    ),
                    spacerH(),
                    SizedBox(
                      height: 55,
                      // height: 40,
                      child: CustomDropDown(
                          icon: Icons.arrow_drop_down_rounded,
                          categories:
                              ExpenseType.values.map((e) => e.value).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              ref.read(selectedValueProvider.notifier).state =
                                  newValue;
                            }
                          },
                          selectedValue: selectedValue),
                    ),
                    spacerH(),
                    if (isShowReturn)
                      ReusableTextField(
                        prefixIcon: Icons.percent,
                        controller: percentageController,
                        hintText: "0",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*\.?\d*'),
                          ),
                          // FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value){
                          ref.read(onChangeValueProvider.notifier).state =
                              onChangedValue.copyWith(
                                beforeOperationAmount: value,
                                percentage: percentageController.text,
                                isTaxPage: isTaxPage,
                              );
                          },
                      ),
                    if (isShowReturn) spacerH(),
                    selectDate(w, context, theme, dateRef),
                    spacerH(),
                    ElevatedButton(
                        onPressed: () {
                          if (amountController.text.isEmpty) {
                            IconSnackBar.show(
                              context,
                              label: "Please enter amount!",
                              snackBarType: SnackBarType.alert,
                            );
                            return;
                          }
                          if (widget.trackerModel != null) {
                            trackerRProvider.updateData(
                              id: widget.trackerModel!.id ?? 0,
                              title: titleController.text.isEmpty
                                  ? "Reason unavailable"
                                  : titleController.text,
                              percentage: double.parse(
                                  percentageController.text.isEmpty
                                      ? "0"
                                      : percentageController.text),
                              date: dateRef.selectedDate ??
                                  formatDate(DateTime.now()),
                              amount: double.parse(amountController.text),
                              trackerCategory: ExpenseType.values
                                  .firstWhere((e) => e.value == selectedValue)
                                  .intValue,
                            );
                          } else {
                            trackerRProvider.addData(
                              title: titleController.text.isEmpty
                                  ? "Reason unavailable"
                                  : titleController.text,
                              date: dateRef.selectedDate ??
                                  formatDate(DateTime.now()),
                              percentage: double.parse(
                                  percentageController.text.isEmpty
                                      ? "0"
                                      : percentageController.text),
                              amount: double.parse(amountController.text),
                              trackerCategory: ExpenseType.values
                                  .firstWhere((e) => e.value == selectedValue)
                                  .intValue,
                            );
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(w, 40),
                          backgroundColor: Color.fromARGB(255, 34, 95, 216),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          selectedText,
                          style: AppStyles.descriptionPrimary(
                              context: context, color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
            spacerH(40),

            spacerH(80),
          ],
        ),
      ),
    );
  }

  Widget selectDate(
      double w, BuildContext context, final theme, final dateRef) {
    return Container(
      width: w,
      height: 55,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.surface,
        border: Border.all(
          width: 1,
          color: theme.onSurface,
        ),
      ),
      child: InkWell(
        onTap: () {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Date'),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  content: Container(
                    decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: BorderRadius.circular(10)),
                    height: 200,
                    width: w,
                    child: ScrollDatePicker(
                      selectedDate: parseDate(dateRef.selectedDate),
                      // maximumDate:
                      //     DateTime.now().add(const Duration(days: 365 * 30)),
                      // selectedDate: DateTime.now(),
                      locale: const Locale('en', 'US'),
                      onDateTimeChanged: (DateTime value) {
                        ref.read(dateProvider.notifier).state =
                            dateRef.copyWith(selectedDate: formatDate(value));
                      },
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            ref.read(dateProvider.notifier).state = DateModel(
                                selectedDate: formatDate(DateTime.now()));
                          },
                          child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: theme.primary,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                        spacerW(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: theme.primary,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Apply",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                );
              });
        },
        child: Row(
          children: [
            spacerW(10),
            Icon(
              Icons.calendar_month_outlined,
              color: theme.onSurface,
              size: 20,
            ),
            spacerW(10),
            Text(
              dateRef.selectedDate,
              style: AppStyles.descriptionPrimary(context: context),
            ),
            Spacer(),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: theme.onSurface,
            )
          ],
        ),
      ),
    );
  }
}

class OnChangedValueWidget extends ConsumerWidget {
  const OnChangedValueWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
