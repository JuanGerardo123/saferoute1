import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/services/location_service.dart';

class MapProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  Position? currentPosition;
  bool loading = false;
  String error = '';

  Future<void> loadCurrentLocation() async {
    loading = true;
    error = '';
    notifyListeners();
    try {
      currentPosition = await _locationService.getCurrentPosition();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }
}
