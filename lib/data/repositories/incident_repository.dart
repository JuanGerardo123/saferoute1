import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incident_model.dart';

class IncidentRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'incidents';

  Stream<List<IncidentModel>> getIncidents() {
    return _db
        .collection(_collection)
        .where('resolved', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => IncidentModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> createIncident(IncidentModel incident) async {
    final docRef = _db.collection(_collection).doc();
    final withId = IncidentModel(
      id: docRef.id,
      userId: incident.userId,
      username: incident.username,
      type: incident.type,
      dangerLevel: incident.dangerLevel,
      description: incident.description,
      latitude: incident.latitude,
      longitude: incident.longitude,
      address: incident.address,
      createdAt: incident.createdAt,
    );
    await docRef.set(withId.toMap());
  }

  Future<void> resolveIncident(String id) async {
    await _db.collection(_collection).doc(id).update({'resolved': true});
  }

  Future<void> confirmIncident(String id) async {
    await _db.collection(_collection).doc(id).update({
      'confirmations': FieldValue.increment(1),
    });
  }

  Future<IncidentModel?> getNearbyDuplicate({
    required double latitude,
    required double longitude,
    required IncidentType type,
  }) async {
    final snap = await _db
        .collection(_collection)
        .where('resolved', isEqualTo: false)
        .where('type', isEqualTo: type.name)
        .get();

    for (final doc in snap.docs) {
      final incident = IncidentModel.fromMap(doc.data());
      final distance = _distanceInMeters(
        latitude,
        longitude,
        incident.latitude,
        incident.longitude,
      );
      if (distance <= 200) return incident;
    }
    return null;
  }

  double _distanceInMeters(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final lat1Rad = _toRad(lat1);
    final lat2Rad = _toRad(lat2);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) * math.pow(math.sin(dLon / 2), 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRad(double deg) => deg * 3.141592653589793 / 180;
}
