import 'package:flutter/material.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/core/constants/constants.dart';

class FrequencySelector extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;

  const FrequencySelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequency',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: List.generate(7, (index) {
            final isSelected = selectedDays.contains(index);
            return ChoiceChip(
              label: Text(AppConstants.dayNames[index]),
              selected: isSelected,
              onSelected: (selected) {
                final newDays = List<int>.from(selectedDays);
                if (selected) {
                  newDays.add(index);
                } else {
                  newDays.remove(index);
                }
                newDays.sort();
                onChanged(newDays);
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.textInversePrimary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: AppColors.surfaceDark,
              shape: const StadiumBorder(),
            );
          }),
        ),
      ],
    );
  }
}
