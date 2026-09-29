import 'dart:typed_data';

class Recipe {
  final String title;
  final String category;

  final String? imagePath;
  final Uint8List? imageBytes;

  final String time;
  final int timeMinutes;
  final String difficulty;
  final String calories;
  final int caloriesValue;
  final List<String> diets;
  final List<String> ingredients;
  final List<String> preparation;

  const Recipe({
    required this.title,
    required this.category,
    this.imagePath,
    this.imageBytes,
    required this.time,
    required this.timeMinutes,
    required this.difficulty,
    required this.calories,
    required this.caloriesValue,
    required this.diets,
    required this.ingredients,
    required this.preparation,
  });
}