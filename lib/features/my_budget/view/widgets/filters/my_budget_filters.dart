import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../shared/view/widgets/global_widgets.dart';
import '../../../utils/budget_filters_type.dart';
import '../../../view_model/riverpod/budget_filter_provider.dart';


class MyBudgetFilters extends ConsumerStatefulWidget {
  const MyBudgetFilters({super.key});

  @override
  ConsumerState<MyBudgetFilters> createState() => _MyBudgetFiltersState();
}

class _MyBudgetFiltersState extends ConsumerState<MyBudgetFilters> {
  bool isSelected = false;
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final filterRProvider = ref.read(budgetFilterProvider.notifier);
    final filterWProvider = ref.watch(budgetFilterProvider);
    final double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppStyles.headingPrimary(context: context),
              ),
              spacerW(15),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                child: Icon(
                  Icons.filter_list,
                  color: theme.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (isSelected)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                spacerH(10),
                Row(
                  children: Filter1Type.values.map((e) {
                    return reusableRadioButton(
                        w: w,
                        e: e,
                        filter: filterWProvider.filter1,
                        onChanged: (value) {
                          filterRProvider.state =
                              filterRProvider.state.copyWith(
                                filter1: value,
                              );
                        });
                  }).toList(),
                ),
                spacerH(10),
                Row(
                  children: Filter2Type.values.map((e) {
                    return reusableRadioButton(
                        filter: filterWProvider.filter2,
                        w: w,
                        e: e,
                        onChanged: (value) {
                          filterRProvider.state =
                              filterRProvider.state.copyWith(
                                filter2: value,
                              );
                        });
                  }).toList(),
                )
              ],
            ),
          ),
      ],
    );
  }

  Widget reusableRadioButton({
    required final double w,
    required final e,
    required final filter,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
        width: w * 0.44,
        child: RadioListTile(
          value: e.value,
          title: Text(
            e.value,
            style: AppStyles.descriptionPrimary(context: context, fontSize: 14),
          ),
          groupValue: filter,
          contentPadding: EdgeInsets.zero,
          // Removes extra padding
          visualDensity: VisualDensity(horizontal: -4.0),
          // Tighten horizontal space
          controlAffinity: ListTileControlAffinity.leading,
          // Radio on the left
          onChanged: (value) => onChanged(value!),
        ));
  }
}
