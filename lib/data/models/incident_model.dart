import 'package:cloud_firestore/cloud_firestore.dart';

enum IncidentType { bache, choque, trafico, peligro }

enum DangerLevel { bajo, medio, alto }

class IncidentModel {
  final String id;
  final String userId;
  final String username;
  final IncidentType type;
  final DangerLevel dangerLevel;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final bool resolved;
  final int confirmations;
  final DateTime createdAt;

  IncidentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.type,
    required this.dangerLevel,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.resolved = false,
    this.confirmations = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'username': username,
    'type': type.name,
    'dangerLevel': dangerLevel.name,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'resolved': resolved,
    'confirmations': confirmations,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory IncidentModel.fromMap(Map<String, dynamic> map) => IncidentModel(
    id: map['id'],
    userId: map['userId'],
    username: map['username'],
    type: IncidentType.values.firstWhere((e) => e.name == map['type']),
    dangerLevel: DangerLevel.values.firstWhere(
      (e) => e.name == map['dangerLevel'],
    ),
    description: map['description'],
    latitude: (map['latitude'] as num).toDouble(),
    longitude: (map['longitude'] as num).toDouble(),
    address: map['address'],
    resolved: map['resolved'] ?? false,
    confirmations: map['confirmations'] ?? 0,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
