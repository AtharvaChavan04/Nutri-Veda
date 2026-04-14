import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:nutri_veda/models/diet_chart_model.dart';
import 'package:nutri_veda/models/doctor_patient_model.dart';

class PdfService {
  Future<void> generateAndPrintDietChart({
    required DietChart chart,
    required DoctorPatient patient,
    required String doctorName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _header(patient),
          pw.SizedBox(height: 20),
          _mealSection("Breakfast", chart.dietPlan.breakfast),
          _mealSection("Lunch", chart.dietPlan.lunch),
          _mealSection("Dinner", chart.dietPlan.dinner),
          _mealSection("Snacks", chart.dietPlan.snacks),
          pw.SizedBox(height: 20),
          _footer(doctorName),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // ---------------- HEADER (PATIENT DETAILS) ----------------
  pw.Widget _header(DoctorPatient patient) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "NutriVeda Diet Chart",
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text("Patient Name: ${patient.name}"),
        pw.Text("Email: ${patient.email}"),
        pw.Text("Contact: ${patient.contactNumber}"),
        pw.SizedBox(height: 8),
        pw.Text(
          "Generated on: ${DateTime.now().toLocal().toString().split(' ')[0]}",
        ),
        pw.Divider(),
      ],
    );
  }

  // ---------------- MEAL SECTION ----------------
  pw.Widget _mealSection(String title, List recipes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        if (recipes.isEmpty)
          pw.Text("No items")
        else
          ...recipes.map((recipe) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Text(
                "- ${recipe.name} (${recipe.calories} kcal)",
              ),
            );
          }).toList(),
        pw.SizedBox(height: 12),
      ],
    );
  }

  // ---------------- FOOTER ----------------
  pw.Widget _footer(String doctorName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          "Dr. $doctorName",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text("Doctor Signature"),
        pw.SizedBox(height: 20),
        pw.Text("________________________"),
      ],
    );
  }
}
