import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_styles.dart';
import '../../../features/expense_tracker/viewmodel/riverpod/expense_tracker_notifier.dart';
import 'custom_date_picker.dart';
import 'global_widgets.dart';

class DateFilter extends ConsumerWidget {
  const DateFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wProvider = ref.watch(dateProvider);
    return Row(
      children: [
        Expanded(child: ShowDate(date: wProvider.startDateFilter!)),
        spacerW(8),
        Icon(Icons.remove),
        spacerW(8),
        Expanded(child: ShowDate(date: wProvider.endDateFilter!)),
      ],
    );
  }
}


// final wDateProvider =ref.watch(dateProvider);

class ShowDate extends StatelessWidget {
  final String date;
  const ShowDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 45,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.primary,
          ),
          child: InkWell(
            onTap: () {
              showCustomDateRangePicker(
                context,
                dismissible: true,
                minimumDate:
                DateTime.now().subtract(const Duration(days: 3000)),
                maximumDate: DateTime.now().add(const Duration(days: 0)),
                endDate: DateTime.now(),
                startDate: DateTime.now(),
                backgroundColor: theme.surface,
                primaryColor: theme.primary,
                onApplyClick: (start, end) {
                },
                onCancelClick: () {},
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                spacerW(8),
                Text(
                  date,
                  style: AppStyles.descriptionPrimary(
                      context: context, color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        ));
  }
}