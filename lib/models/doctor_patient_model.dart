import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorPatient {
  final String id;
  final String doctorId;
  final String name;
  final int age;
  final String gender;
  final double weight;
  final String email;
  final String contactNumber;
  final double? height;
  final String? bloodGroup;
  final List<String> conditions;
  final List<String> allergies;
  final DateTime createdAt;

  final bool hasDietChart;
  final String? dietChartId;
  final DateTime? dietChartGeneratedAt;

  DoctorPatient({
    required this.id,
    required this.doctorId,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    this.height,
    this.bloodGroup,
    required this.email,
    required this.contactNumber,
    required this.conditions,
    required this.allergies,
    required this.createdAt,
    required this.hasDietChart,
    this.dietChartId,
    this.dietChartGeneratedAt,
  });

  // ---------------- FIRESTORE → MODEL ----------------
  factory DoctorPatient.fromMap(Map<String, dynamic> map, String documentId) {
    return DoctorPatient(
      id: documentId,
      doctorId: map['doctorId'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      email: map['email'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      height: (map['height'] as num?)?.toDouble(),
      bloodGroup: map['bloodGroup'],
      conditions: List<String>.from(map['conditions'] ?? []),
      allergies: List<String>.from(map['allergies'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      hasDietChart: map['hasDietChart'] ?? false,
      dietChartId: map['dietChartId'],
      dietChartGeneratedAt: map['dietChartGeneratedAt'] != null
          ? (map['dietChartGeneratedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // ---------------- MODEL → FIRESTORE ----------------
  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'email': email,
      'contactNumber': contactNumber,
      'height': height,
      'bloodGroup': bloodGroup,
      'conditions': conditions,
      'allergies': allergies,
      'createdAt': Timestamp.fromDate(createdAt),
      'hasDietChart': hasDietChart,
      'dietChartId': dietChartId,
      'dietChartGeneratedAt': dietChartGeneratedAt != null
          ? Timestamp.fromDate(dietChartGeneratedAt!)
          : null,
    };
  }

  // ---------------- TIME AGO FOR PATIENT CREATION ----------------
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return 'Just now';
    }
  }

  // ---------------- TIME AGO FOR DIET CHART ----------------
  String get dietChartTimeAgo {
    if (dietChartGeneratedAt == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dietChartGeneratedAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return 'Just now';
    }
  }

  // ---------------- DISPLAY CONDITIONS ----------------
  List<String> get displayConditions {
    return conditions.take(2).toList();
  }

  bool get hasMoreConditions => conditions.length > 2;

  DoctorPatient copyWith({
    String? id,
    String? doctorId,
    String? name,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? bloodGroup,
    String? contactNumber,
    String? email,
    List<String>? conditions,
    List<String>? allergies,
    bool? hasDietChart,
    DateTime? createdAt,
    String? dietChartId, // ✅ ADD
    DateTime? dietChartGeneratedAt, // ✅ ADD
  }) {
    return DoctorPatient(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      conditions: conditions ?? this.conditions,
      allergies: allergies ?? this.allergies,
      hasDietChart: hasDietChart ?? this.hasDietChart,
      dietChartId: dietChartId ?? this.dietChartId, 
      dietChartGeneratedAt:
          dietChartGeneratedAt ?? this.dietChartGeneratedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
