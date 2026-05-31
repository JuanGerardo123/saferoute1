import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';
import '../../../shared/danger_badge.dart';

class IncidentCard extends StatelessWidget {
  final IncidentModel incident;
  final VoidCallback onTap;

  const IncidentCard({super.key, required this.incident, required this.onTap});

  String _typeLabel(IncidentType type) {
    switch (type) {
      case IncidentType.bache:
        return 'Bache';
      case IncidentType.choque:
        return 'Choque';
      case IncidentType.trafico:
        return 'Tráfico';
      case IncidentType.peligro:
        return 'Zona peligrosa';
    }
  }

  Color _borderColor(DangerLevel level) {
    switch (level) {
      case DangerLevel.alto:
        return AppColors.alertHigh;
      case DangerLevel.medio:
        return AppColors.alertMedium;
      case DangerLevel.bajo:
        return AppColors.alertLow;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    return 'hace ${diff.inDays} días';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
              color: _borderColor(incident.dangerLevel),
              width: 4,
            ),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _typeLabel(incident.type),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    incident.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      DangerBadge(level: incident.dangerLevel),
                      const SizedBox(width: 8),
                      Text(
                        _timeAgo(incident.createdAt),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
