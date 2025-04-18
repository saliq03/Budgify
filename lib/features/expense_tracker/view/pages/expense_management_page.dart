import 'package:budgify/core/theme/app_gradients.dart';
import 'package:budgify/core/theme/app_styles.dart';
import 'package:budgify/shared/view/widgets/global_widgets.dart';
import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:budgify/shared/view/widgets/text_view/reusable_text_field.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/riverpod/expense_tracker_notifier.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
              spacerH(),
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
                        controller: amountController,
                        hintText: "Enter Amount",
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.monetization_on_outlined,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly,
                        //
                        // ],
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
                      ElevatedButton(
                          onPressed: () {
                            ref.read(expenseTrackerProvider.notifier).addData(
                                  title: titleController.text,
                                  date: DateTime.now().toString().split(" ")[0],
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
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown(
      {super.key,
      required this.categories,
      required this.onChanged,
      required this.icon,
      required this.selectedValue});

  final List<String> categories;
  final String selectedValue;
  final IconData icon;
  final void Function(String?)? onChanged;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final double w = MediaQuery.of(context).size.width;
    final bool isExpense = widget.selectedValue == "Expense";
    final color = isExpense ? Colors.red : Colors.green;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
            width: w,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                ),
                color: theme.surface,
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                spacerW(5),
                Icon(
                  isExpense
                      ? Icons.arrow_circle_down_outlined
                      : Icons.arrow_circle_up_outlined,
                  color: color,
                ),
                spacerW(15),
                Text(widget.selectedValue,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.descriptionPrimary(
                        context: context, color: color)),
                Spacer(),
                Icon(
                  widget.icon,
                )
              ],
            )),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: theme.primary, width: .5),
              color: theme.surface),
        ),
        items: widget.categories
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          height: 0,
                          color: theme.onSurface,
                          letterSpacing: 1.5,
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ))
            .toList(),
        onChanged: widget.onChanged,
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

//
// void showCustomDateRangePicker(
//     BuildContext context, {
//       required bool dismissible,
//       required DateTime minimumDate,
//       required DateTime maximumDate,
//       DateTime? startDate,
//       DateTime? endDate,
//       required Function(DateTime startDate, DateTime endDate) onApplyClick,
//       required Function() onCancelClick,
//       required Color backgroundColor,
//       required Color primaryColor,
//       String? fontFamily,
//     }) {
//   /// Request focus to take it away from any input field that might be in focus
//   FocusScope.of(context).requestFocus(FocusNode());
//
//   /// Show the CustomDateRangePicker dialog box
//   showDialog<dynamic>(
//     context: context,
//     builder: (BuildContext context) => CustomDateRangePicker(
//       barrierDismissible: true,
//       backgroundColor: backgroundColor,
//       primaryColor: primaryColor,
//       minimumDate: minimumDate,
//       maximumDate: maximumDate,
//       initialStartDate: startDate,
//       initialEndDate: endDate,
//       onApplyClick: onApplyClick,
//       onCancelClick: onCancelClick,
//     ),
//   );
// }

