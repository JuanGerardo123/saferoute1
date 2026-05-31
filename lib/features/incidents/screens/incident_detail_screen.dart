import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';
import '../providers/incident_provider.dart';
import '../widgets/resolve_button.dart';
import '../../../shared/danger_badge.dart';

class IncidentDetailScreen extends StatefulWidget {
  final String incidentId;
  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  bool _resolving = false;
  bool _confirming = false;

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

  IconData _typeIcon(IncidentType type) {
    switch (type) {
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

  Color _dangerColor(DangerLevel level) {
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

  Future<void> _resolve(IncidentModel incident) async {
    setState(() => _resolving = true);
    await context.read<IncidentProvider>().resolveIncident(incident.id);
    if (!mounted) return;
    setState(() => _resolving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Incidencia marcada como resuelta.'),
        backgroundColor: AppColors.resolved,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _confirm(IncidentModel incident) async {
    setState(() => _confirming = true);
    await context.read<IncidentProvider>().confirmIncident(incident.id);
    if (!mounted) return;
    setState(() => _confirming = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Gracias por confirmar el reporte!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidents = context.watch<IncidentProvider>().incidents;
    final incident = incidents.firstWhere(
      (i) => i.id == widget.incidentId,
      orElse: () => IncidentModel(
        id: '',
        userId: '',
        username: '',
        type: IncidentType.bache,
        dangerLevel: DangerLevel.bajo,
        description: 'No encontrado',
        latitude: 0,
        longitude: 0,
        address: '',
        createdAt: DateTime.now(),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textSecondary,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado tipo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(
                    color: _dangerColor(incident.dangerLevel),
                    width: 4,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _typeIcon(incident.type),
                    color: _dangerColor(incident.dangerLevel),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _typeLabel(incident.type),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DangerBadge(level: incident.dangerLevel),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Info
            _infoRow(Icons.map_outlined, 'Ubicación', incident.address),
            const SizedBox(height: 12),
            _infoRow(
              Icons.access_time,
              'Reportado',
              _timeAgo(incident.createdAt),
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.person_outline, 'Reportado por', incident.username),
            const SizedBox(height: 20),

            // Descripción
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    incident.description,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Confirmaciones
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.thumb_up_outlined,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${incident.confirmations} usuarios confirmaron',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _confirming ? null : () => _confirm(incident),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _confirming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : const Text(
                              'También lo vi',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botón resolver
            ResolveButton(
              loading: _resolving,
              onPressed: () => _resolve(incident),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
