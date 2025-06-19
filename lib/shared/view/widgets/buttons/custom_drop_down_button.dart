import 'package:flutter/material.dart';

import '../../../../core/theme/app_styles.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final Function(String) onSelected;

  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent, // Disable splash effect
        highlightColor: Colors.transparent, // Disable highlight effect
      ),
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return items.map((String choice) {
            final isSelected = choice == selectedItem;
            return PopupMenuItem<String>(
              value: choice,
              // onTap: () => onSelected(choice),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected ? theme.onSecondary : Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Text(choice,style: AppStyles.headingPrimary(
                  context: context,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff3A3A3A),
                ),),
              ),
            );
          }).toList();
        },
        offset: const Offset(0, 50),
        color: theme.surface,
        // enabled: false, // Disable the button's own tap handling
        // enableFeedback: false, // Disable haptic feedback on selection
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color:  theme.onSecondary ,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: OutlinedButton(
          onPressed: null, // needed for visual style; PopupMenuButton handles tap
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            side: BorderSide(
              color:  theme.onSecondary,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    selectedItem,
                    style: AppStyles.headingPrimary(
                      context: context,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xffaaa8a8),
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


