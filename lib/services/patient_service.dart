import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';

class PatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Collection reference
  CollectionReference get _patientsCollection =>
      _firestore.collection('patients');

  // =========================================================
  // ✅ ADD PATIENT
  // =========================================================
  Future<void> addPatient(DoctorPatient patient) async {
    try {
      await _patientsCollection.doc(patient.id).set(patient.toMap());
    } catch (e) {
      throw Exception('Failed to add patient: $e');
    }
  }

  // =========================================================
  // ✅ GET ALL PATIENTS (REAL-TIME STREAM)
  // =========================================================
  Stream<List<DoctorPatient>> getPatients(String doctorId) {
    return _patientsCollection
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DoctorPatient.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // =========================================================
  // ✅ GET PENDING DIET CHART PATIENTS
  // =========================================================
  Stream<List<DoctorPatient>> getPendingPatients(String doctorId) {
    return _patientsCollection
        .where('doctorId', isEqualTo: doctorId)
        .where('hasDietChart', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DoctorPatient.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // =========================================================
  // ✅ UPDATE PATIENT
  // =========================================================
  Future<void> updatePatient(DoctorPatient patient) async {
    try {
      await _patientsCollection.doc(patient.id).update(patient.toMap());
    } catch (e) {
      throw Exception('Failed to update patient: $e');
    }
  }

  // =========================================================
  // ✅ DELETE PATIENT
  // =========================================================
  Future<void> deletePatient(String patientId) async {
    try {
      await _patientsCollection.doc(patientId).delete();
    } catch (e) {
      throw Exception('Failed to delete patient: $e');
    }
  }
}
