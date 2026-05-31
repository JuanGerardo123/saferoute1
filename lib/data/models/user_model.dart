import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'username': username,
    'email': email,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'],
    username: map['username'],
    email: map['email'],
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
