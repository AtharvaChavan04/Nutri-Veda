import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  // 🔥 NEW OPTIONAL FIELDS
  final String? phone;
  final String? qualification;
  final String? experience;
  final String? specialization;
  final String? clinicName;
  final String? clinicAddress;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,

    // 🔥 NEW FIELDS
    this.phone,
    this.qualification,
    this.experience,
    this.specialization,
    this.clinicName,
    this.clinicAddress,
  });

  // ---------------- TO MAP ----------------
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'role': role,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),

      // 🔥 NEW FIELDS
      'phone': phone,
      'qualification': qualification,
      'experience': experience,
      'specialization': specialization,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
    };
  }

  // ---------------- FROM MAP ----------------
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'patient',
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),

      // 🔥 NEW FIELDS
      phone: map['phone'],
      qualification: map['qualification'],
      experience: map['experience'],
      specialization: map['specialization'],
      clinicName: map['clinicName'],
      clinicAddress: map['clinicAddress'],
    );
  }

  // ---------------- COPY WITH ----------------
  UserModel copyWith({
    String? fullName,
    String? email,
    String? role,
    bool? isActive,

    // 🔥 NEW FIELDS
    String? phone,
    String? qualification,
    String? experience,
    String? specialization,
    String? clinicName,
    String? clinicAddress,
  }) {
    return UserModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,

      // 🔥 PRESERVE OR UPDATE
      phone: phone ?? this.phone,
      qualification: qualification ?? this.qualification,
      experience: experience ?? this.experience,
      specialization: specialization ?? this.specialization,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
    );
  }
}
