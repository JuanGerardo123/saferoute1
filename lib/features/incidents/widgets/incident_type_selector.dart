import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';

class IncidentTypeSelector extends StatelessWidget {
  final IncidentType selected;
  final ValueChanged<IncidentType> onSelected;

  const IncidentTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _types = [
    {'type': IncidentType.bache, 'label': 'Bache', 'icon': Icons.remove_road},
    {'type': IncidentType.choque, 'label': 'Choque', 'icon': Icons.car_crash},
    {'type': IncidentType.trafico, 'label': 'Tráfico', 'icon': Icons.traffic},
    {
      'type': IncidentType.peligro,
      'label': 'Peligro',
      'icon': Icons.warning_amber,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: _types.map((t) {
        final type = t['type'] as IncidentType;
        final isSelected = selected == type;
        return GestureDetector(
          onTap: () => onSelected(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.alertMedium : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.alertMedium : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  t['icon'] as IconData,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  t['label'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
