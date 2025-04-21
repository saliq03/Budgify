import 'package:budgify/features/expense_tracker/model/date_model.dart';
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
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../widgets/custom_drop_down.dart';

class ExpenseManagementPage extends ConsumerStatefulWidget {
  const ExpenseManagementPage({super.key});

  @override
  ConsumerState<ExpenseManagementPage> createState() =>
      _ExpenseManagementPageState();
}

class _ExpenseManagementPageState extends ConsumerState<ExpenseManagementPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedValue = ref.watch(selectedValueProvider);
    final rProvider = ref.read(currencyProvider.notifier);
    final currency = ref.watch(currencyProvider).symbol;
    final dateRef = ref.watch(dateProvider);

    final String selectedText =
        selectedValue == "Income" ? "Add Income" : "Add Expense";
    final double w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: ReusableAppBar(
        text: 'Expense Management',
        isCenterText: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              spacerH(40),
              Card(
                elevation: 4,
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
                              rProvider.state =
                                  CurrencyModel.fromJson(currency);
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
                      ),
                      spacerH(),
                      SizedBox(
                        height: 55,
                        // height: 40,
                        child: CustomDropDown(
                            icon: Icons.arrow_drop_down_rounded,
                            categories: const [
                              "Income",
                              "Expense",
                            ],
                            onChanged: (newValue) {
                              if (newValue != null) {
                                ref.read(selectedValueProvider.notifier).state =
                                    newValue;
                              }
                            },
                            selectedValue: selectedValue),
                      ),
                      spacerH(),
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

                            ref.read(expenseTrackerProvider.notifier).addData(
                                  title: titleController.text.isEmpty
                                      ? "Reason unavailable"
                                      : titleController.text,
                                  date:
                                      dateRef.selectedDate?? "Today's date",
                                  amount: double.parse(amountController.text),
                                  isExpense: selectedValue == "Expense",
                                );
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
              )
            ],
          ),
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
                        ref.read(dateProvider.notifier).state = dateRef.copyWith(
                            selectedDate: formatDate(value));
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
                            ref.read(dateProvider.notifier).state =
                                DateModel(selectedDate: formatDate(DateTime.now()));
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

// TableCalendar(
//   firstDay: DateTime.utc(2020, 1, 1),
//   lastDay: DateTime.utc(2030, 12, 31),
//   focusedDay: DateTime.now(),
//   // focusedDay: _focusedDay,
//   selectedDayPredicate: (day) {
//     return false;
//     // return isSameDay(_selectedDay, day);
//   },
//   onDaySelected: (selectedDay, focusedDay) {
//     setState(() {
//       // _selectedDay = selectedDay;
//       // _focusedDay = focusedDay; // update focused day as well
//     });
//   },
// ),
// Row(
//   children: [
//     Expanded(
//         child: InkWell(
//           onTap: () {
//             if (true) {
//               showCustomDateRangePicker(
//                 context,
//                 dismissible: true,
//                 minimumDate: DateTime.now()
//                     .subtract(const Duration(days: 3000)),
//                 maximumDate:
//                 DateTime.now().add(const Duration(days: 0)),
//                 // endDate: endDate,
//                 // startDate: startDate,
//                 // backgroundColor: bgColor,
//                 // primaryColor: customColor,
//                 onApplyClick: (start, end) {
//                   // setState(() {
//                   //   endDate = end;
//                   //   startDate = start;
//                   // });
//                 },
//                 onCancelClick: () {},
//               );
//             }
//           },
//           child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5)),
//             child: Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 // color: selectDate == null
//                 //     ? startDate == null
//                 //     ? customColor
//                 //     : secondaryThemeColor
//                 //     : Color.fromARGB(255, 114, 114, 114),
//               ),
//               padding:
//               const EdgeInsets.only(left: 10, right: 10),
//               child: Center(
//                   child: FittedBox(
//                       child: Text(
//                         // (startDate == null)
//                         //     ?
//                       "Start Date",
//                             // : "${getMonth(startDate!.month)} ${startDate!.day},${startDate!.year}",
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       ))),
//             ),
//           ),
//         )),
//     const Text(
//       " - ",
//       style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w700,
//           color: Colors.black),
//     ),
//     Expanded(
//         child: InkWell(
//           onTap: () {
//             if (true) {
//               showCustomDateRangePicker(
//                 context,
//                 dismissible: true,
//                 minimumDate: DateTime.now()
//                     .subtract(const Duration(days: 3000)),
//                 maximumDate:
//                 DateTime.now().add(const Duration(days: 0)),
//                 // endDate: endDate,
//                 // startDate: startDate,
//                 // backgroundColor: bgColor,
//                 // primaryColor: customColor,
//                 onApplyClick: (start, end) {
//                   // setState(() {
//                   //   endDate = end;
//                   //   startDate = start;
//                   // });
//                 },
//                 onCancelClick: () {},
//               );
//             }
//           },
//           child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5)),
//             child: Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color:
//                 // selectDate == null
//                 //     ? endDate == null
//                 //     ? customColor
//                 //     : secondaryThemeColor
//                 //     :
//                   Color.fromARGB(255, 114, 114, 114),
//               ),
//               padding:
//               const EdgeInsets.only(left: 10, right: 10),
//               child: Center(
//                   child: FittedBox(
//                       child: Text(
//                         // endDate == null
//                         //     ?
//                       "End Date",
//                             // : "${getMonth(endDate!.month)} ${endDate!.day},${endDate!.year}",
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       ))),
//             ),
//           ),
//         )),
//   ],
// ),

// SfDateRangePicker(
//   selectionMode: DateRangePickerSelectionMode.range,
//   onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//     print("Selected range: ${args.value}");
//   },
// ),
