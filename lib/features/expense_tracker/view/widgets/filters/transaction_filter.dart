import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utils/transaction_type.dart';
import '../../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../../../viewmodel/riverpod/transaction_provider.dart';
import '../custom_drop_down.dart';

class TransactionFilter extends StatelessWidget {
  const TransactionFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Consumer(builder: (context, ref, child) {
      final selectedValue = ref.watch(transactionProvider);

      return CustomDropDown(
        icon: Icons.arrow_drop_down_rounded,
        categories: TransactionType.values.map((e) => e.value).toList(),
        leadingIconSize: 20,
        onChanged: (newValue) {
          if (newValue != null) {
            ref.read(transactionProvider.notifier).state = newValue;
          }
        },
        selectedValue: selectedValue,
        leadingIcon: FontAwesomeIcons.receipt,
        color: theme.onSurface,
        borderColor: theme.onSurface,
      );
    });
  }
}
