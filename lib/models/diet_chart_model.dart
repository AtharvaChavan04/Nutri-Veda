import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutri_veda/models/diet_plan_model.dart';

class DietChart {
  final String id;
  final String patientId;
  final String patientEmail; 
  final String doctorId;
  final DateTime createdAt;
  final DietPlanModel dietPlan;

  DietChart({
    required this.id,
    required this.patientId,
    required this.patientEmail, 
    required this.doctorId,
    required this.createdAt,
    required this.dietPlan,
  });

  // =========================================================
  // ✅ TO MAP (Firestore)
  // =========================================================
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'patientEmail': patientEmail, 
      'doctorId': doctorId,
      'createdAt': Timestamp.fromDate(createdAt), 
      'dietPlan': dietPlan.toJson(),
    };
  }

  // =========================================================
  // ✅ FROM MAP (SAFE PARSING)
  // =========================================================
  factory DietChart.fromMap(Map<String, dynamic> map) {
    return DietChart(
      id: map['id'] ?? '',
      patientId: map['patientId'] ?? '',
      patientEmail: map['patientEmail'] ?? '', 
      doctorId: map['doctorId'] ?? '',
      createdAt: _parseDate(map['createdAt']),
      dietPlan: DietPlanModel.fromJson(
        map['dietPlan'] ?? {},
      ),
    );
  }

  // =========================================================
  // 🔥 HANDLE MULTIPLE DATE FORMATS
  // =========================================================
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    // Firestore Timestamp
    if (value is Timestamp) {
      return value.toDate();
    }

    // ISO String (fallback for old data)
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}
