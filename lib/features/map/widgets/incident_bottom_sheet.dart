import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/incident_model.dart';
import '../../../core/router/app_router.dart';

class IncidentBottomSheet extends StatefulWidget {
  final List<IncidentModel> incidents;
  final IncidentType? selectedType;
  final DangerLevel? selectedDangerLevel;
  final ValueChanged<IncidentType?> onTypeChanged;
  final ValueChanged<DangerLevel?> onDangerLevelChanged;
  final VoidCallback onRefresh;

  const IncidentBottomSheet({
    super.key,
    required this.incidents,
    required this.selectedType,
    required this.selectedDangerLevel,
    required this.onTypeChanged,
    required this.onDangerLevelChanged,
    required this.onRefresh,
  });

  @override
  State<IncidentBottomSheet> createState() => _IncidentBottomSheetState();

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

  String _dangerLabel(DangerLevel level) {
    switch (level) {
      case DangerLevel.bajo:
        return 'Bajo';
      case DangerLevel.medio:
        return 'Medio';
      case DangerLevel.alto:
        return 'Alto';
    }
  }

}

class _IncidentBottomSheetState extends State<IncidentBottomSheet> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
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
          GestureDetector(
            onTap: () => setState(() => _isCollapsed = !_isCollapsed),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Incidencias cercanas',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mostrando ${widget.incidents.length}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onRefresh,
                  icon: const Icon(Icons.refresh, size: 20),
                  color: AppColors.textSecondary,
                  tooltip: 'Recargar',
                ),
                IconButton(
                  onPressed: () => setState(() => _isCollapsed = !_isCollapsed),
                  icon: Icon(
                    _isCollapsed ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  ),
                  color: AppColors.textSecondary,
                  tooltip: _isCollapsed ? 'Expandir' : 'Minimizar',
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.alertMedium,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _isCollapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: SizedBox(height: 8 + bottomInset),
            secondChild: Column(
              children: [
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      ChoiceChip(
                        selected: widget.selectedType == null,
                        label: const Text('Todos'),
                        onSelected: (_) => widget.onTypeChanged(null),
                      ),
                      const SizedBox(width: 8),
                      ...IncidentType.values.map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            selected: widget.selectedType == type,
                            label: Text(widget._typeLabel(type)),
                            onSelected: (_) => widget.onTypeChanged(type),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      ChoiceChip(
                        selected: widget.selectedDangerLevel == null,
                        label: const Text('Todos niveles'),
                        onSelected: (_) => widget.onDangerLevelChanged(null),
                      ),
                      const SizedBox(width: 8),
                      ...DangerLevel.values.map((level) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            selected: widget.selectedDangerLevel == level,
                            label: Text(widget._dangerLabel(level)),
                            onSelected: (_) => widget.onDangerLevelChanged(level),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (widget.incidents.isEmpty)
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
                    itemCount: widget.incidents.length > 5 ? 5 : widget.incidents.length,
                    itemBuilder: (context, i) {
                      final inc = widget.incidents[i];
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
                                color: widget._color(inc.dangerLevel),
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
                                    widget._typeLabel(inc.type),
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
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                SizedBox(height: 12 + bottomInset),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
