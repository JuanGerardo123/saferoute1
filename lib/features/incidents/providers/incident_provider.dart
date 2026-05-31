import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../../data/models/incident_model.dart';
import '../../../data/repositories/incident_repository.dart';
import '../../../data/services/location_service.dart';

class IncidentProvider extends ChangeNotifier {
  final IncidentRepository _repo = IncidentRepository();
  final LocationService _locationService = LocationService();

  List<IncidentModel> incidents = [];
  bool loading = false;
  String error = '';
  IncidentModel? _nearbyDuplicate;
  StreamSubscription<List<IncidentModel>>? _incidentsSub;

  IncidentModel? get nearbyDuplicate => _nearbyDuplicate;

  void listenIncidents() {
    _incidentsSub?.cancel();
    _incidentsSub = _repo.getIncidents().listen((list) {
      incidents = list;
      notifyListeners();
    });
  }

  Future<bool> createIncident({
    required IncidentType type,
    required DangerLevel dangerLevel,
    required String description,
  }) async {
    loading = true;
    error = '';
    _nearbyDuplicate = null;
    notifyListeners();
    try {
      final position = await _locationService.getCurrentPosition();
      final user = FirebaseAuth.instance.currentUser!;

      // Verificar duplicado
      final duplicate = await _repo.getNearbyDuplicate(
        latitude: position.latitude,
        longitude: position.longitude,
        type: type,
      );
      if (duplicate != null) {
        _nearbyDuplicate = duplicate;
        loading = false;
        notifyListeners();
        return false; // hay duplicado, la UI pregunta si confirmar
      }

      final incident = IncidentModel(
        id: '',
        userId: user.uid,
        username: user.email ?? 'usuario',
        type: type,
        dangerLevel: dangerLevel,
        description: description,
        latitude: position.latitude,
        longitude: position.longitude,
        address: 'Ubicación actual',
        createdAt: DateTime.now(),
      );
      await _repo.createIncident(incident);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> resolveIncident(String id) async {
    await _repo.resolveIncident(id);
  }

  Future<void> confirmIncident(String id) async {
    await _repo.confirmIncident(id);
  }

  @override
  void dispose() {
    _incidentsSub?.cancel();
    super.dispose();
  }
}
