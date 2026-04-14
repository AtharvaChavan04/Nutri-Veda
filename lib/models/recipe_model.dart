class RecipeModel {
  final String name;
  final int calories;
  final String time;
  final List<String> taste;
  final String digestibility;

  RecipeModel({
    required this.name,
    required this.calories,
    required this.time,
    required this.taste,
    required this.digestibility,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      name: json['name'] ?? '',
      calories: json['calories'] ?? 0,
      time: json['time'] ?? '',
      taste: List<String>.from(json['taste'] ?? []),
      digestibility: json['digestibility'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'time': time,
      'taste': taste,
      'digestibility': digestibility,
    };
  }
}