import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/incident_model.dart';
import '../../../features/incidents/providers/incident_provider.dart';
import '../providers/map_provider.dart';
import '../widgets/incident_marker.dart';
import '../widgets/incident_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  IncidentType? _selectedType;
  DangerLevel? _selectedDangerLevel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapProvider>().loadCurrentLocation();
      context.read<IncidentProvider>().listenIncidents();
    });
  }

  List<IncidentModel> _filteredIncidents(List<IncidentModel> incidents) {
    return incidents.where((inc) {
      final typeMatches = _selectedType == null || inc.type == _selectedType;
      final levelMatches =
          _selectedDangerLevel == null ||
          inc.dangerLevel == _selectedDangerLevel;
      return typeMatches && levelMatches;
    }).toList();
  }

  Future<void> _refreshData() async {
    final mapProvider = context.read<MapProvider>();
    context.read<IncidentProvider>().listenIncidents();
    await mapProvider.loadCurrentLocation();
    if (!mounted) return;
    if (mapProvider.error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mapProvider.error),
          backgroundColor: AppColors.alertHigh,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mapa e incidencias actualizados'),
          backgroundColor: AppColors.resolved,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapProv = context.watch<MapProvider>();
    final incProv = context.watch<IncidentProvider>();
    final filteredIncidents = _filteredIncidents(incProv.incidents);
    final center = mapProv.currentPosition != null
        ? LatLng(
            mapProv.currentPosition!.latitude,
            mapProv.currentPosition!.longitude,
          )
        : const LatLng(20.6597, -103.3496);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(initialCenter: center, initialZoom: 14),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.saferoute',
                    ),
                    MarkerLayer(
                      markers: filteredIncidents.map((inc) {
                        return Marker(
                          point: LatLng(inc.latitude, inc.longitude),
                          width: 36,
                          height: 36,
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRouter.incidentDetail,
                              arguments: inc.id,
                            ),
                            child: IncidentMarkerWidget(incident: inc),
                          ),
                        );
                      }).toList(),
                    ),
                    if (mapProv.currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: center,
                            width: 20,
                            height: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Safe',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'Route',
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _refreshData,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.refresh,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRouter.profile,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Material(
                    color: AppColors.surface,
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: mapProv.currentPosition != null
                          ? () => _mapController.move(center, 14)
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IncidentBottomSheet(
            incidents: filteredIncidents,
            selectedType: _selectedType,
            selectedDangerLevel: _selectedDangerLevel,
            onTypeChanged: (type) {
              setState(() => _selectedType = type);
            },
            onDangerLevelChanged: (level) {
              setState(() => _selectedDangerLevel = level);
            },
            onRefresh: _refreshData,
          ),
        ],
      ),
    );
  }
}
