import 'package:budgify/features/expense_tracker/utils/tax_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../viewmodel/riverpod/expense_tracker_notifier.dart';
import '../custom_drop_down.dart';

class TaxFilter extends StatelessWidget {
  const TaxFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Consumer(builder: (context, ref, child) {
      final selectedValue = ref.watch(taxProvider);

      return CustomDropDown(
        icon: Icons.arrow_drop_down_rounded,
        categories: TaxType.values.map((e) => e.value).toList(),
        leadingIconSize: 20,
        onChanged: (newValue) {
          if (newValue != null) {
            ref.read(taxProvider.notifier).state = newValue;
          }
        },
        selectedValue: selectedValue,
        leadingIcon: Icons.receipt_long,
        color: theme.onSurface,
        borderColor: theme.onSurface,
      );
    });
  }
}
