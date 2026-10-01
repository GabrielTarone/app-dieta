import 'recipe.dart';

class RecipeCollection {
  final String? id;
  final String name;
  final List<Recipe> recipes;

  RecipeCollection({
    this.id,
    required this.name,
    required this.recipes,
  });
}