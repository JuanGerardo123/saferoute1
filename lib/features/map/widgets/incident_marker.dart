import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';

class IncidentMarkerWidget extends StatelessWidget {
  final IncidentModel incident;

  const IncidentMarkerWidget({super.key, required this.incident});

  Color get _color {
    if (incident.resolved) return AppColors.resolved;
    switch (incident.dangerLevel) {
      case DangerLevel.alto:
        return AppColors.alertHigh;
      case DangerLevel.medio:
        return AppColors.alertMedium;
      case DangerLevel.bajo:
        return AppColors.alertLow;
    }
  }

  IconData get _icon {
    switch (incident.type) {
      case IncidentType.bache:
        return Icons.remove_road;
      case IncidentType.choque:
        return Icons.car_crash;
      case IncidentType.trafico:
        return Icons.traffic;
      case IncidentType.peligro:
        return Icons.warning_amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: _color.withValues(alpha: 0.4), blurRadius: 8),
        ],
      ),
      child: Icon(_icon, color: Colors.white, size: 18),
    );
  }
}
