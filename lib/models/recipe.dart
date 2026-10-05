import 'dart:typed_data';

class Recipe {
  final String? id;
  final String? userId;

  final String title;
  final String category;

  final String? imagePath;
  final Uint8List? imageBytes;

  final String time;
  final int timeMinutes;
  final String difficulty;
  final String calories;
  final int caloriesValue;
  final int servings;
  final List<String> diets;
  final List<String> ingredients;
  final List<String> preparation;

  const Recipe({
    this.id,
    this.userId,
    required this.title,
    required this.category,
    this.imagePath,
    this.imageBytes,
    required this.time,
    required this.timeMinutes,
    required this.difficulty,
    required this.calories,
    required this.caloriesValue,
    this.servings = 1,
    required this.diets,
    required this.ingredients,
    required this.preparation,
  });
}