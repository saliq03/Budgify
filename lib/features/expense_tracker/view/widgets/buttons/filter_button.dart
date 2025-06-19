import 'package:flutter/material.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../shared/view/widgets/global_widgets.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 45,
         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
         decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.onSurface, width: 1),
         ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_list,
                  color: theme.onSurface, size: 20),
              spacerW(5),
              Flexible(
                child: Text("Filter",
                    style: AppStyles.headingPrimary(
                      context: context,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),overflow: TextOverflow.ellipsis,),
              ),
            ],
          )),
    );
  }

  void onPressed() {}
}