// class CustomDateRangePicker extends StatefulWidget {
//   /// The minimum date that can be selected in the calendar.
//   final DateTime minimumDate;
//
//   /// The maximum date that can be selected in the calendar.
//   final DateTime maximumDate;
//
//   /// Whether the widget can be dismissed by tapping outside of it.
//   final bool barrierDismissible;
//
//   /// The initial start date for the date range picker. If not provided, the calendar will default to the minimum date.
//   final DateTime? initialStartDate;
//
//   /// The initial end date for the date range picker. If not provided, the calendar will default to the maximum date.
//   final DateTime? initialEndDate;
//
//   /// The primary color used for the date range picker.
//   final Color primaryColor;
//
//   /// The background color used for the date range picker.
//   final Color backgroundColor;
//
//   /// A callback function that is called when the user applies the selected date range.
//   final Function(DateTime, DateTime) onApplyClick;
//
//   /// A callback function that is called when the user cancels the selection of the date range.
//   final Function() onCancelClick;
//
//   const CustomDateRangePicker({
//     Key? key,
//     this.initialStartDate,
//     this.initialEndDate,
//     required this.primaryColor,
//     required this.backgroundColor,
//     required this.onApplyClick,
//     this.barrierDismissible = true,
//     required this.minimumDate,
//     required this.maximumDate,
//     required this.onCancelClick,
//   }) : super(key: key);
//
//   @override
//   CustomDateRangePickerState createState() => CustomDateRangePickerState();
// }
//
// class CustomDateRangePickerState extends State<CustomDateRangePicker>
//     with TickerProviderStateMixin {
//   AnimationController? animationController;
//
//   DateTime? startDate;
//
//   DateTime? endDate;
//
//   @override
//   void initState() {
//     animationController = AnimationController(
//         duration: const Duration(milliseconds: 400), vsync: this);
//     startDate = widget.initialStartDate;
//     endDate = widget.initialEndDate;
//     animationController?.forward();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     animationController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: InkWell(
//           splashColor: Colors.transparent,
//           focusColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           onTap: () {
//             if (widget.barrierDismissible) {
//               Navigator.pop(context);
//             }
//           },
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: widget.backgroundColor,
//                   borderRadius: const BorderRadius.all(Radius.circular(24.0)),
//                   boxShadow: <BoxShadow>[
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         offset: const Offset(4, 4),
//                         blurRadius: 8.0),
//                   ],
//                 ),
//                 child: InkWell(
//                   borderRadius: const BorderRadius.all(Radius.circular(24.0)),
//                   onTap: () {},
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Row(
//                         children: <Widget>[
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   'From',
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 16,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 4,
//                                 ),
//                                 Text(
//                                   startDate != null
//                                       ? DateFormat('EEE, dd MMM')
//                                       .format(startDate!)
//                                       : '--/-- ',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 74,
//                             width: 1,
//                             color: Theme.of(context).dividerColor,
//                           ),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   'To',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 16,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 4,
//                                 ),
//                                 Text(
//                                   endDate != null
//                                       ? DateFormat('EEE, dd MMM')
//                                       .format(endDate!)
//                                       : '--/-- ',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       const Divider(
//                         height: 1,
//                       ),
//                       CustomCalendar(
//                         minimumDate: widget.minimumDate,
//                         maximumDate: widget.maximumDate,
//                         initialEndDate: widget.initialEndDate,
//                         initialStartDate: widget.initialStartDate,
//                         primaryColor: widget.primaryColor,
//                         startEndDateChange:
//                             (DateTime startDateData, DateTime endDateData) {
//                           setState(() {
//                             startDate = startDateData;
//                             endDate = endDateData;
//                           });
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 16, right: 16, bottom: 16, top: 8),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 height: 48,
//                                 decoration: const BoxDecoration(
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(24.0)),
//                                 ),
//                                 child: OutlinedButton(
//                                   style: ButtonStyle(
//                                     side: MaterialStateProperty.all(
//                                         BorderSide(color: widget.primaryColor)),
//                                     shape: MaterialStateProperty.all(
//                                       const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(24.0)),
//                                       ),
//                                     ),
//                                     backgroundColor: MaterialStateProperty.all(
//                                         widget.primaryColor),
//                                   ),
//                                   onPressed: () {
//                                     try {
//                                       widget.onCancelClick();
//                                       Navigator.pop(context);
//                                     } catch (_) {}
//                                   },
//                                   child: const Center(
//                                     child: Text(
//                                       'Cancel',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Container(
//                                 height: 48,
//                                 decoration: const BoxDecoration(
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(24.0)),
//                                 ),
//                                 child: OutlinedButton(
//                                   style: ButtonStyle(
//                                     side: MaterialStateProperty.all(
//                                         BorderSide(color: widget.primaryColor)),
//                                     shape: MaterialStateProperty.all(
//                                       const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(24.0)),
//                                       ),
//                                     ),
//                                     backgroundColor: MaterialStateProperty.all(
//                                         widget.primaryColor),
//                                   ),
//                                   onPressed: () {
//                                     try {
//                                       widget.onApplyClick(startDate!, endDate!);
//                                       Navigator.pop(context);
//                                     } catch (_) {}
//                                   },
//                                   child: const Center(
//                                     child: Text(
//                                       'Apply',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//   }
//   void showCustomDateRangePicker(
//       BuildContext context, {
//         required bool dismissible,
//         required DateTime minimumDate,
//         required DateTime maximumDate,
//         DateTime? startDate,
//         DateTime? endDate,
//         required Function(DateTime startDate, DateTime endDate) onApplyClick,
//         required Function() onCancelClick,
//         required Color backgroundColor,
//         required Color primaryColor,
//         String? fontFamily,
//       }) {
//     /// Request focus to take it away from any input field that might be in focus
//     FocusScope.of(context).requestFocus(FocusNode());
//
//     /// Show the CustomDateRangePicker dialog box
//     showDialog<dynamic>(
//       context: context,
//       builder: (BuildContext context) => CustomDateRangePicker(
//         barrierDismissible: true,
//         backgroundColor: backgroundColor,
//         primaryColor: primaryColor,
//         minimumDate: minimumDate,
//         maximumDate: maximumDate,
//         initialStartDate: startDate,
//         initialEndDate: endDate,
//         onApplyClick: onApplyClick,
//         onCancelClick: onCancelClick,
//       ),
//     );
//   }
//
// }
