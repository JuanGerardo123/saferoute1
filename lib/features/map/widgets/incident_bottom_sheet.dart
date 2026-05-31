import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';
import '../../../core/router/app_router.dart';

class IncidentBottomSheet extends StatelessWidget {
  final List<IncidentModel> incidents;

  const IncidentBottomSheet({super.key, required this.incidents});

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

  Color _color(DangerLevel level) {
    switch (level) {
      case DangerLevel.alto:
        return AppColors.alertHigh;
      case DangerLevel.medio:
        return AppColors.alertMedium;
      case DangerLevel.bajo:
        return AppColors.alertLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Incidencias cercanas',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.alertMedium,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.newIncident),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Reportar',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (incidents.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No hay incidencias activas cerca.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incidents.length > 5 ? 5 : incidents.length,
              itemBuilder: (context, i) {
                final inc = incidents[i];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouter.incidentDetail,
                    arguments: inc.id,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(
                          color: _color(inc.dangerLevel),
                          width: 3,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _typeLabel(inc.type),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              inc.address,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                );
              },
            ),
          SizedBox(height: 12 + bottomInset),
        ],
      ),
    );
  }
}
