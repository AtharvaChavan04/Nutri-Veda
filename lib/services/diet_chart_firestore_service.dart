import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutri_veda/models/diet_chart_model.dart';

class DietChartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _dietCollection =>
      _firestore.collection('diet_charts');

  // =========================================================
  // ✅ SAVE DIET CHART
  // =========================================================
  Future<void> saveDietChart(DietChart chart) async {
    try {
      await _dietCollection.doc(chart.id).set(chart.toMap());
    } catch (e) {
      throw Exception("Failed to save diet chart: $e");
    }
  }

  // =========================================================
  // ✅ GET DIET CHARTS FOR A PATIENT
  // =========================================================
  Stream<List<DietChart>> getDietCharts(String patientId) {
    return _dietCollection
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DietChart.fromMap(
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  // =========================================================
  // ✅ GET LATEST DIET CHART
  // =========================================================
  Future<DietChart?> getLatestDietChart(String patientId) async {
    final snapshot = await _dietCollection
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return DietChart.fromMap(
      snapshot.docs.first.data() as Map<String, dynamic>,
    );
  }

  Future<DietChart?> getDietChartById(String id) async {
    try {
      final doc = await _dietCollection.doc(id).get();

      if (!doc.exists) return null;

      return DietChart.fromMap(
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception("Failed to fetch diet chart: $e");
    }
  }
}
