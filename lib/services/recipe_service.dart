import '../models/recipe.dart';

abstract interface class RecipeService {
  Future<List<Recipe>> listarReceitas();

  Future<void> criarReceita(Recipe receita);

  Future<void> atualizarReceita(String id, Recipe receita);

  Future<void> excluirReceita(String id);
}