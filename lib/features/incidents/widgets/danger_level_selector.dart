import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';

class DangerLevelSelector extends StatelessWidget {
  final DangerLevel selected;
  final ValueChanged<DangerLevel> onSelected;

  const DangerLevelSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _levels = [
    {'level': DangerLevel.bajo, 'label': 'Bajo', 'color': AppColors.alertLow},
    {
      'level': DangerLevel.medio,
      'label': 'Medio',
      'color': AppColors.alertMedium,
    },
    {'level': DangerLevel.alto, 'label': 'Alto', 'color': AppColors.alertHigh},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _levels.map((l) {
        final level = l['level'] as DangerLevel;
        final color = l['color'] as Color;
        final isSelected = selected == level;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(level),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? color : AppColors.border,
                ),
              ),
              child: Text(
                l['label'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
