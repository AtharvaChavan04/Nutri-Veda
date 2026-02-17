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
  final List<String> goals;
  final DateTime createdAt;
  final bool hasDietChart;
  final String? dietChartId;

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
    required this.goals,
    required this.createdAt,
    required this.hasDietChart,
    this.dietChartId,
  });

  // Helper method to get formatted time ago
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

  // Get first 2 conditions for display
  List<String> get displayConditions {
    return conditions.take(2).toList();
  }

  // Check if there are more than 2 conditions
  bool get hasMoreConditions => conditions.length > 2;
}
